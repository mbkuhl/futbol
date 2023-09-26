require_relative './require_helper'

class TeamSeason
  attr_accessor :goals,
                :games,
                :shots,
                :tackles,
                :home_games,
                :away_games,
                :home_goals,
                :away_goals,
                :season,
                :team_id,
                :gamescsv,
                :tgames

  def initialize(season, team_id, stat_tracker)
    @stat_tracker = stat_tracker
    @team_id = team_id
    @season = season
    @game_objects = []
    @gamescsv = []
    @tgames = []
  end

  def initialize2
    @goals = 0
    @games = 0
    @shots = 0
    @tackles = 0
    @home_games = 0
    @away_games = 0
    @home_goals = 0
    @away_goals = 0
    game_object_maker
    game_object_populator
  end

  def game_object_maker
    hash = {}
    @gamescsv.each do |one_game|
      hash[one_game] = (@tgames.find { |game_team| game_team[:game_id] == one_game[:game_id] })
    end
    hash.each do |game, half_game|
      game_object = Game.new(game, half_game)
      @game_objects << game_object
    end
  end

  def game_object_populator
    @game_objects.each do |game| 
      team = @stat_tracker.teams.find { |team| team.team_id == @team_id }
      team.game_objects << game
    end
  end
end

