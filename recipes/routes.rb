
route <<-EOROUTES
  root :to => 'home#index'

  match 'admin',
    :as => :admin,
    :to => 'admin/base#index'

  match 'login',
    :as => :login,
    :to => 'user_sessions#new'

  match 'logout',
    :as => :logout,
    :to => 'user_sessions#destroy'

  match 'signup',
    :as => :signup,
    :to => 'users#new'

  match 'forgot_password',
    :as => :forgot_password,
    :to => 'password_resets#new'

  resource :account, :controller => "users"
  resource :user_session

  resources :password_resets
  resources :users
EOROUTES
git :add => "."
git :commit => "-am 'added basic routes'"