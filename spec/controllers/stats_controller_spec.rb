require 'spec_helper'

describe StatsController do
  it 'has a page for standings' do
    get :standings, season: 2012

    expect(response.status).to eq 200
  end

  it 'shows all teams using TeamPresenters' do
    3.times {|n| Team.create(name: "team#{n}") }

    get :standings, season: 2012

    # expect(assigns(:teams).first).to be_a TeamPresenter
    expect(assigns(:teams).first.season).to be 2012
  end

  it 'shows standings for the given year' do
    get :standings, season: 2012

    expect(assigns(:season)).to eq [2012,2013]
  end
end
