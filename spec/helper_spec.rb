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
end
