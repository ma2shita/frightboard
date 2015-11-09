module WorkingDashboard
  class API < Grape::API
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
      Helper::ItemModel.upsert(d_params["iid"], d_params["status"], d_params["data"])
      {response: :ok}
    end
  end
end
