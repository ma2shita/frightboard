require "spec_helper"

describe Item do
  describe "plugins of Sequel" do
    context "serialization annotation column" do
      subject { described_class.create(annotation: {a:1}) }
      its(:annotation) { should eq({a:1}) }
    end

    context "date columns" do
      subject { described_class.create() }
      its(:created_at) { should be_a Time }
      its(:updated_at) { should be_a Time }
    end
  end
end
