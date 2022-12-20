module TmsSlackAlarm
  # Used to set up and modify settings for the retryable.
  class Configuration
    VALID_OPTION_KEYS = %i[
      webhook_url
      channel
      username
    ].freeze

    attr_accessor(*VALID_OPTION_KEYS)

    def initialize
      @webhook_url = ""
      @channel     = ""
      @username    = ""
    end

    # Returns a hash of all configurable options
    def to_hash
      VALID_OPTION_KEYS.each_with_object({}) do |key, memo|
        memo[key] = instance_variable_get("@#{key}")
      end
    end

    # Returns a hash of all configurable options merged with +hash+
    #
    # @param [Hash] hash A set of configuration options that will take precedence over the defaults
    def merge(hash)
      to_hash.merge(hash)
    end
  end
end
