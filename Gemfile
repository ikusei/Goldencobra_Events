source "http://rubygems.org"

# Declare your gem's dependencies in goldencobra-events.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'activeadmin', :git => "git://github.com/ikusei/active_admin.git", :require => "activeadmin"
gem 'goldencobra', :git => 'ssh://git@git.ikusei.de:7999/GC/basis-modul.git'
gem 'goldencobra_email_templates', :git => "git://github.com/ikusei/goldencobra_email_templates.git"
gem 'acts-as-taggable-on', git: 'git://github.com/mbleigh/acts-as-taggable-on.git'
gem 'compass-rails'
gem 'coffee-rails'
gem 'sass'
gem 'mail'

gem "rspec-rails", :group => [:test, :development] # rspec in dev so the rake tasks run properly
gem 'roadie'
gem 'uglifier', '>= 1.0.3'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'

group :development do
  gem 'unicorn'
  gem 'thin'
  gem 'git-pivotal'
  gem 'guard-annotate'
  gem 'pry'
  gem 'rails-pry'
  gem 'brakeman'
  gem 'hirb'
  gem 'powder'
end

group :test do
  gem 'mysql2'
  gem 'cucumber'
  gem 'cucumber-rails', '~> 1.3.0'
  gem "factory_girl_rails", :git => "git://github.com/thoughtbot/factory_girl_rails.git"
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-livereload'
  gem 'rb-fsevent', '~> 0.9.1'#, :git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off'
  gem 'growl'
  gem 'launchy'
  gem 'spork'
  gem 'email_spec'
end
