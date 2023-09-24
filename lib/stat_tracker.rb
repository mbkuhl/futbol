require_relative './require_helper'

class StatTracker 
  attr_reader :all_season_data, :game, :team_data, :game_teams, :seasons, :teams
  attr_accessor :team_data
  def initialize(locations)
    @all_season_data = AllSeasonData.new(self)
    @game = all_season_data.game_data_parser(locations[:games])
    @team_data = all_season_data.team_data_parser(locations[:teams])
    @game_teams = all_season_data.game_teams_data_parser(locations[:game_teams])
    @seasons = @all_season_data.single_seasons_creator
    @teams = []
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
    @teams.each { |teams| teams.initialize2}
    @seasons.values.each { |season| season.initialize2}
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def highest_total_score
    total_score = game.map do |goals|
      home_score = goals[:home_goals].to_i + away_score = goals[:away_goals].to_i
    end
    total_score.sort.last
  end 

  def lowest_total_score
    total_score = game.map do |goals|
      home_score = goals[:home_goals].to_i + away_score = goals[:away_goals].to_i
    end
    total_score.sort.first
  end

  def percentage_home_wins 
    count = 0
    game.each { |single_game| count += 1 if single_game[:home_goals].to_i > single_game[:away_goals].to_i }
    percentage = (count.to_f / game.count).round(2)
  end

  def percentage_visitor_wins
    count = 0
    game.each {|single_game| count +=1 if single_game[:away_goals] > single_game[:home_goals]}
    percentage = (count.to_f / game.length).round(2)
  end

  def percentage_ties 
    count = 0
    game.each {|single_game| count += 1 if single_game[:home_goals] == single_game[:away_goals]}
    percentage = (count.to_f / game.count).round(2)
  end

  def count_of_games_by_season
    counts = Hash.new(0)
    game.each { |single_game| counts[single_game[:season]] += 1 }
    counts
  end

  def average_goals_per_game
    numerator = game_teams.sum { |game| game[:goals].to_i.to_f }
    (numerator / game.count).round(2) 
  end

  def average_goals_by_season
    goals = Hash.new { |hash, season| hash[season] = [] }
    game.each do |single_game|
      season = single_game[:season]
      total_score = home_score = single_game[:home_goals].to_i + single_game[:away_goals].to_i
      goals[season] << total_score
    end
    average_goals = goals.transform_values { |goal| (goal.sum.to_f / goal.length).round(2) }
    average_goals
  end

  def count_of_teams
    team_data.count
  end

  def best_offense
    team_average = @all_season_data.team_score_game_average
    best_offense_id = team_average.sort_by { |team_id, average| average }.last[0]
    team_data.find { |team| team[:team_id] == best_offense_id }[:teamname]
  end
  
  def worst_offense
    team_average = @all_season_data.team_score_game_average
    worst_offense_id = team_average.sort_by { |team_id, average| average }.first[0]
    team_data.find { |team| team[:team_id] == worst_offense_id }[:teamname]
  end
  
  def highest_scoring_visitor
    visitor_average = @all_season_data.visitor_team_score_average
    visitor_id = visitor_average.sort_by { |team_id, average| average }.last[0]
    team_data.find { |team| team[:team_id] == visitor_id }[:teamname]
  end

  def highest_scoring_home_team
    team_average = @all_season_data.home_team_score_game_average
    highest_home_id = team_average.sort_by { |team_id, average| average }.last[0]
    team_data.find { |team| team[:team_id] == highest_home_id }[:teamname]
  end

  def lowest_scoring_visitor
    visitor_average = @all_season_data.visitor_team_score_average
    visitor_id = visitor_average.sort_by { |team_id, average| average }.first[0]
    team_data.find { |team| team[:team_id] == visitor_id }[:teamname]
  end
  
  def lowest_scoring_home_team
    team_average = @all_season_data.home_team_score_game_average
    lowest_home_id = team_average.sort_by { |team_id, average| average }.first[0]
    team_data.find { |team| team[:team_id] == lowest_home_id }[:teamname]
  end

  def winningest_coach(season)
    @seasons[season].winningest_coach
  end
    
  def worst_coach(season)
    @seasons[season].worst_coach
  end

  def most_accurate_team(season_id)
    team_info = @all_season_data.season_accuracy(season_id)
    most_accurate_team_id = team_info.sort_by do |team_id, average| 
      average
    end.last[0]
    team_data.find { |team| team[:team_id] == most_accurate_team_id }[:teamname]
  end

  def least_accurate_team(season_id)
    team_info = @all_season_data.season_accuracy(season_id)
    least_accurate_team_id = team_info.sort_by { |team_id, average| average }.first[0]
    team_data.find { |team| team[:team_id] == least_accurate_team_id }[:teamname]
  end

  def most_tackles(season_id)
    team_info = @all_season_data.season_tackles(season_id)
    most_tackles_team_id = team_info.sort_by { |team_id, total| total }.last[0]
    team_data.find { |team| team[:team_id] == most_tackles_team_id }[:teamname]
  end

  def fewest_tackles(season_id)
    team_info = @all_season_data.season_tackles(season_id)
    fewest_tackles_team_id = team_info.sort_by { |team_id, total| total }.first[0]
    team_data.find { |team| team[:team_id] == fewest_tackles_team_id }[:teamname]
  end
end

