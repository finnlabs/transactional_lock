require 'transactional_lock/transaction_wrapper'

module TransactionalLock
  module ActiveRecordPatches
    def self.perform!
      ::ActiveRecord::Base.extend(ActiveRecordBasePatches)
    end

    module ActiveRecordBasePatches
      def transaction(*args)
        TransactionalLock::TransactionWrapper.new.wrap do
          super
        end
      end
    end
  end
end
