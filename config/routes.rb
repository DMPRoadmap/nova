Nova::Engine.routes.draw do
  # contributor routes nested under plans, handled by Nova::ContributorsController
  # get    "/plans/:plan_id/contributors",          to: "contributors#index",   as: :plan_contributors
  #get    "/plans/:plan_id/contributors/new",      to: "contributors#new",     as: :new_plan_contributor
  post   "/plans/:plan_id/contributors",          to: "contributors#create"
  get    "/plans/:plan_id/contributors/:id/edit", to: "contributors#edit",    as: :edit_plan_contributor
  patch  "/plans/:plan_id/contributors/:id",      to: "contributors#update"
  put    "/plans/:plan_id/contributors/:id",      to: "contributors#update"
  delete "/plans/:plan_id/contributors/:id",      to: "contributors#destroy"
  
  # other engine-specific routes
  # get "orcid_records(/:orcid_id)", to: "nova/orcid_records#show"
  get "orcid_records(/:orcid_id)", to: "nova/orcid_records#show"
end