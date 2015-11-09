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
end

require "bundler"
require "json"
require "grape"
require "sequel"
require "pry"
if Me.development? || Me.test?
  require "pry-byebug"
end

require_relative "api"
