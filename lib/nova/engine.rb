module Nova
  class Engine < ::Rails::Engine
    isolate_namespace Nova

    initializer "nova.prepend_view_paths" do 
      ActiveSupport.on_load(:action_controller) do 
        prepend_view_path Nova::Engine.root.join("app/views")
      end
    end
  end
end
