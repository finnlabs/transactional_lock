require 'transactional_lock'
require 'transactional_lock/advisory_lock'
require 'transactional_lock/transaction_wrapper'

require 'active_record'

TransactionalLock.initialize

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
