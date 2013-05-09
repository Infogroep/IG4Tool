class PagesController < ApplicationController
	before_filter :login_required, :only => :admin
	before_filter(:only => :admin) { true_required(admin_accessible) }

	def home
	end

	def info

	end

	def location

	end

	def contact

	end

	def faq

	end

	def signup_finished

	end

	def admin

	end
end
