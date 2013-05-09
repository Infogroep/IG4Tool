source 'https://rubygems.org'

# OSX is darwin
def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rails', '4.0.0.rc1'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
gem 'bootstrap-sass'
gem 'sass-rails',   '~> 4.0.0.rc1'
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.11.3', :platform => :ruby
gem 'jquery-datatables-rails'
gem 'font-awesome-sass-rails'

gem 'uglifier', '>= 1.3.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'÷

group :development, :test do
  gem "capybara"
  gem "launchy"
  gem 'rspec', '>= 2.8.1'
  gem 'rspec-rails', '>= 2.8.1'
  gem 'shoulda', '>= 2.11.3'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
	gem 'nifty-generators'
	gem 'bcrypt-ruby', :require => 'bcrypt'
	gem 'faker'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'spork'
end

group :production do
  gem 'mysql2'
end

gem 'bcrypt-ruby'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'carrierwave'
gem 'simple_form', github: 'plataformatec/simple_form', branch: 'v3.0.0.beta1'
gem 'chosen-rails'
gem 'ckeditor'
gem 'mini_magick'

gem 'simplecov'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# Notification
gem 'rb-fsevent', require: darwin_only('rb-fsevent')
#gem 'growl',      require: darwin_only('growl')
gem 'rb-inotify', require: linux_only('rb-inotify')

# add these gems to help with the transition to rails 4:
gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Deploy with Capistrano
# gem 'capistrano'

gem "mocha", :group => :test
