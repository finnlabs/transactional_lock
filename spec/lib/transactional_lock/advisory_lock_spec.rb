require 'spec_helper'

describe TransactionalLock::AdvisoryLock do
  let(:connection) { double('Connection') }
  let(:execution_result) { [[1]] } # MySQL result for SUCCESS
  let(:lock_name) { 'my_lock' }

  subject { described_class.new(lock_name) }

  before do
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
    allow(connection).to receive(:quote_string) do |arg|
      arg
    end
    allow(connection).to receive(:execute).and_return(execution_result)
  end

  after do
    TransactionalLock::AdvisoryLock.forget_locks!
  end

  describe '#acquire' do
    it 'executes SQL' do
      expect(connection).to receive(:execute)
      subject.acquire
    end

    it 'registers as acquired' do
      subject.acquire
      expect(described_class.acquired_locks).to match_array([subject])
    end

    it 'only acquires once, even if acquired twice' do
      expect(connection).to receive(:execute).once

      subject.acquire
      subject.acquire

      expect(described_class.acquired_locks).to match_array([subject])
    end

    it 'raises when acquiring two different locks' do
      subject.acquire
      lock2 = described_class.new('another_lock')
      expect { lock2.acquire }.to raise_error(TransactionalLock::LockConflict)
    end

    context 'acquiring times out' do
      let(:execution_result) { [[0]] } # MySQL result for timeout

      it 'raises' do
        expect { subject.acquire }.to raise_error(TransactionalLock::LockAcquireError)
      end
    end

    context 'acquiring errors' do
      let(:execution_result) { [[nil]] } # MySQL result for generic error

      it 'raises' do
        expect { subject.acquire }.to raise_error(TransactionalLock::LockAcquireError)
      end
    end
  end

  describe '#release' do
    before do
      subject.acquire
    end

    it 'executes SQL' do
      expect(connection).to receive(:execute)
      subject.release
    end

    it 'removes itself from acquired_locks' do
      subject.release
      expect(described_class.acquired_locks).to eql([])
    end

    context 'release query raises an exception' do
      before do
        allow(connection).to receive(:execute).and_raise 'an error'
      end

      it 'raises the error' do
        expect { subject.release }.to raise_error 'an error'
      end

      it 'removes itself from acquired locks anyway' do
        subject.release rescue nil
        expect(described_class.acquired_locks).to eql([])
      end
    end
  end
end
