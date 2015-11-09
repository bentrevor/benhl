Rails.application.routes.draw do
  get '/standings/:season(/:last_n)', to: 'stats#standings'
end
