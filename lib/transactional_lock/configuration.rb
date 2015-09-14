module TransactionalLock
  class Configuration
    class << self
      def initialize
        config = default_configuration

        if block_given?
          yield config
        end

        @config = config
      end

      def default_timeout
        @config[:default_timeout]
      end

      private

      def default_configuration
        {
            default_timeout: 30
        }
      end
    end
  end
end
