# source: http://subforge.org/projects/shreds/repository/entry/bot/cinch.rb#L396
# @copyright (c) 2010-2012, Christoph Kappel <unexist@dorfelite.net>

require "json"
require "mechanize"

module Cinch
  module Plugins
    class UrlScraper
      include Cinch::Plugin

      listen_to :channel
      def listen(m)
        # Create mechanize agent
        if @agent.nil?
          @agent = Mechanize.new
          @agent.user_agent_alias = "Linux Mozilla"
          @agent.max_history      = 0
        end

        URI.extract(m.message.gsub(/git@(gist.github.com):/,'git://\1/'), ["http", "https", "git"]).map do |link|
          link=~/^(.*?)[:;,\)]?$/
          $1
        end.each do |link|
          # Fetch data
          begin
            if git = link =~ /^git:\/\/(gist.github.com\/.*)\.git$/
              link = "https://#{$1}"
            end
            uri  = URI.parse(link)
            page = @agent.get(link)
          rescue Mechanize::ResponseCodeError
            if "www.youtube.com" == uri.host
              m.reply "Thank you, GEMA!"
            else
              m.reply "Y U POST BROKEN LINKS?", true
            end

            next
          end

          # Replace strange characters
          title = page.title.gsub(/[\x00-\x1f]*/, "").gsub(/[ ]{2,}/, " ").strip rescue nil

          # Check host
          case uri.host
            when "www.imdb.com"
              # Get user rating
              rating = page.search("//strong/span[@itemprop='ratingValue']").text

              # Get votes
              votes = page.search("//a/span[@itemprop='ratingCount']").text

              m.reply "Title: %s (at %s, %s/10 from %s users)" % [
                title, uri.host, rating, votes
              ]
            when "www.youtube.com"
              # Reload with nofeather
              page = @agent.get(link + "&nofeather=True")

              # Get page hits
              hits = page.search("//span[@class='watch-view-count']/strong")
              hits = hits.text.gsub(/[.,]/, "")

              # Get likes
              likes = page.search("//span[@class='watch-likes-dislikes']")
              likes = likes.text.gsub(/[.,]/, "")

              m.reply "Title: %s (at %s, %s hits, %s)" % [
                title, uri.host, hits, likes.strip
              ]
            when "gist.github.com"
              # Get owner
              owner = page.search("//div[@class='name']/a").inner_html

              # Get time
              age = page.search("//span[@class='date']/abbr").text
              age = Time.parse(age) rescue nil
              age = age.strftime("%Y-%m-%d %H:%M") if age

              if git
                m.reply "Title: %s (at %s, %s on %s), Url: %s" % [
                  title, uri.host, owner, age, link
                ]
              else
                m.reply "Title: %s (at %s, %s on %s)" % [
                  title, uri.host, owner, age
                ]
              end
            when "pastie.org"
              # Get time
              age = Time.parse(page.search("//span[@class='typo_date']").text)
              age = age.strftime("%Y-%m-%d %H:%M")

              m.reply "Title: %s (at %s, on %s)" % [
                title, uri.host, age
              ]
            when "subforge.org", "subtle.de"
              m.reply "Title: %s (at %s)" % [ title, uri.host ]
            when "twitter.com"
              if link =~ /\/status\/(\d+)$/
                json      = @agent.get("https://api.twitter.com/1/statuses/show/#{$1}.json?trim_user=1").body
                tweet     = JSON.parse(json)
                unescaped = CGI.unescapeHTML(tweet["text"])

                m.reply "@%s: %s" % [ tweet["user"]["screen_name"], unescaped ]
              else
                m.reply "Broken twitter link: %s (at %s)" % [ title, uri.host ] if title
              end
            else
              m.reply "Title: %s (at %s)" % [ title, uri.host ] if title
            end
        end
      end
    end
  end
end
