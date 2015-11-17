require 'pry'
require 'open-uri'
require './lib/game_finisher'

namespace :fetch do
  desc "fetch the results of yesterday's games"
  task :schedule => :environment do
    date = Date.yesterday.strftime('%m/%d/%Y')
    uri = open("http://www.nhl.com/ice/schedulebyday.htm?date=#{date}&season=20152016")
    page = Nokogiri::HTML(uri)

    page.css('.tvInfo').each do |game|
      GameFinisher.finish(game.text, date)
    end
  end
end
