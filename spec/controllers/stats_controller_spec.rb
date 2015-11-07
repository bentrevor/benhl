require 'spec_helper'

describe StatsController do
  it 'has a page for standings' do
    get :standings

    expect(response.status).to eq 200
  end

  it 'shows all teams' do
    3.times {|n| Team.create(name: "team#{n}") }

    get :standings

    expect(assigns(:teams)).to eq Team.all
  end
end
