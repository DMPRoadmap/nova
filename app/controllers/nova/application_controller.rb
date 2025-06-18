module Nova
  class ApplicationController < ActionController::Base
    before_action :prefer_engine_views

    private 

    def prefer_engine_views
      prepend_view_path Nova::Engine.root.join("app/views")
    end
  end
end
