require './spec/spec_helper'

RSpec.describe Coach do
  game_path = './data/games_fixture.csv'
  team_path = './data/teams_fixture.csv'
  game_teams_path = './data/game_teams_fixture.csv'
  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
    }
  
  let(:stat_tracker) { StatTracker.new(locations) }
  let(:coach) { stat_tracker.seasons['20122013'].coaches[0] }

  describe '#initialize' do
    it 'exists and has attributes' do
      expect(stat_tracker).to be_a(StatTracker)
      expect(coach).to be_a(Coach)
      expect(coach.name).to be_a(String)
      expect(coach.name).to eq('Peter DeBoer')
      expect(coach.games).to be_a(Integer)
      expect(coach.games).to eq(2)
      expect(coach.wins).to be_a(Integer)
      expect(coach.wins).to eq(2)
    end 
  end
end