require 'spec_helper'

describe Team do
  let(:team) { described_class.create(division_id: 1) }
  let(:other_team) { described_class.create(division_id: 2) }

  it 'has a division' do
    expect(team.division).to eq :atlantic
    expect(described_class.atlantic).to include team

    expect(other_team.division).to eq :metropolitan
    expect(described_class.metropolitan).to include other_team
  end
end
