Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'rankings#index'
  get "rankings/players" => "rankings#players"
  get "rankings/tournois" => "rankings#tournois"

  get "informations/calcul_elo" => "informations#calcul_elo"
  get "informations/contact" => "informations#contact"
  get "informations/partenaire" => "informations#partenaire"
  get "informations/association" => "informations#association"

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :new, :create, :show]

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :events, only: [:index, :new, :create, :show] do
    get :game
  end
  resources :matches, only: [:index, :new, :create, :show]
  resources :players, only: [:index, :new, :create, :show]
  resources :elos, only: [:index, :new, :create, :show]

end
