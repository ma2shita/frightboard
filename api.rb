module API
  module Entities
    class Status < Grape::Entity
      expose :iid
      expose :status
      expose :created_at
      expose :updated_at
      expose :annotation
    end
  end
end

class WorkingDashboard::API < Grape::API
  prefix :api
  version :v1, using: :path
  format :json

  params do
    requires :iid,        type: String,                     desc: "Identify Key (Unique on System)"
    optional :status,     type: String, default: "updated", desc: "IID's latest status"
    optional :annotation, type: JSON,                       desc: "Annotate data"
  end
  post "/statuses" do
    d_params = declared(params)
    r = Helper::ItemModel.upsert(d_params["iid"], d_params["status"], d_params["annotation"])
    if r == :updated
      status 202
    end
    {response: r}
  end

  get "/statuses" do
    r = Item.all
    present r, with: ::API::Entities::Status
  end

  params do
    requires :iid, type: String, desc: "Identify Key (Unique on System)"
  end
  delete "/statuses" do
    d_params = declared(params)
    Item.where(iid: d_params["iid"]).delete
    status 202
    {response: :accepted}
  end
end
