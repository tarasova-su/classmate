module Classmate
  module Rails
    module Helpers
      module JavascriptHelper

        # A helper to integrate Facebook Connect to the current page. Generates a
        # JavaScript code that initializes Facebook Javascript client for the
        # current application.
        #
        # @param app_id   Facebook App ID of the application. Defaults to value provided by the current config.
        # @param options  A hash of options for JavaScript generation. Available options are:
        #                   :cookie - Enable cookie generation for the application. Default to true.
        #                   :status - Enable login status check. Defaults to true.
        #                   :xfbml - Enable XFBML tag parsing. Default to true.
        #                   :frictionless - Enable frictionless app request delivery. Defaults to true
        #                   :locale - Locale to use for JavaScript client. Defaults to 'en_US'.
        #                   :weak_cache - Enable FB JS client cache expiration every minute. Defaults to false.
        #                   :async - Enable asynchronous FB JS client code load and initialization. Defaults to false.
        #                   :cache_url - An URL to load custom or cached version of the FB JS client code. Not used by default.
        # @param &block   A block of JS code to be inserted in addition to FB client initialization code.
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
