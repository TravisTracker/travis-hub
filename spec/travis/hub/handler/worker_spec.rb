require 'spec_helper'

describe Travis::Hub::Handler::Worker do
  let(:worker)  { stub('worker', :update_attributes! => nil) }
  let(:handler) { Travis::Hub::Handler::Worker.new('worker:status', payload) }

  before :each do
    handler.stubs(:worker_by).returns(worker)
  end

  describe 'handle (old api, hash payload)' do
    let(:payload) { { :name => 'travis-test-1', :host => 'host', :state => 'ready' } }

    it 'updates the worker states and last_seen_at attributes' do
      worker.expects(:ping).with(payload)
      handler.handle
    end
  end

  describe 'handle (old api, array payload)' do
    let(:payload) { [{ :name => 'travis-test-1', :host => 'host', :state => 'ready' }] }

    it 'updates the worker states and last_seen_at attributes (array payload)' do
      worker.expects(:ping).with(payload.first)
      handler.handle
    end
  end

  describe 'handle (new api)' do
    let(:payload) { { 'workers' => [{ :name => 'travis-test-1', :host => 'host', :state => 'ready' }] } }

    it 'updates the worker states and last_seen_at attributes' do
      worker.expects(:ping).with(payload['workers'].first)
      handler.handle
    end
  end

  # TODO make the db available here
  #
  # describe 'workers' do
  #   it 'returns workers grouped by their full_name' do
  #     worker = Worker.create(:name => 'worker-1', :host => 'host')
  #     handler.send(:workers)['host:worker-1'].should == worker
  #   end
  # end
  #
  # describe 'worker' do
  #   it 'returns an existing worker instance'
  #   it 'returns a new worker instance'
  # end
end


