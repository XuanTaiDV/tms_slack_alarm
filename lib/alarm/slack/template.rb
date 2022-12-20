# frozen_string_literal: true
module Alarm
  module Slack
    module Template
      COLOR_DEFAULT         = '#e74c3c'
      FORMAT_DATE           = '%Y/%m/%d'
      FORMAT_TIME_WITH_ZONE = '%H:%M %z'
      TITLE_ICONS_DEFAULT   = ':male-technologist:'

      # Params required:
      #  @title, @stared, @finished, @cmd
      #
      # Params optional:
      #  @exception
      #
      def template_block_for_task(**opts)
        setup_options(opts)

        [
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "*#{opts[:title]}* #{opts[:title_icon]}"
            }
          },
          {
            type: 'context',
            elements: [
              {
                text: "Announcement from the *#{opts[:announcer]}*",
                type: 'mrkdwn'
              }
            ]
          },
          {
            type: 'divider'
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "*Command:*\n #{opts[:cmd]} (#{opts[:env] || 'development'})"
            }
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "*Started:*\n#{opts[:current_time]}"
            }
          },
          {
            type: 'section',
            fields: [
              {
                type: 'mrkdwn',
                text: "*Duration:*\n#{opts[:duration]}"
              },
              {
                type: 'mrkdwn',
                text: "*Memory:*\n#{opts[:memory]}"
              }
            ]
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "*Hostname:*\n#{opts[:hostname]}"
            }
          },
          {
            type: 'section',
            text: {
              type: 'mrkdwn',
              text: "*Version:*\n#{opts[:version]}"
            }
          }
        ]
      end

      def template_attachment_for_task(opts)
        return if blank?(opts[:exception])

        [
          {
            color: opts[:color],
            title: ":octagonal_sign: Error: #{opts[:exception].message}",
            text:  "*Backtrace:*\n#{opts[:exception].backtrace.join("\n")}"
          }
        ]
      end

      def time_elapsed(from, to)
        duration = (to - from).round(2)

        return "#{duration} second" if duration < 1

        hours = ((duration / 60) / 60).to_i
        minutes = ((duration / 60) % 60).to_i
        seconds = (duration - (hours * 60 * 60) - (minutes * 60)).to_i

        log = "#{hours} #{'hour'.pluralize(hours)} "
        log += "#{minutes} #{'minute'.pluralize(minutes)} "
        log += "#{seconds} #{'second'.pluralize(seconds)}"
        log
      rescue StandardError => e
        "No estimates. Error: #{e.message}"
      end

      def current_time_with_zone_formated(opts)
        format_dateime_with_zone = valid_format_datetime_with_zone(opts[:format_date])

        Time.now.strftime(format_dateime_with_zone)
      end

      private

      def setup_options(opts)
        opts[:duration]     = time_elapsed(opts[:started], opts[:finished])
        opts[:current_time] = current_time_with_zone_formated(opts)
        opts[:cmd]          = commandline(opts[:cmd])
        opts[:color]        = opts[:color].presence || COLOR_DEFAULT
        opts[:title_icon]   = opts[:title_icon].presence || TITLE_ICONS_DEFAULT
        opts[:announcer]    = opts[:announcer].presence || "TOMOSIA's Developer team"
        opts[:version]      = begin
          `ruby -v`
        rescue StandardError
          nil

        end
        opts[:hostname] = begin
          `hostname`
        rescue StandardError
          nil
        end
      end

      def valid_format_datetime_with_zone(format_date)
        format_date = if format_date.nil? || blank?(format_date)
          FORMAT_DATE
        else
          format_date.strip
        end

        format_date + " " + FORMAT_TIME_WITH_ZONE
      rescue
        FORMAT_DATE + " " + FORMAT_TIME_WITH_ZONE
      end

      def blank?(obj)
        obj.respond_to?(:empty?) ? !!obj.empty? : !obj
      end

      def commandline(command)
        return "" if blank?(command)

        %Q(`#{command}`)
      end
    end
  end
end
