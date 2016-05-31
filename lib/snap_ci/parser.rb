require 'multi_json'

module SnapCi
  class Parser
    def initialize(response)
      @body = MultiJson.load(response.body)
    end

    def project

    end
  end
end
