require 'spec_helper'

describe Team do
  let!(:team) { described_class.create(division_id: Team::DIVISION_IDS[:atlantic], abbrev: 'aaa') }
  let!(:other_team) { described_class.create(division_id: Team::DIVISION_IDS[:central], abbrev: 'bbb') }

  it 'has a division' do
    expect(team.division).to eq :atlantic
    expect(described_class.atlantic_division).to include team

    expect(other_team.division).to eq :central
    expect(described_class.central_division).to include other_team
  end

  it 'can be looked up by abbrev' do
    expect(Team['aaa']).to eq team
    expect(Team['bbb']).to eq other_team
    expect(Team['ccc']).to be nil
  end

  it 'has a scope for conference' do
    expect(described_class.eastern_conference).to include team
    expect(described_class.western_conference).to include other_team
  end
end
