module API
  module Entities
    class Status < Grape::Entity
      expose :board_id
      expose :iid
      expose :status
      expose :created_at
      expose :updated_at
      expose :annotation
    end
  end
end

class FrightBoard::API < Grape::API
  prefix :api
  version :v1, using: :path
  format :json
  rescue_from RuntimeError do
    error!({error: "Board Not Found"}, 404)
  end

  namespace ':board_id' do
    params do
      requires :board_id,   type: String,                     desc: "Unique in system"
      requires :iid,        type: String,                     desc: "Identify key (Unique in board)"
      optional :status,     type: String, default: "updated", desc: "IID's latest status"
      optional :annotation, type: JSON,                       desc: "Annotate data"
    end
    post do # Create shared with Update (PUT does not implement)
      d_params = declared(params)
      r = Helper::ItemModel.upsert(d_params["board_id"], d_params["iid"], d_params["status"], d_params["annotation"])
      status 200 if r == :updated
      {response: r}
    end

    params do
      requires :board_id, type: String, desc: "Unique in system"
    end
    get do
      d_params = declared(params)
      r = Item.where(board_id: d_params["board_id"]).all
      present r, with: API::Entities::Status
    end

    params do
      requires :board_id, type: String, desc: "Unique in system"
      requires :iid,      type: String, desc: "Identify Key (Unique on System)"
    end
    delete do
      d_params = declared(params)
      Item.where(board_id: d_params["board_id"], iid: d_params["iid"]).delete
      status 202
      {response: :accepted}
    end
  end
end
