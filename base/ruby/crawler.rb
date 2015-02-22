# -*- coding: utf-8 -*-
# count.rb
require 'csv'
require 'natto'
require 'pp'
require 'twitter'
require 'tweetstream'
require 'json'

TweetStream.configure do |config|
  config.consumer_key = '***********',
  config.consumer_secret = '***********',
  config.oauth_token = '***********',
  config.oauth_token_secret = '***********'
  config.auth_method = :oauth
end



client = TweetStream::Client.new
client.on_inited do
  puts 'connection..'
end

nm = Natto::MeCab.new
t_map = {}

@statuses = []
client.sample do |status|
  if status.user.lang == "ja" && !status.text.index("RT") && !status.text.index("http:") && !status.text.index("@") && !status.text.index("https:") && !status.text.index("jp") && !status.text.index("com")
     nm.parse(status[]) do |n|
          t_map[n.surface] = t_map[n.surface] ? t_map[n.surface] + 1 : 1
          @statuses << status
           client.stop if @statuses.size >= 100
        end
     end
   end

t_map = t_map.sort_by {|k, v| v}

File.open('data/latest.csv', 'w'){|f|
  t_map.each do |word, count|
   f.write "#{word}, #{count}\n"
 end
 }