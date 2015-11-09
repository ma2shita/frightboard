module API
  module Entities
    class Status < Grape::Entity
      expose :iid
      expose :status
      expose :created_at
      expose :updated_at
      expose :data
    end
  end
end

class WorkingDashboard::API < Grape::API
  prefix :api
  version :v1, using: :path
  format :json

  params do
    requires :iid,    type: String,                     desc: "Identify Key (Unique on System)"
    optional :status, type: String, default: "updated", desc: "IID's latest status"
    optional :data,   type: JSON,                       desc: "Annotate data"
  end
  post "/statuses" do
    d_params = declared(params)
    r = Helper::ItemModel.upsert(d_params["iid"], d_params["status"], d_params["data"])
    if r == :updated
      status 202
    end
    {response: r}
  end

  get "/statuses" do
    r = Item.all
    present r, with: ::API::Entities::Status
  end
end
