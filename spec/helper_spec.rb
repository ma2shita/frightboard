require "spec_helper"

describe Helper::ItemModel do
  before {
    Item.truncate
    Board.truncate
    Board.create(board_id: "b1")
    described_class.upsert("b1", "a")
  }

  describe "Upsert logic" do
    context "Operation for not exists board" do
      subject { -> { described_class.upsert("not_exists_board_id", "a") } }
      it { is_expected.to raise_error(RuntimeError) }
    end

    context "Exists row" do
      before {
        described_class.upsert("b1", "a", "updated")
      }
      subject { Item.where(board_id: "b1", iid: "a") }
      its(:count)         { should eq 1 }
      its("first.status") { should eq "updated" }
    end

    context "New row" do
      before {
        described_class.upsert("b1", "b", "new")
      }
      subject { Item }
      its(:count)        { should eq 2 }
      its("last.status") { should eq "new" }
    end
  end

  describe "return" do
    context "Exists row" do
      subject { described_class.upsert("b1", "a", "updated") }
      it { should eq :updated }
    end

    context "New row" do
      subject { described_class.upsert("b1", "b", "new") }
      it { should eq :created }
    end
  end

  describe "Ignore annotation column when input empty" do
    context "Update" do
      before {
        described_class.upsert("b1", "id1", nil, {memo:"test"}.to_json)
      }
      subject {
        described_class.upsert("b1", "id1", nil, {comment:"foo"}.to_json)
        Item.where(board_id: "b1", iid: "id1")
      }
      its("first.annotation") { should eq({"comment":"foo"}.to_json) }
    end

    context "Keep prev value" do
      before {
        described_class.upsert("b1", "id1", nil, {memo:"test"}.to_json)
      }
      subject {
        described_class.upsert("b1", "id1", nil, nil)
        Item.where(board_id: "b1", iid: "id1")
      }
      its("first.annotation") { should eq({"memo":"test"}.to_json) }
    end
  end
end
