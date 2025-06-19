Nova::Engine.routes.draw do
  resources: contributors, except: %i[show], to: "nova/contributors"
  
  get "orcid_records(/:orcid_id)", to: "nova/orcid_records#show"
end