require "rails_helper"

RSpec.describe TopCommenters do
  describe "#call" do
    let(:service) { described_class.new }

    it "generates valid SQL" do
      expect { service.call }.not_to raise_error
    end
  end
end
