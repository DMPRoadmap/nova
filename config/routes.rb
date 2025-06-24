Nova::Engine.routes.draw do
  get "orcid_records(/:orcid_id)", to: "orcid_records#show"
end