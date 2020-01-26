require "spec_helper"

describe FrightBoard::API do
  def app ; described_class ; end # required

  describe "/statuses" do
    context "not exists" do
      before {
        Board.truncate
        Item.truncate
      }
      subject { post("/api/v1/b1/statuses", {iid:"i1"}, {}) }
      its(:status) { should be 404 }
    end

    context "create" do
      before {
        Board.truncate
        Board.create(board_id: "b1")
        Item.truncate
      }
      subject { post("/api/v1/b1/statuses", {iid:"i1"}, {}) }
      its(:status) { should be 201 }
      let(:response) do
        {response: "created"}
      end
      its(:body)   { should be_json_as response }
    end

    context "update" do
      before {
        Board.truncate
        Board.create(board_id: "b1")
        Board.create(board_id: "b2")
        Item.truncate
        Helper::ItemModel.upsert("b1", "i1")
      }
      subject { post("/api/v1/b1/statuses", {iid:"i1"}, {}) }
      its(:status) { should be 200 }
      let(:response) do
        {response: "updated"}
      end
      its(:body) { should be_json_as response }
    end

    context "get" do
      let(:list) do
        [
          {board_id: "b1", iid: "XXXX1", status: "donwloading",     annotation: {mac_address:"AA:BB:CC:00:11:01"}.to_json},
          {board_id: "b1", iid: "XXXX2", status: "donwloading",     annotation: {mac_address:"AA:BB:CC:00:11:02"}.to_json},
          {board_id: "b1", iid: "XXXX1", status: "running_ansible", annotation: {mac_address:"AA:BB:CC:00:11:01"}.to_json}, # update
          {board_id: "b2", iid: "XXXX1", status: "void"},
        ]
      end
      before {
        Board.truncate
        Board.create(board_id: "b1")
        Item.truncate
        list.each do |i|
          Helper::ItemModel.upsert(*i.values)
        end
      }
      subject { get("/api/v1/b1/statuses") }
      let(:response) do
        [
          {board_id: "b1", iid: "XXXX1", status: "running_ansible", annotation: {mac_address:"AA:BB:CC:00:11:01"}.to_json, created_at: String, updated_at: String},
          {board_id: "b1", iid: "XXXX2", status: "donwloading",     annotation: {mac_address:"AA:BB:CC:00:11:02"}.to_json, created_at: String, updated_at: String},
        ]
      end
      its(:body) { should be_json_as response }
    end

    context "delete" do
      let(:list) do
        [
          {board_id: "b1", iid: "XXXX1"},
          {board_id: "b1", iid: "XXXX2"},
          {board_id: "b1", iid: "XXXX3"},
          {board_id: "b2", iid: "XXXX4"},
        ]
      end
      before {
        Board.truncate
        Board.create(board_id: "b1")
        Board.create(board_id: "b2")
        Item.truncate
        list.each do |i|
          Helper::ItemModel.upsert(*i.values)
        end
      }
      subject { delete("/api/v1/b1/statuses", {iid:"XXXX2"}, {}) }
      its(:status) { should be 202 }
      let(:response) do
        {response: "accepted"}
      end
      its(:body) { should be_json_as response }
      it "Inspect DB" do
        subject
        expect(Item.count).to eq 3
      end
    end
  end
end
