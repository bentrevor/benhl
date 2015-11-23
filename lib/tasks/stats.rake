require 'pry'
require 'open-uri'
require './lib/game_finisher'

namespace :stats do
  desc "fetch the results of unfinished games"
  task :update_games => :environment do
    unfinished_games = Game.where(season: 2015, status_id: 1).where('datetime < ?', Date.today)
    dates = unfinished_games.map(&:datetime).uniq.map { |date| date.strftime('%m/%d/%Y') }

    dates.each do |date|
      uri = open("http://www.nhl.com/ice/schedulebyday.htm?date=#{date}&season=20152016")
      page = Nokogiri::HTML(uri)

      page.css('.tvInfo').each do |game|
        GameFinisher.finish(game.text, date)
      end
    end
  end
end
