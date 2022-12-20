# TmsSlackAlarm

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/tms_slack_alarm`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tms_slack_alarm'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tms_slack_alarm

## Usage

# config/initializers/slack_monitoring.rb
```ruby
SlackMonitoring.configure do |config|
  config.webhook_url = "YOUR SLACK WEBHOOK URL HERE"
  config.channel     = "YOUR PUBLIC CHANNEL"
  config.username    = "YOUR USER NAME WANT TO DISPLAY ON MESSAGE(Customize)"
end
```

To get the `webhook_url` you need:

go to https://slack.com/apps/A0F7XDUAZ-incoming-webhooks
choose your team, press configure
in configurations press add configuration
choose channel, press "Add Incoming WebHooks integration"

# Send an immediately message to channel
```
TmsSlackAlarm.notify(title: "TOMOSIA's Developer team")
```

# Tracking crontab and push notification anytime it start

```
TmsSlackAlarm.maintain(
  title: "Service get started",
  cmd: 'bundle exec tms_slack_alarm:welcome' # This is your rake task command, and it's optional
) do
  // Your code here
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tms_slack_alarm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/tms_slack_alarm/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TmsSlackAlarm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tms_slack_alarm/blob/master/CODE_OF_CONDUCT.md).
