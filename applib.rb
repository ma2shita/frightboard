# Dynamic create for On memory by SQLite
if DB.database_type == :sqlite && DB.opts[:database].empty?
  DB.create_table :items do
    primary_key :rno
    String      :iid
    String      :status
    Text        :annotation
    Time        :created_at
    Time        :updated_at
  end
end

class Item < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :serialization
  serialize_attributes :marshal, :annotation
end

module Helper ; end
class Helper::ItemModel
  def self.upsert(iid, status = "unknown", annotation = {})
    ds = Item.where(iid: iid)
    if ds.count == 0
      Item.create(iid: iid, status: status, annotation: annotation)
      :created
    else
      # NOTE: WORKAROUND: #update(Hash) で Hashが渡されると where句と認識されてしまうため、serializationが難しい。一つづつ代入することにする
      d = ds.first
      d.status = status
      d.annotation = annotation if annotation.present?
      d.save
      :updated
    end
  end
end

module FrightBoard ; end
require_relative "web"
require_relative "api"
