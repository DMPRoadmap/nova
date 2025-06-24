module Nova
  class ApplicationController < ActionController::Base
    include Pundit::Authorization
    # layout "nova_host_wrapped"
    layout "application"
  end
end
