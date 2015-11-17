Rails.application.routes.draw do
  get '/standings', to: 'stats#standings'
end
