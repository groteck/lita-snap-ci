require_relative 'http'
require_relative 'parser'

module SnapCi
  class Project
    attr_reader :owner, :repository, :branches

    def initialize(args, config)
      @owner = args[:owner]
      @repository = args[:repository]
      @branches = args[:branches]
      @http = Http.new(config)
    end

    def to_message
      "Project: #{owner}/#{repository}:\n" +
      fetch_pipelines.each_with_index.map do |pipeline, index|
        parameters = Parser.new(pipeline).to_parameters

        "  #{branches[index]}: #{parameters[:status]} (" +
        parameters[:steps].map do |step|
          "#{step["name"]}: #{step["result"]}"
        end.join(", ") + ")"
      end.join("\n")
    end

    private

    def fetch_pipelines
      pipelines = []
      mutex = Mutex.new

      uris.map do |uri|
        Thread.new do
          pipeline = @http.get(uri)
          mutex.synchronize { pipelines << pipeline }
        end
      end.each(&:join)

      pipelines
    end

    def uris
      branches.map do |branch|
        "/project/#{owner}/#{repository}/branch/#{branch}/pipelines"
      end
    end
  end
end
