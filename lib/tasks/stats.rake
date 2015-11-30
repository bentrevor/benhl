require 'pry'
require 'open-uri'
require './lib/game_finisher'

namespace :stats do
  desc "fetch the results and update finished games"
  task :update_games => :environment do
    season = 2015
    unfinished_games = Game.where(season: season, status_id: 1).where('datetime < ?', Date.today)

    if unfinished_games.empty?
      puts "all games are up to date for the #{season} season"
    else
      dates = unfinished_games.map(&:datetime).uniq.map { |date| date.strftime('%m/%d/%Y') }

      puts "finishing #{unfinished_games.count} games from #{dates.first} to #{dates.last}"
      dates.each_with_index do |date, i|
        print '.' if i % 5 == 0
        uri = open("http://www.nhl.com/ice/schedulebyday.htm?date=#{date}")
        page = Nokogiri::HTML(uri)

        page.css('.tvInfo').each do |game|
          game_str = game.text.gsub('ATL', 'WPG').gsub('PHX', 'ARI')
          GameFinisher.finish(game_str, date)
        end
      end
      puts 'done'
    end
  end

  desc "create unfinished games for old seasons"
  task :seed_old_season => :environment do
    season = 2015
    uri = open("http://www.nhl.com/ice/schedulebyseason.htm?season=#{season}#{season+1}")
    page = Nokogiri::HTML(uri)

    trs = page.css('tr')
    game_trs = trs.select { |tr| tr.text.include?('FINAL:') || tr.text.include?('TICKETS') }

    created_game_count = 0
    game_trs.each_with_index do |game, i|
      print '.' if i % 50 == 0

      if home_team = find_team_from_str(game.css('.teamName')[1].text) # filters out all-star games
        created_game_count += 1
        Game.create(
          home_team: home_team,
          away_team: find_team_from_str(game.css('.teamName')[0].text),
          datetime: Date.parse(halve(game.css('.date').text)),
          season: season,
        )
      end
    end
    puts "created #{created_game_count} games for #{season} season"
  end
end

def halve(str)
  str[0..(str.length/2)-1]
end

def find_team_from_str(str)
  {
    "Anaheim"      => Team['ana'],
    "Arizona"      => Team['ari'],
    "Phoenix"      => Team['ari'], # Phoenix Coyotes -> Arizona Coyotes in 2014-2015
    "Boston"       => Team['bos'],
    "Buffalo"      => Team['buf'],
    "Calgary"      => Team['cgy'],
    "Carolina"     => Team['car'],
    "Chicago"      => Team['chi'],
    "Colorado"     => Team['col'],
    "Columbus"     => Team['cbj'],
    "Dallas"       => Team['dal'],
    "Detroit"      => Team['det'],
    "Edmonton"     => Team['edm'],
    "Florida"      => Team['fla'],
    "Los Angeles"  => Team['lak'],
    "Minnesota"    => Team['min'],
    "Montréal"     => Team['mtl'],
    "NY Islanders" => Team['nyi'],
    "NY Rangers"   => Team['nyr'],
    "Nashville"    => Team['nsh'],
    "New Jersey"   => Team['njd'],
    "Ottawa"       => Team['ott'],
    "Philadelphia" => Team['phi'],
    "Pittsburgh"   => Team['pit'],
    "San Jose"     => Team['sjs'],
    "St. Louis"    => Team['stl'],
    "Tampa Bay"    => Team['tbl'],
    "Toronto"      => Team['tor'],
    "Vancouver"    => Team['van'],
    "Washington"   => Team['wsh'],
    "Winnipeg"     => Team['wpg'],
    "Atlanta"      => Team['wpg'], # Atlanta Thrashers -> Winnipeg Jets in 2011-2012
  }[str]
end
