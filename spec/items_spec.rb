require "spec_helper"

describe Item do
  describe "plugins of Sequel" do
    context "serialization data column" do
      subject { described_class.create(data: {a:1}) }
      its(:data) { should eq({a:1}) }
    end

    context "date columns" do
      subject { described_class.create() }
      its(:created_at) { should be_a Time }
      its(:updated_at) { should be_a Time }
    end
  end
end
