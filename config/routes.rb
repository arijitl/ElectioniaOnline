ElectioniaOnline::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_facebook_session
  end
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  mount RailsAdminImport::Engine => '/rails_admin_import', :as => 'rails_admin_import'

  post '/buy/:campaign_id/against/:candidate_id/:init', to: 'welcome#buy_campaign', as: :buy_campaign
  post '/cancel/:anticampaign_id', to: 'welcome#cancel_campaign', as: :cancel_campaign
  post '/vote/:candidate_id', to:'welcome#cast_vote', as: :cast_vote
  post '/finalize/:status', to:'welcome#finalize', as: :finalize
  post '/uncast/:vote_id', to:'welcome#uncast_vote', as: :uncast_vote

  get '/evaluate/:id', to:'welcome#evaluate_game', as: :evaluate_game


  post '/my_result/(:game_date)', to: 'welcome#my_result', as: :my_result
  post '/control_new_deck_modal', to: 'welcome#control_new_deck_modal', as: :control_new_deck_modal

  get '/set_session_var/:val', to:'welcome#set_session_var'
  get '/clear_session_var', to:'welcome#clear_session_var'
  get '/get_session_var', to:'fb_session#get_session_var'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
