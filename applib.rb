# Dynamic create for On memory by SQLite
if DB.database_type == :sqlite && DB.opts[:database].empty?
  DB.create_table :boards do
    primary_key :rno
    String :board_id
    Time   :created_at
    add_index [:board_id], unique: true
  end
  DB.create_table :items do
    primary_key :rno
    String :board_id
    String :iid
    String :status
    Text   :annotation
    Time   :created_at
    Time   :updated_at
    add_index [:board_id, :iid], unique: true
  end
end

class Board < Sequel::Model
  plugin :timestamps
end

class Item < Sequel::Model
  plugin :timestamps, update_on_create: true
  plugin :serialization
  serialize_attributes :marshal, :annotation
end

module Helper ; end
class Helper::ItemModel
  def self.upsert(board_id, iid, status = "unknown", annotation = {})
    raise if Board.where(board_id: board_id).empty?
    ds = Item.where(board_id: board_id, iid: iid)
    if ds.count == 0
      Item.create(board_id: board_id, iid: iid, status: status, annotation: annotation)
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
