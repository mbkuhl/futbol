require_relative './require_helper'

class Team
  attr_reader :seasons, :team_id, :game_objects
  attr_accessor :games, :tgames
  def initialize(stat_tracker, team_id)
    @stat_tracker = stat_tracker
    @team_id = team_id
    @tgames = []
    @games = []
    @game_objects = []
    @seasons = {}
    @stat_tracker.seasons.keys.each do |season|
      @seasons[season] = TeamSeason.new(season, team_id, @stat_tracker)
    end
  end

  def initialize2
    game_sorter
    @seasons.values.each { |season| season.initialize2 }
    seasons_builder
  end

  def game_sorter
    @tgames.each do |game|
      @seasons.values.each do |team_season_object|
        if team_season_object.season[0..3] == game[:game_id][0..3]
          team_season_object.tgames << game 
        end
      end
    end
    @games.each do |one_game|
      @seasons.values.each do |team_season_object|
        if team_season_object.season == one_game[:season]
          team_season_object.gamescsv << one_game 
        end
      end
    end
  end

  def seasons_builder
    @game_objects.each do |game|
      curr_season = game.season
      #Send the game row to the proper TeamSeason object
      team = @seasons[curr_season] 
      #Populate that object with game_team data       
      team_season_populator(team, game) 
      #Also send that object to it's appropriate season
      @stat_tracker.seasons[curr_season].game_objects << game
    end
  end

  def team_season_populator(team, game)
    team.games += 1
    team.goals += game.goals
    team.shots += game.shots
    team.tackles += game.tackles

    team.home_games += 1 if game.hoa == "home"
    team.home_goals += game.goals if game.hoa == "home"
    team.away_games += 1 if game.hoa == "away"
    team.away_goals += game.goals if game.hoa == "away"
  end

  # def game_object_maker
  #   hash = {}
  #   games.each do |one_game|
  #     hash[one_game] = (@tgames.find { |game_team| game_team[:game_id] == one_game[:game_id] })
  #   end
  #   hash.each do |game, half_game|
  #     game_object = Game.new(game, half_game)
  #     @game_objects << game_object
  #   end
  # end
end