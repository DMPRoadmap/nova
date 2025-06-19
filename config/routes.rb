Nova::Engine.routes.draw do
  resources :plans do 
    resources: contributors, except: %i[show], to: "nova/contributors"
  end
  
  get "orcid_records(/:orcid_id)", to: "nova/orcid_records#show"
end