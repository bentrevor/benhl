require 'spec_helper'

describe StatsController do
  it 'has a page for standings' do
    get :standings, season: 2012

    expect(response.status).to eq 200
  end

  it 'shows all teams using TeamStandingsPresenters' do
    3.times {|n| Team.create(name: "team#{n}", division_id: n + 1) }

    get :standings, season: 2012

    pres = assigns(:teams)[:atlantic].first

    expect(pres).to be_a TeamStandingsPresenter
    expect(pres.season).to be 2012
  end

  it 'shows standings for the given year' do
    get :standings, season: 2012

    expect(assigns(:season)).to eq [2012,2013]
  end
end
