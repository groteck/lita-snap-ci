require 'multi_json'

module SnapCi
  class Parser
    def initialize(response)
      @body = MultiJson.load(response.body)
    end

    def to_message
      @body['_embedded']['pipelines'].last['result']
    end
  end
end
