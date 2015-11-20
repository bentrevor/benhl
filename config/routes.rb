Rails.application.routes.draw do
  root to: redirect('/standings')

  get '/standings(/:scope)', to: 'stats#standings'
end
