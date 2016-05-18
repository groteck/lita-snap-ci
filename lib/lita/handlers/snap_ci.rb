module Lita
  module Handlers
    class SnapCi < Handler
      config :token, type: String, required: true
      config :repos, type: Hash, default: {}
      config :default_rooms, type: [Array, String]


      Lita.register_handler(self)
    end
  end
end
