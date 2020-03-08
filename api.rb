module API
  module Entities
    class Board < Grape::Entity
      expose :board_id
      expose :created_at
    end

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

  get do
    r = Board.order(Sequel.desc(:created_at)).all
    present r, with: API::Entities::Board
  end

  post do
    board_id = ChiliFlake.new(1).generate
    Board.create(board_id: board_id)
    redirect "/#{board_id}"
  end

  namespace ':board_id' do
    after_validation do
      error!({error: "Board Not Found"}, 404) if Board.where(board_id: params[:board_id]).empty?
    end

    params do
      requires :iid,        type: String,                     desc: "Identify key (Unique in board)"
      optional :status,     type: String, default: "updated", desc: "IID's latest status"
      optional :annotation, type: JSON,                       desc: "Annotate data"
    end
    post do # Create shared with Update (PUT does not implement)
      d_params = declared(params)
      r = Helper::ItemModel.upsert(params[:board_id], d_params[:iid], d_params[:status], d_params[:annotation])
      status 200 if r == :updated
      {response: r}
    end

    params do
      optional :order_by_updated_at, type: String, values: ['asc', 'desc'], desc: "Sort order by updated_at"
    end
    get do
      d_params = declared(params)
      ds = Item.where(board_id: params[:board_id])
      ds = if d_params[:order_by_updated_at].nil?
        ds.order(Sequel.asc(:created_at))
      else
        ds.order(Sequel.send(d_params[:order_by_updated_at], :updated_at))
      end
      r = ds.all
      present r, with: API::Entities::Status
    end

    delete do
      d_params = declared(params)
      Board.where(board_id: params[:board_id]).delete
      Item.where(board_id: params[:board_id]).delete
      status 202
      {response: :accepted}
    end

    namespace ':iid' do
      params do
        requires :iid, type: String, desc: "Identify Key (Unique on System)"
      end
      delete do
        d_params = declared(params)
        Item.where(board_id: params[:board_id], iid: d_params[:iid]).delete
        status 202
        {response: :accepted}
      end
    end

  end
end
