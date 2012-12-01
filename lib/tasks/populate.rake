namespace :db do
	desc "populates the database"

	task :populate => :environment do
		require 'lanparty_faker'
		@amount = 10

		User.delete_all
		puts "--------------"
		puts "Creating Users"
		puts "--------------"
		User.create(
			:username => "Enermis",
			:email => "fulgens.ailurus@gmail.com",
			:password => "roeland1",
			:password_confirmation => "roeland1"
		)
		puts "created Enermis"
		@amount.times do
			password = Faker::Lorem.characters 10
			user = User.new(
				:username => Faker::Internet.user_name,
				:email => Faker::Internet.email,
				:password => password,
				:password_confirmation => password
			)
			if user.valid?
				user.save!
				puts "created user #{user.username}"
			else
				puts "tried to create user #{user.username} but failed"
			end
		end

		StoreItem.delete_all
		Barcode.delete_all
		puts ""
		puts "--------------"
		puts "Creating StoreItems"
		puts "--------------"
		@amount.times do
			store_item = StoreItem.new(
				:name => Faker::Name.name,
				:purchase_price => rand(100),
				:store_item_type => ['Drinks','Foods','Goodies','Etc'].sample
			)
			(1..3).to_a.sample.times do
				barcode = Barcode.new(
					:code => (0...10).map{ ('a'..'z').to_a[rand(26)] }.join
					)
				barcode.store_item = store_item
				barcode.save!
				puts "\tcreated barcode #{barcode.code}" 
			end
			if store_item.valid?
				store_item.save!
				puts "created store_item #{store_item.name}"
			else
				puts "tried to create store_item #{store_item.name} but failed"
			end
		end

		Game.delete_all
		Compo.delete_all
		Team.delete_all
		puts ""
		puts "--------------"
		puts "Creating Games"
		puts "--------------"
		@amount.times do
			game = Game.new(
				:download_location => Faker::Internet.url,
				:info => Faker::Lorem.paragraph,
				:name => Faker::Game.name
			)
			if game.valid?
				game.save!
				puts "created game #{game.name}"
				(1..3).to_a.sample.times do
					compo = Compo.new(
						:date_time => (1..5000).to_a.sample.hours.ago,
						:slots => rand(10),
						:info => Faker::Lorem.paragraph,
						:group_size => rand(5),
						:game_id => game.id
					)
					if compo.valid?
						compo.save
						puts "\tcreated compo for game #{game.name}"
						rand(@amount).times do
							team = Team.new(
								:name => Faker::Name.name,
								:compo_id => compo.id
							)
							if team.valid?
								team.save
								puts "\t\tCreating team #{team.name} for #{compo.game.name}"
							else
								puts "\t\ttried to create team #{team.name} for #{compo.game.name} but failed"
							end
						end
					else
						puts "\ttried to create game #{game.name} but failed"
					end
				end
			else
				puts "tried to create game #{game.name} but failed"
			end
		end

		puts ""
		puts "--------------"
		puts "populate teams"
		puts "--------------"
		Team.all.each do |team|
			rand(team.compo.group_size+1).times do
				user = User.all.sample
				if not team.users.include? user
					team.users << user
					puts "adding #{user.username} to team #{team.name} for #{team.compo.game.name}"
				end
			end
		end

	end
end
