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

  desc "fetch the results of unfinished games"
  task :seed_old_season => :environment do
    seasons = ['20032004',
               '20052006',
               '20062007',
               '20072008',
               '20082009',
               '20092010',
               '20102011',
               '20112012',
               '20122013',
               '20132014',
               '20142015']

    created_games = {}

    seasons.each do |season|
      created_games[season] = []

      uri = open("http://www.nhl.com/ice/schedulebyseason.htm?season=#{season}")
      page = Nokogiri::HTML(uri)

      trs = page.css('tr')

      game_trs = trs.select { |tr| tr.text.include?('FINAL:')}

      game_trs.each_with_index do |game, i|
        print '.' if i % 100 == 0
        next if !(GameFinisher.home_team_from(game.css('.tvInfo').text) &&
                  GameFinisher.away_team_from(game.css('.tvInfo').text))

        # the date looks like "Sun Jan 25, 2015Sun Jan 25, 2015"
        date = halve(game.css('.date').text)

        # TODO
        # GameCreator.create(game.css('.tvInfo').text, date)
      end
    end

    binding.pry
  end
end

def halve(str)
  str[0..(str.length/2)-1]
end
