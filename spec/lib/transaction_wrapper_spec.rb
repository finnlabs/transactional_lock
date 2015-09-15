require 'spec_helper'

describe TransactionalLock::TransactionWrapper do
  let(:lock) { double(TransactionalLock::AdvisoryLock) }
  let(:acquired_locks) { [lock] }

  before do
    allow(TransactionalLock::AdvisoryLock).to receive(:acquired_locks).and_return(acquired_locks)
  end

  it 'releases the lock after the transaction committed' do
    ActiveRecord::Base.transaction do
      expect(lock).to receive(:release)
    end
  end

  it 'releases the lock only once for nested transactions' do
    expect(lock).to receive(:release).once

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.transaction do
      end
    end
  end

  it 'releases the lock in the outer-most transaction' do
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.transaction do
      end
      expect(lock).to receive(:release)
    end
  end

  it 'releases the lock after a failed transaction' do
    expect(lock).to receive(:release)

    begin
      ActiveRecord::Base.transaction do
        raise 'foo'
      end
    rescue StandardError
    end
  end
end
