require "slack-notifier"
require "alarm/slack/template"

module Alarm
  module Slack
    class Task
      attr_reader :opts, :notifier, :exception

      ICON_EMOJI = ':male-technologist:'

      def initialize(**opts)
        @opts = opts || {}
        @opts[:avatar] = @opts[:avatar].presence || ICON_EMOJI
        @notifier = ::Slack::Notifier.new(opts[:webhook_url]) do
          defaults   channel: opts[:channel],
                      username: opts[:username]
          middleware format_message: { formats: [:html] }, format_attachments: { formats: [:markdown] }
        end
      end

      def notify
        notifier.post(
          blocks: template_block_for_task(opts),
          attachments: template_attachment_for_task(opts),
          icon_emoji: opts[:avatar]
        )
      end

      def self.maintain(options, &block)
        options ||= {}
        est_time_spent(options) { est_memory_usage(options) { block.call } }
      rescue StandardError => e
        options[:exception] = e
      ensure
        slack = Alarm::Slack::Task.new(options)
        slack.notify
      end

      include Alarm::Slack::Template

      def self.est_memory_usage(options)
        memory_before = `ps -o rss= -p #{Process.pid}`.to_i
        yield
      ensure
        memory_after = `ps -o rss= -p #{Process.pid}`.to_i
        options[:memory] = "#{((memory_after - memory_before) / 1024.0).round(2)} MB"
      end

      def self.est_time_spent(options)
        options[:started] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        yield
      ensure
        options[:finished] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end
    end
  end
end
