# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

RedmineApp::Application.routes.draw do
  resources :recurring_planning do
    collection do
      get :index
    end
  end
end
