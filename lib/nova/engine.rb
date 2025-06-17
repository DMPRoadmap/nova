module Nova
  class Engine < ::Rails::Engine
    isolate_namespace Nova
  end
end
