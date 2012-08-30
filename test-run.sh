#!/usr/bin/env bash

gem build cinch-url-scraper.gemspec
gem install cinch-url-scraper
(
  cd example
  smfbot
)
