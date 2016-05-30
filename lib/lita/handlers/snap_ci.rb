require_relative '../../snap_ci_http'

module Lita
  module Handlers
    class SnapCi < Handler
      config :user, type: String, required: true
      config :token, type: String, required: true
      config :projects, type: Array, required: true

      route(/^snap-ci\s+status$/,
            :status,
            help: {'snap-ci' => 'display integration status' })

      def status(response)
        http_response = http.get
        response.reply MultiJson.load(http_response.body)
      end

      private

      def http
        SnapCi::Http.new(config)
      end

      Lita.register_handler(self)
    end
  end
end
