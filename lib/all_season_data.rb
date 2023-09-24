require_relative './require_helper'

class AllSeasonData
  attr_reader :stat_tracker, :games_by_season, :home_team_games, :home_team_games_scores
  def initialize(stat_tracker)
    @stat_tracker = stat_tracker
  end

  def team_data_parser(file_location)
    @team_data ||= CSV.foreach( file_location, headers: true, header_converters: :symbol).map do |info| 
      info
    end
  end

  def game_teams_data_parser(file_location)
    @game_teams_data ||= CSV.foreach( file_location, headers: true, header_converters: :symbol).map do |info| 
      info
    end
  end

  def game_data_parser(file_location)
    @game ||= CSV.foreach( file_location, headers: true, header_converters: :symbol).map do |info| 
      info
    end
  end

  def games_by_season
    @games_by_season ||= begin
      games_by_season_hash = Hash.new([])
      @stat_tracker.game.each do |one_game|
        games_by_season_hash[one_game[:season]] += [one_game[:game_id]]
      end
      @games_by_season = games_by_season_hash
    end
  end

  def team_score_game_average
    teams_average = {}
    @stat_tracker.teams.each do |team|
      teams_average[team.team_id] = ((team.seasons.sum { |season| season.last.goals })/(team.seasons.sum { |season| season.last.games}).to_f).round(5)
    end
    teams_average
  end

  def visitor_team_score_average
    visitor_average = {}
    @stat_tracker.teams.each do |team|
      visitor_average[team.team_id] = ((team.seasons.sum { |season| season.last.away_goals })/(team.seasons.sum { |season| season.last.away_games}).to_f).round(5)
    end
    visitor_average
  end

  def home_team_score_game_average
    teams_average = {}
    @stat_tracker.teams.each do |team|
      teams_average[team.team_id] = ((team.seasons.sum { |season| season.last.home_goals })/(team.seasons.sum { |season| season.last.home_games}).to_f).round(5)
    end
    teams_average
  end
  
  def season_accuracy(season_id)
    team_accuracy = {}
    @seasons.each do |season|
      if season.first == season_id 
        season.last.team_seasons.each do |team_season| 
          if team_season.games != 0
            team_accuracy[team_season.team_id] = (team_season.goals / team_season.shots.to_f).round(5) 
          end
        end
      end
    end
    team_accuracy
  end

  def season_tackles(season_id)
    team_tackles = {}
    @seasons.each do |season|
      if season.first == season_id
        season.last.team_seasons.each do |team_season| 
          if team_season.games != 0
          team_tackles[team_season.team_id] = (team_season.tackles).round(5)
          end
        end
      end
    end
    team_tackles
  end
  
  def single_seasons_creator
    @seasons ||= begin
      seasons_hash = Hash.new
      games_by_season.keys.each do |season|
        seasons_hash[season] = SingleSeasonData.new(@stat_tracker, season)
      end
      @seasons = seasons_hash
    end
  end
end