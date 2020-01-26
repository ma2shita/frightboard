source "https://rubygems.org"
ruby "~> 2.5.0"

gem "rake"

gem "rack"
gem "sinatra"
gem "sinatra-contrib"

gem "grape", github: "ruby-grape/grape"
gem "grape-entity", github: "ruby-grape/grape-entity"
gem "sequel"
gem "pg"

group :development, :test do
  gem "sqlite3"
  gem "pry"
  gem "pry-byebug"
end

group :test do
  gem "rack-test"
  gem "rspec"
  gem "rspec-its"
  gem "rspec-json_matcher"
end
