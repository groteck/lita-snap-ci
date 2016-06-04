require 'multi_json'

module SnapCi
  class Parser
    def initialize(response)
      @pipeline = MultiJson.load(response.body)['_embedded']['pipelines'].last
    end

    def to_parameters
      {
        status: @pipeline['result'],
        steps: @pipeline['stages']
      }
    end
  end
end
