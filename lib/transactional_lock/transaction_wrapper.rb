require 'transactional_lock/advisory_lock'

module TransactionalLock
  class TransactionWrapper
    # If the root wrapper is not yet set, the specified wrapper will become the root wrapper.
    def self.try_assign_root_wrapper(wrapper)
      @root_wrapper = wrapper unless @root_wrapper
    end

    # If the specified wrapper is the root wrapper, it will be deassigned and the block passed
    # to this function will be executed
    def self.deassign_root_wrapper(wrapper)
      if wrapper == @root_wrapper
        @root_wrapper = nil
        yield
      end
    end

    def wrap
      self.class.try_assign_root_wrapper(self)
      yield
    ensure
      self.class.deassign_root_wrapper(self) do
        ::TransactionalLock::AdvisoryLock.acquired_locks.each do |lock|
          lock.release
        end
      end
    end
  end
end
