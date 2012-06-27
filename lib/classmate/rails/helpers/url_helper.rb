module Classmate
  module Rails
    module Helpers
	    module UrlHelper
        # Overrides UrlHelper#url_for to filter out secure Odnoklassniki params
        # and add Classmate Canvas URL if necessary
        def url_for(options = {})
          if options.is_a?(Hash)
            if options.delete(:canvas) && !options[:host]
              options[:only_path] = true

              canvas = true
            else
              canvas = false
            end

            url = super(options.except(:signed_params))

            canvas ? classmate.canvas_page_url(request.protocol) + url : url
          else
            super
          end
        end
      end
    end
  end
end
