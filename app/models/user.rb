require 'bcrypt'

class User < ActiveRecord::Base
	# new columns need to be added here to be writable through mass assignment
	attr_accessible :username, :email, :password, :password_confirmation, :password_hash, :password_salt, :payed, :user_group_ids, :account_balance, :pending_order_sound
	attr_accessor :password
	before_save :prepare_password
	before_save :init_balance

	scope :payed, -> { where("payed = ?", true) }

	validates_presence_of :username, :email
	validates_uniqueness_of :username, :email, :allow_blank => true
	# TODO Rails 4 complains about the regex
	validates_format_of :username, :with => /\A[-\w\._@]+\z/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
	validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
	validates_presence_of :password, :on => :create
	validates_confirmation_of :password
	validates_length_of :password, :minimum => 4, :allow_blank => true

	has_and_belongs_to_many :user_groups, :join_table => "user_groups_users"
	has_many :logs

	# login can be either username or email address
	def self.authenticate(login, pass)
		user = find_by_username(login) || find_by_email(login)
		return user if user && user.password_hash == user.encrypt_password(pass)
	end

	def encrypt_password(pass)
		BCrypt::Engine.hash_secret(pass, password_salt)
	end

	def access_allowed?(access_type)
		allowed = false
		user_groups.find_each { |group|
			allowed ||= group.allows_access?(access_type)
		}
		allowed
	end

	def self.smsg_generate_checksum val
		mod = val % 97
		return mod == 0 ? 97 : mod
	end

	def structured_message
		id_str = sprintf "%010d", id
		checksum = sprintf "%02d", User.smsg_generate_checksum(id)
		"+++#{id_str[0..2]}/#{id_str[3..6]}/#{id_str[7..9]}#{checksum}+++"
	end

	def self.find_by_structured_message msg
		m = /(?:\+|\*){,3}(\d{3})\/?(\d{4})\/?(\d{3})(\d{2})(?:\+|\*){,3}/.match(msg)

		raise "invalid structured message: #{msg}" if m.nil?

		requested_id = (m[1] + m[2] + m[3]).to_i
		calculated_checksum = smsg_generate_checksum(requested_id)
		message_checksum = m[4].to_i

		raise "wrong structured message checksum in #{msg}: expected #{calculated_checksum}, got #{message_checksum}." if calculated_checksum != message_checksum

		self.find(requested_id)
	end

	def all_badges
		badges = []
		user_groups.each { |user_group|
			badge_url = user_group.badge_url(:badge)
			badges.push({ :image_url => badge_url, :title => user_group.description }) if badge_url
		}
		badges
	end

	def init_balance
		self.account_balance ||= BigDecimal.new("0")
	end

	def sound_or_default_name
		pending_order_sound || "Bloom"
	end

	def self.build_sound_info(sound_name)
		{ :name => sound_name,
		  :files => [{:ext => "mp3", :type => "audio/mpeg"},
		             {:ext => "wav", :type => "audio/wav"}].map do |type_info|
		               { :file => sound_name + "." + type_info[:ext],
		                 :type => type_info[:type] }
			           end }
	end

	def sound_or_default
		self.class.build_sound_info sound_or_default_name
	end

	def self.all_sounds
		%w(Bloom Concern Connected Full Gentle\ Roll High\ Boom Hollow Hope Jump\ Down Jump\ Up Looking\ Down Looking\ Up
		   Nudge Picked Puff Realization Second\ Glance Stumble Suspended Turn Unsure Metal\ Gear\ Solid\ -\ Alert).map { |sound| build_sound_info(sound) }
	end

	private

	def prepare_password
		unless password.blank?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = encrypt_password(password)
		end
	end
end
