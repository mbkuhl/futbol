require './spec/spec_helper'

RSpec.describe Game do
  game_path = './data/games_fixture.csv'
  team_path = './data/teams_fixture.csv'
  game_teams_path = './data/game_teams_fixture.csv'
  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
    }
  
  let(:stat_tracker) { StatTracker.new(locations) }
  let(:game) { stat_tracker.teams[0].game_objects[0] }

  describe '#initialize' do
    it 'exists and has attributes' do
      expect(stat_tracker).to be_a(StatTracker)
      expect(game).to be_a(Game)
      expect(game.game_id).to be_a(String)
      expect(game.season).to be_a(String)
      expect(game.game_type).to be_a(String)
      expect(game.home_team_id).to be_a(String)
      expect(game.away_team_id).to be_a(String)
      expect(game.stadium).to be_a(String)
      expect(game.goals).to be_a(Integer)
      expect(game.shots).to be_a(Integer)
      expect(game.tackles).to be_a(Integer)
      expect(game.coach).to be_a(String)
      # half_game_info: looking at one teams data in given game object
      expect(game.home_team_coach).to eq(nil)
      expect(game.home_team_shots).to eq(nil)
      expect(game.home_team_tackles).to eq(nil)
      expect(game.home_team_goals).to eq(nil)
      expect(game.hoa).to eq('away')
      expect(game.away_team_coach).to eq('Peter DeBoer')
      expect(game.away_team_shots).to eq(6)
      expect(game.away_team_tackles).to eq(19)
      expect(game.away_team_goals).to eq(3)
    end 
  end

  describe '#win?' do
    it 'returns if a game was a win or not' do
      expect(game.win?).to be true
    end
  end
end
