require './spec/spec_helper'

RSpec.describe TeamSeason do
  game_path = './data/games_fixture.csv'
  team_path = './data/teams_fixture.csv'
  game_teams_path = './data/game_teams_fixture.csv'
  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
    }
  
  let(:stat_tracker) { StatTracker.new(locations) }
  let(:teamseason) { stat_tracker.teams[0].seasons['20122013'] }
  let(:teamseason1) { stat_tracker.seasons['20122013'].team_seasons[0] }

  describe '#initialize' do
    it 'initializes and has attributes' do
      expect(stat_tracker).to be_a(StatTracker)
      expect((teamseason) == (teamseason1)).to be true
      expect(teamseason).to be_a(TeamSeason)
      expect(teamseason.season).to eq('20122013')
      expect(teamseason.team_id).to eq('1')
      expect(teamseason.goals).to eq(5)
      expect(teamseason.games).to eq(2)
      expect(teamseason.shots).to eq(13)
      expect(teamseason.tackles).to eq(42)
      expect(teamseason.home_games).to eq(0)
      expect(teamseason.away_games).to eq(2)
      expect(teamseason.home_goals).to eq(0)
      expect(teamseason.away_goals).to eq(5)
    end
  end

  describe '#proper creation' do
    it 'tests for entire season' do
      stat_tracker.seasons['20122013'].team_seasons.each do |season|
        expect(season).to be_a(TeamSeason)
        expect(season.season).to eq('20122013')
        expect(season.team_id).to be_a(String)
        expect(season.goals).to be_a(Integer)
        expect(season.games).to be_a(Integer)
        expect(season.shots).to be_a(Integer)
        expect(season.tackles).to be_a(Integer)
        expect(season.home_games).to be_a(Integer)
        expect(season.away_games).to be_a(Integer)
        expect(season.home_goals).to be_a(Integer)
        expect(season.away_goals).to be_a(Integer)
      end
    end
  end
end