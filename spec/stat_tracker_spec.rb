require './spec/spec_helper'

RSpec.describe StatTracker do
  game_path = './data/games_fixture.csv'
  team_path = './data/teams_fixture.csv'
  game_teams_path = './data/game_teams_fixture.csv'
  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
    }
  
  let(:stat_tracker) { StatTracker.from_csv(locations) }

  describe '#initialize' do
    it 'can initialize' do
      expect(stat_tracker).to be_a(StatTracker)
    end
  end

  describe '::from_csv' do
    it 'returns an instance of StatTracker' do
      expect(stat_tracker).to be_a(StatTracker)
      expect(stat_tracker.team_data).to be_a(Array)
      stat_tracker.team_data.each do |team|
        expect(team).to be_a(CSV::Row)
      end
      expect(stat_tracker.game).to be_a(Array)
      stat_tracker.game.each do |game|
        expect(game).to be_a(CSV::Row)
      end
      expect(stat_tracker.game_teams).to be_a(Array)
      stat_tracker.game_teams.each do |game|
        expect(game).to be_a(CSV::Row)
      end
    end
  end

  describe '#highest_total_score' do
    it 'returns the highest sum of the winning and losing teams scores' do
      expect(stat_tracker.highest_total_score).to eq(6)
    end
  end

  describe '#lowest_total_score' do
    it 'returns the lowest sum of the winning and losing teams scores' do
      expect(stat_tracker.lowest_total_score).to eq(1)
    end
  end

  describe '#percentage_home_wins' do
    it 'calculates percentage home wins' do
      expect(stat_tracker.percentage_home_wins).to eq(0.45)
    end
  end

  describe '#percentage_visitor_wins' do
    it 'calculates the percentage of visitor wins' do
      expect(stat_tracker.percentage_visitor_wins).to eq(0.20)
    end
  end

  describe '#percentage_ties' do
    it 'calculates the percentage of tied games' do
      expect(stat_tracker.percentage_ties).to eq(0.35)
    end
  end

  describe '#count_of_games_by_season' do
    it 'counts games by season' do
      expected = {
        "20122013" => 6,
        "20132014" => 9,
        "20142015" => 5,
      }
      expect(stat_tracker.count_of_games_by_season).to eq(expected)
    end
  end

  describe '#average_goals_per_game' do
    it 'returns the average number of goals scored by a single team' do
      expect(stat_tracker.average_goals_per_game).to eq(3.95)
    end
  end

  describe '#average_goals_by_season' do
    it 'returns the average goals scored per season' do
      expected_value = { '20122013' => 3.67, '20132014' => 3.78, '20142015' => 4.60 }
      expect(stat_tracker.average_goals_by_season).to eq(expected_value)
    end
  end

  describe '#count_of_teams' do
    it 'returns the total number of teams' do
      expect(stat_tracker.count_of_teams).to eq(4)
    end
  end

  describe '#best_offense' do
    it 'list best offense' do
      expect(stat_tracker.best_offense).to eq("Houston Dynamo")
    end
  end

  describe '#worst_offense' do
    it 'can return the team with the lowest average number of goals per game across all seasons' do
      expect(stat_tracker.worst_offense).to eq("Seattle Sounders FC")
    end
  end

  describe '#highest_scoring_home_team' do
    it 'return the highest scoring home team' do
      expect(stat_tracker.highest_scoring_home_team).to eq("Houston Dynamo")
    end
  end

  describe '#highest_scoring_visitor' do
    it 'returns the team with the highest average number of goals per game when away' do
      expect(stat_tracker.highest_scoring_visitor).to eq("Seattle Sounders FC")
    end
  end

  describe '#lowest_scoring_home_team' do
    it 'returns name of the team with the lowest average score per home game across all seasons' do
      expect(stat_tracker.lowest_scoring_home_team).to eq('Seattle Sounders FC')
    end
  end

  describe '#lowest_scoring_visitor' do
    it 'returns name of the team with the lowest average score per home game across all seasons' do
      expect(stat_tracker.lowest_scoring_visitor).to eq('Chicago Fire')
    end
  end

  describe '#worst_coach(season)' do
    it 'returns name of the coach with the worst win percentage for the season' do
      expect(stat_tracker.worst_coach('20122013')).to eq('Peter Laviolette')
      expect(stat_tracker.worst_coach('20132014')).to eq('Jack Capuano')
      expect(stat_tracker.worst_coach('20142015')).to eq('Peter DeBoer')
    end
  end

  describe '#winningest_coach(season)' do
    it 'returns name of the coacg with the best win percentage for the season' do
      expect(stat_tracker.winningest_coach('20122013')).to eq('Peter DeBoer')
      expect(stat_tracker.winningest_coach('20132014')).to eq('Craig Berube')
      expect(stat_tracker.winningest_coach('20142015')).to eq('Alain Vigneault')
    end
  end

  describe '#most_accurate_team' do
    it 'returns name of the team with the highest percentage of goals made vs. shots taken' do
      expect(stat_tracker.most_accurate_team("20122013")).to eq('Atlanta United')
      expect(stat_tracker.most_accurate_team("20132014")).to eq('Chicago Fire')
      expect(stat_tracker.most_accurate_team("20142015")).to eq('Houston Dynamo')
    end
  end

  describe '#least_accurate_team' do
    it 'list least accurate team' do
      expect(stat_tracker.least_accurate_team("20122013")).to eq("Seattle Sounders FC")
    end
  end

  describe '#most_tackles(season)' do
    it 'returns name of the team with the most tackles in the season' do
      expect(stat_tracker.most_tackles("20122013")).to eq('Seattle Sounders FC')
      expect(stat_tracker.most_tackles("20132014")).to eq('Houston Dynamo')
      expect(stat_tracker.most_tackles("20142015")).to eq('Chicago Fire')
    end
  end

  describe '#fewest_tackles(season)' do
    it 'returns name of the team with the fewest tackles in the season' do
      expect(stat_tracker.fewest_tackles("20122013")).to eq('Chicago Fire')
      expect(stat_tracker.fewest_tackles("20132014")).to eq('Atlanta United')
      expect(stat_tracker.fewest_tackles("20142015")).to eq('Houston Dynamo')
    end
  end
end

