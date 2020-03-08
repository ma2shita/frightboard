module Me
  extend self
  def root
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  def env
    (ENV['RACK_ENV'] || "development").to_sym
  end

  def production?
    Me.env == :production
  end

  def development?
    Me.env == :development
  end

  def test?
    Me.env == :test
  end

  def version
    "1.1.0"
  end
end

require "bundler"
require "json"
require "grape"
require "grape-entity"
require "sequel"
require "chiliflake"

# e.g.) DATABASE_URL="postgres://user:password@localhost/my_db"
DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://')

if Me.development? || Me.test?
  require "pry-byebug"
  require 'logger'
  DB.loggers << Logger.new($stderr)
end
