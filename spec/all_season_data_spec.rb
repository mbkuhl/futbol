require './spec/spec_helper'

RSpec.describe AllSeasonData do
  game_path = './data/games_fixture.csv'
  team_path = './data/teams_fixture.csv'
  game_teams_path = './data/game_teams_fixture.csv'
  locations = {
    games: game_path,
    teams: team_path,
    game_teams: game_teams_path
    }
  
  let(:stat_tracker) { StatTracker.from_csv(locations) }
  let(:all_season_data) { stat_tracker.all_season_data }

  describe '#initialize' do
    it 'can initialize' do
      expect(stat_tracker).to be_a(StatTracker)
      expect(all_season_data).to be_a(AllSeasonData)
    end
  end

  describe '#team_data_parser(file_location)' do
    it 'pulls data from the teams csv file' do
      expect(all_season_data.team_data_parser(:teams)).to be_a(Array)
      expect(all_season_data.team_data_parser(:teams)[1]).to be_a(CSV::Row)
      expect(all_season_data.team_data_parser(:teams)[2][:team_id]).to eq('3')
    end
  end

  describe '#game_teams_data_parser(file_location)' do
    it 'pulls data from the game teams csv file' do
      expect(all_season_data.game_teams_data_parser(:game_teams)).to be_a(Array)
      expect(all_season_data.game_teams_data_parser(:game_teams)[1]).to be_a(CSV::Row)
      expect(all_season_data.game_teams_data_parser(:game_teams)[2][:team_id]).to eq('1')
    end
  end

  describe '#game_data_parser(file_location)' do
    it 'pulls data from the games csv file' do
      expect(all_season_data.game_data_parser(:games)).to be_a(Array)
      expect(all_season_data.game_data_parser(:games)[1]).to be_a(CSV::Row)
      expect(all_season_data.game_data_parser(:games)[2][:game_id]).to eq('2013020203')
    end
  end

  describe '#games_by_season' do
    it 'sorts games by their season' do
      expect(all_season_data.games_by_season).to be_a(Hash)
      expect(all_season_data.games_by_season['20122013']).to be_a(Array)
      expected_value = ["2012020122", "2012020635", "2012020006", "2012020191", "2012020143", "2012020582"]
      expect(all_season_data.games_by_season['20122013']).to eq(expected_value)
      expect(all_season_data.games_by_season['20122013'][0]).to eq('2012020122')
    end
  end
  
  describe '#team_score_game_average' do
    it 'returns teams and their average scores' do
      expect(all_season_data.team_score_game_average).to be_a(Hash)
      expected_value = {"1"=>1.77778, "2"=>1.72727, "3"=>2.27273, "4"=>2.11111}
      expect(all_season_data.team_score_game_average).to eq(expected_value)
      expect(all_season_data.team_score_game_average['1']).to eq(1.77778)
    end
  end

  describe '#visitor_team_score_average' do
    it 'returns a given teams average score when they are playing away' do
      expect(all_season_data.visitor_team_score_average).to be_a(Hash)
      expected_value = {"1"=>1.83333, "2"=>2.2, "3"=>1.66667, "4"=>1.33333}
      expect(all_season_data.visitor_team_score_average).to eq(expected_value)
      expect(all_season_data.visitor_team_score_average['1']).to eq(1.83333)
    end
  end

  describe '#home_team_score_game_average' do
    it 'returns a given teams average score when they are playing home' do
      expect(all_season_data.home_team_score_game_average).to be_a(Hash)
      expected_value = {"1"=>1.66667, "2"=>1.33333, "3"=>3.0, "4"=>2.5}
      expect(all_season_data.home_team_score_game_average).to eq(expected_value)
      expect(all_season_data.home_team_score_game_average['1']).to eq(1.66667)
    end
  end

  describe '#season_accuracy(season_id)' do
    it 'returns how accurate a given teams shots were by a given season' do
      expect(all_season_data.season_accuracy('20122013')).to be_a(Hash)
      expected_value = {"1"=>0.38462, "2"=>0.22581, "3"=>0.28, "4"=>0.27273}
      expect(all_season_data.season_accuracy('20122013')).to eq(expected_value)
      expect(all_season_data.season_accuracy('20122013')['1']).to eq(0.38462)
    end
  end

  describe '#season_tackles(season_id)' do
    it 'returns how many tackles a given team had by a given season' do
      expect(all_season_data.season_tackles('20122013')).to be_a(Hash)
      expected_value = {"1"=>42, "2"=>118, "3"=>82, "4"=>39}
      expect(all_season_data.season_tackles('20122013')).to eq(expected_value)
      expect(all_season_data.season_tackles('20122013')['1']).to eq(42)
    end
  end

  describe '#single_seasons_creator' do
    it 'returns a hash of data for a given season' do
      expect(all_season_data.single_seasons_creator).to be_a(Hash)
      all_season_data.single_seasons_creator.values.each do |season|
        expect(season).to be_a(SingleSeasonData)
        expect(season.season).to be_a(String)
        expect(season.season.length).to eq(8)
      end
    end
  end
end