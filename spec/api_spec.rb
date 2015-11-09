require "spec_helper"

describe WorkingDashboard::API do
  def app ; described_class ; end # required

  describe "" do
    subject { post("/api/v1/statuses", {iid:"i1"}, {}) }
    its(:status) { should be 201 }
    let(:response) do
    end
    its(:body)   { should be_json_as response }
  end
end

