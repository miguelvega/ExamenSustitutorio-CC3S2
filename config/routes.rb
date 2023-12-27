Rottenpotatoes::Application.routes.draw do
  resources :movies do
    member do
      get 'show_by_director'
      
    end
  end

  
  # Add new routes here

  root :to => redirect('/movies')
end
