require "spec_helper"

describe WorkingDashboard::API do
  def app ; described_class ; end # required

  describe "/statuses" do
    context "create" do
      before { Item.truncate }
      subject { post("/api/v1/statuses", {iid:"i1"}, {}) }
      its(:status) { should be 201 }
      let(:response) do
        {response: "created"}
      end
      its(:body)   { should be_json_as response }
    end

    context "update" do
      before {
        Item.truncate
        Helper::ItemModel.upsert("i1")
      }
      subject { post("/api/v1/statuses", {iid:"i1"}, {}) }
      its(:status) { should be 202 }
      let(:response) do
        {response: "updated"}
      end
      its(:body) { should be_json_as response }
    end
  end
end
