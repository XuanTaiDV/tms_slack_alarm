require "alarm/slack/task"
require "tms_slack_alarm/version"
require "tms_slack_alarm/configuration"

module TmsSlackAlarm
  class Error < StandardError; end

  class << self
    def notify(options = {})
      raise ArgumentError, %q('title' key is missing) unless options.has_key?(:title)
      raise ArgumentError, "options must be hash" unless options.is_a?(Hash)

      options.merge!(configuration_to_hash)
      alarm = Alarm::Slack::Task.new(options)
      alarm.notify
    end


    def maintain(options, &block)
      options = {} unless options.is_a?(Hash)
      options.merge!(configuration_to_hash)

      if options.has_key?(:title)
        Alarm::Slack::Task.maintain(options) { block }
      else
        raise ArgumentError, %q('title' key is missing)
      end
    end

    attr_writer :configuration

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configuration_to_hash
      configuration.to_hash
    end
  end
end
