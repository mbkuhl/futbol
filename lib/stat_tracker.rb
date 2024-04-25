require_relative './require_helper'

class StatTracker 
  include StatCalculatable
  attr_reader :all_season_data, :game, :team_data, :game_teams, :seasons, :teams
  attr_accessor :team_data
  def initialize(locations)
    @all_season_data = AllSeasonData.new(self)
    @game = all_season_data.game_data_parser(locations[:games])
    @team_data = all_season_data.team_data_parser(locations[:teams])
    @game_teams = all_season_data.game_teams_data_parser(locations[:game_teams])
    @seasons = @all_season_data.single_seasons_creator
    @teams = []
    build
    # @team_data.each do |team|
    #   @teams << Team.new(self, team[:team_id])
    # end
    # @game_teams.each do |game|
    #   @teams.each do |team_object|
    #     team_object.tgames << game if team_object.team_id == game[:team_id]
    #   end
    # end
    # @game.each do |one_game|
    #   @teams.each do |team_object|
    #     if team_object.team_id == one_game[:away_team_id] || team_object.team_id == one_game[:home_team_id]
    #       team_object.games << one_game 
    #     end
    #   end
    # end
    @teams.each { |teams| teams.initialize2}
    @seasons.values.each { |season| season.initialize2}
  end

  def build
    @team_data.each do |team|
      @teams << Team.new(self, team[:team_id])
    end
    @game_teams.each do |game|
      @teams.each do |team_object|
        team_object.tgames << game if team_object.team_id == game[:team_id]
      end
    end
    @game.each do |one_game|
      @teams.each do |team_object|
        if team_object.team_id == one_game[:away_team_id] || team_object.team_id == one_game[:home_team_id]
          team_object.games << one_game 
        end
      end
    end
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end
end

