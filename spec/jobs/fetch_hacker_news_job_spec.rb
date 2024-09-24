require 'rails_helper'

RSpec.describe FetchHackerNewsJob, type: :job do
  let(:service_double) { instance_double(HackerNewsService) }

  before do
    allow(HackerNewsService).to receive(:call).and_return(service_double)
  end

  describe '#perform' do
    it 'calls the HackerNewsService' do
      expect(HackerNewsService).to receive(:call)
      described_class.perform_now
    end
  end
end
