require 'classmate/rails/helpers/url_helper'

module Classmate
  module Rails
    module Controller
      module UrlRewriting
        include Classmate::Rails::Helpers::UrlHelper

        def self.included(base)
          base.class_eval do
            helper_method(:classmate_canvas_page_url, :classmate_callback_url)
          end
        end

        protected

        # A helper to generate an URL of the application canvas page URL
        #
        # @param protocol A request protocol, should be either 'http://' or 'https://'.
        #                 Defaults to current protocol.
        def classmate_canvas_page_url(protocol = nil)
          classmate.canvas_page_url(protocol || request.protocol)
        end

        # A helper to generate an application callback URL
        #
        # @param protocol A request protocol, should be either 'http://' or 'https://'.
        #                 Defaults to current protocol.
        def classmate_callback_url(protocol = nil)
          classmate.callback_url(protocol || request.protocol)
        end
      end
    end
  end
end
