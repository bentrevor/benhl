Rails.application.routes.draw do
  get '/standings(/:scope)', to: 'stats#standings'
end
