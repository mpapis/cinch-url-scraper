# Cinch Url Scraper plugin

A Cinch plugin to get information about posted URLs.

## Installation

First install the gem by running:

```bash
gem install cinch-url-scrapper
```

Then load it in your bot:

```ruby
require "cinch"
require "cinch/plugins/urlscraper"

bot = Cinch::Bot.new do
  configure do |c|
    c.plugins.plugins = [Cinch::Plugins::UmlScraper]
  end
end

bot.start
```

## Commands

```irc
<url> # display url title / information
```

## Example

    <mpapis>: git@gist.github.com:3505088.git:
    <smfbot>: Title: rvm setup for projects — Gist (at gist.github.com, mpapis on 2012-08-28 15:56), Url: https://gist.github.com/3505088

## Development

Run the `./test-run.sh` script to play with results of your changes in channel listed in `example/config.yaml`
