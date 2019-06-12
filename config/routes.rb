Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'rankings#index'
  get "rankings/players_t7" => "rankings#players_t7"
  get "rankings/tournois_t7" => "rankings#tournois_t7"
  get "rankings/players_smbu" => "rankings#players_smbu"

  get "informations/calcul_elo" => "informations#calcul_elo"
  get "informations/contact" => "informations#contact"

  resources :events, only: [:index, :new, :create, :show] do
    get :game
  end
  resources :matches, only: [:index, :new, :create, :show]
  resources :players, only: [:index, :new, :create, :show]
  resources :elos, only: [:index, :new, :create, :show]

end
