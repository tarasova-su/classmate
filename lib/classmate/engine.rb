if Rails::VERSION::MAJOR > 2

  module Classmate
    class Engine < ::Rails::Engine
      initializer "classmate.middleware" do |app|
        app.middleware.insert_after(ActionDispatch::ParamsParser, Classmate::Rack::PostCanvasMiddleware)
      end

      initializer "classmate.controller_extension" do
        ActiveSupport.on_load :action_controller do
          ActionController::Base.send(:include, Classmate::Rails::Controller)
        end
      end
    end
  end

else
  ActionController::Dispatcher.middleware.insert_after(ActionController::ParamsParser, Classmate::Rack::PostCanvasMiddleware)

  ActionController::Base.send(:include, Classmate::Rails::Controller)
end
