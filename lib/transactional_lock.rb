require 'transactional_lock/active_record_patches'
require 'transactional_lock/configuration'
require 'transactional_lock/version'

module TransactionalLock
  class << self
    def initialize(&block)
      ::TransactionalLock::ActiveRecordPatches.perform!
      ::TransactionalLock::Configuration.initialize(&block)
    end
  end
end
