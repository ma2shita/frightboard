require "spec_helper"

describe MyAPI::Example do
  def app ; described_class ; end # required

  context "get test" do
    subject { get("/test_endpoint", {q: "hoge", i: "foo"}, {}) }
    its(:status) { should be 200 }
    its(:body)   { should be_json_as({response: "ok"}) }
  end

  context "post" do
    subject { post("/test_endpoint", {id: 1}, {"X-Api-Key" => "hoge-bar"}) }
    its(:status) { should be 201 }
    its(:body)   { should be_json_as({response: "created"}) }
  end
end
