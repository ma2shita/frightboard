require "spec_helper"

describe Helper::ItemModel do
  before {
    Item.truncate
    described_class.upsert("a")
  }

  describe "Upsert logic" do
    context "Exists row" do
      before {
        described_class.upsert("a", "updated")
      }
      subject { Item.where(iid: "a") }
      its(:count)         { should eq 1 }
      its("first.status") { should eq "updated" }
    end

    context "New row" do
      before {
        described_class.upsert("b", "new")
      }
      subject { Item }
      its(:count)        { should eq 2 }
      its("last.status") { should eq "new" }
    end
  end

  describe "return" do
    context "Exists row" do
      subject { described_class.upsert("a", "updated") }
      it { should eq :updated }
    end

    context "New row" do
      subject { described_class.upsert("b", "new") }
      it { should eq :created }
    end
  end

  describe "Ignore annotation column when input empty" do
    context "Update" do
      before {
        described_class.upsert("id1", nil, {memo:"test"}.to_json)
      }
      subject {
        described_class.upsert("id1", nil, {comment:"foo"}.to_json)
        Item.where(iid: "id1")
      }
      its("first.annotation") { should eq({"comment":"foo"}.to_json) }
    end

    context "Keep prev value" do
      before {
        described_class.upsert("id1", nil, {memo:"test"}.to_json)
      }
      subject {
        described_class.upsert("id1", nil, nil)
        Item.where(iid: "id1")
      }
      its("first.annotation") { should eq({"memo":"test"}.to_json) }
    end
  end
end
