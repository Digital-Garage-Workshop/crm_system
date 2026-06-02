require 'rails_helper'

describe V2::Reports::Conversations::ReportBuilder do
  subject { described_class.new(account, params) }

  let(:account) { create(:account) }
<<<<<<< HEAD
  let(:average_builder) { V2::Reports::Timeseries::AverageReportBuilder }
  let(:count_builder) { V2::Reports::Timeseries::CountReportBuilder }

  shared_examples 'valid metric handler' do |metric, method, builder|
    context 'when a valid metric is given' do
      let(:params) { { metric: metric } }

      it "calls the correct #{method} builder for #{metric}" do
        builder_instance = instance_double(builder)
        allow(builder).to receive(:new).and_return(builder_instance)
        allow(builder_instance).to receive(method)

        builder_instance.public_send(method)
=======
  let(:builder) { V2::Reports::Timeseries::ReportBuilder }

  shared_examples 'valid metric handler' do |metric, method|
    context 'when a valid metric is given' do
      let(:params) { { metric: metric } }

      it "calls the shared #{method} builder for #{metric}" do
        builder_instance = instance_double(builder)
        allow(builder).to receive(:new).and_return(builder_instance)
        allow(builder_instance).to receive(method).and_return(:result)

        expect(subject.public_send(method)).to eq(:result)
        expect(builder).to have_received(:new).with(account, params)
>>>>>>> upstream/develop
        expect(builder_instance).to have_received(method)
      end
    end
  end

  context 'when invalid metric is given' do
    let(:metric) { 'invalid_metric' }
    let(:params) { { metric: metric } }

    it 'logs the error and returns empty value' do
      expect(Rails.logger).to receive(:error).with("ReportBuilder: Invalid metric - #{metric}")
      expect(subject.timeseries).to eq({})
    end
  end

  describe '#timeseries' do
<<<<<<< HEAD
    include_examples 'valid metric handler', 'avg_first_response_time', :timeseries, V2::Reports::Timeseries::AverageReportBuilder
    include_examples 'valid metric handler', 'conversations_count', :timeseries, V2::Reports::Timeseries::CountReportBuilder
  end

  describe '#aggregate_value' do
    include_examples 'valid metric handler', 'avg_first_response_time', :aggregate_value, V2::Reports::Timeseries::AverageReportBuilder
    include_examples 'valid metric handler', 'conversations_count', :aggregate_value, V2::Reports::Timeseries::CountReportBuilder
=======
    it_behaves_like 'valid metric handler', 'avg_first_response_time', :timeseries
    it_behaves_like 'valid metric handler', 'conversations_count', :timeseries
  end

  describe '#aggregate_value' do
    it_behaves_like 'valid metric handler', 'avg_first_response_time', :aggregate_value
    it_behaves_like 'valid metric handler', 'conversations_count', :aggregate_value
>>>>>>> upstream/develop
  end
end
