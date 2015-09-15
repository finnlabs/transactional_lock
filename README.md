[![build status](https://travis-ci.org/finnlabs/transactional_lock.svg)](https://travis-ci.org/finnlabs/transactional_lock)

# TransactionalLock

TransactionalLock is providing access to database advisory locks that will be automatically released
upon the end of a transaction (`COMMIT` or `ROLLBACK`).

As of now this gem only targets MySQL databases, where such locks are not available, thus they
are emulated by ensuring that the outmost ActiveRecord transaction will release all\* locks.

\* "all" refers to "one", because in MySQL a session can only hold a single advisory lock.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transactional_lock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transactional_lock

## Usage

While inside a transaction acquire your lock and you can be sure, that it will be released at
the end of the transaction:

````ruby
ActiveRecord::Base.transaction do
  TransactionalLock::AdvisoryLock.new('your_lock').acquire
  # do your work
end
# the lock has been released at this point
````

It will also work for nested AR transactions (that do not really map to your SQL `COMMIT` or `ROLLBACK`):

````ruby
ActiveRecord::Base.transaction do
  ActiveRecord::Base.transaction do
    TransactionalLock::AdvisoryLock.new('your_lock').acquire
  end

  # lock is still acquired here...
end # actual SQL COMMIT
# the lock has been released at this point
````

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/finnlabs/transactional_lock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

