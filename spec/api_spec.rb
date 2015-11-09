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

    context "get" do
      let(:list) do
        [
          {iid: "XXXX1", status: "donwloading",     data: {mac_address:"AA:BB:CC:00:11:01"}.to_json},
          {iid: "XXXX2", status: "donwloading",     data: {mac_address:"AA:BB:CC:00:11:02"}.to_json},
          {iid: "XXXX1", status: "running_ansible", data: {mac_address:"AA:BB:CC:00:11:01"}.to_json}, # update
        ]
      end
      before {
        Item.truncate
        list.each do |i|
          Helper::ItemModel.upsert(*i.values)
        end
      }
      subject { get("/api/v1/statuses") }
      let(:response) do
        [
          {iid: "XXXX1", status: "running_ansible", data: {mac_address:"AA:BB:CC:00:11:01"}.to_json, created_at: String, updated_at: String},
          {iid: "XXXX2", status: "donwloading",     data: {mac_address:"AA:BB:CC:00:11:02"}.to_json, created_at: String, updated_at: String},
        ]
      end
      its(:body) { should be_json_as response }
    end
  end
end
