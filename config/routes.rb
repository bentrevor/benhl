Rails.application.routes.draw do
  get '/standings/:season', to: 'stats#standings'
end
