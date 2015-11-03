module Classmate
  class Engine < ::Rails::Engine
    initializer "classmate.middleware" do |app|
      app.middleware.insert_after(ActionDispatch::ParamsParser, Classmate::Middleware)
    end

    initializer "classmate.controller_extension" do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send(:include, Classmate::Rails::Controller)
      end
    end
  end
end
