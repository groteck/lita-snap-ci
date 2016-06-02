require_relative '../../snap_ci'

module Lita
  module Handlers
    class SnapCi < Handler
      config :user, type: String, required: true
      config :token, type: String, required: true
      config :projects, type: Array, required: true

      route(/^snap-ci\s+report$/,
            :all_projects,
            help: {'snap-ci' => 'display integration status' })

      def all_projects(response)
        response.reply ::SnapCi::ProjectList.new(config).to_message
      end

      Lita.register_handler(self)
    end
  end
end
