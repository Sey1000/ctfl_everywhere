Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'missions#index'
  defaults format: :json do
    get '/missions', to: 'missions#index'
  end
end
