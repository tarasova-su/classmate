module Classmate
  module Rails
    module Helpers
      module JavascriptHelper

        # A helper to integrate Classmate JS Api to the current page. Generates a
        # JavaScript code that initializes Javascript client for the current application.
        #
        # @param options  A hash of options for JavaScript generation. Available options are:
        #   :api_server
        #   :apiconnection
        # @param &block   A block of JS code to be inserted in addition to client initialization code.
        def classmate_connect_js(*args, &block)
          options = args.extract_options!

          extra_js = capture(&block) if block_given?

          init_js = <<-JAVASCRIPT
            FAPI.init('#{ options[:api_server] }', '#{ options[:apiconnection] }',
              function() {
                #{extra_js}
              },
              function(error) {
              }
            );
          JAVASCRIPT

          js_url = "#{options[:api_server]}js/fapi.js"

          js = <<-CODE
            <script src="#{ js_url }" type="text/javascript"></script>
          CODE

          js << <<-CODE
            <script type="text/javascript">
              if(typeof FAPI !== 'undefined') {
                #{init_js}
              }
            </script>
          CODE

          js = js.html_safe

          if block_given? && ::Rails::VERSION::STRING.to_i < 3
            concat(js)
          else
            js
          end
        end
      end
    end
  end
end
