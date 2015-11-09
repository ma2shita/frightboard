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
require "grape-entity"
require "sequel"
require "pry"
if Me.development? || Me.test?
  require "pry-byebug"
end

DB = Sequel.sqlite

DB.create_table :items do
  primary_key :rno
  String      :iid
  String      :status
  String      :data
  Time        :created_at
  Time        :updated_at
end
class Item < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :serialization
  serialize_attributes :marshal, :data
end

module Helper ; end
class Helper::ItemModel
  def self.upsert(iid, status = "unknown", data = {})
    ds = Item.where(iid: iid)
    if ds.count == 0
      Item.create(iid: iid, status: status, data: data)
      :created
    else
      # NOTE: WORKAROUND: #update(Hash) で Hashが渡されると where句と認識されてしまうため、serializationが難しい。一つづつ代入することにする
      d = ds.first
      d.status = status
      d.data = data
      d.save
      :updated
    end
  end
end

module WorkingDashboard ; end
require_relative "api"
