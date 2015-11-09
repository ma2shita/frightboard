require "grape"

module MyAPI
  class Example < Grape::API
    format :json

    get "/test_endpoint" do
      {response: "ok", params: params, query_string: env["QUERY_STRING"]}
    end

    post "/test_endpoint" do
      {response: "created", params: params, headers: env["X-Api-Key"]}
    end
  end
end
