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
      "Project: #{owner}/#{repository}:\n" + pipelines_to_s
    end

    private

    def fetch_pipelines
      pipelines = {}
      mutex = Mutex.new

      uris.map do |uri|
        Thread.new do
          pipeline = @http.get(uri[:path])
          mutex.synchronize { pipelines[uri[:branch]] = pipeline }
        end
      end.each(&:join)

      pipelines
    end

    def pipelines_to_s
      pipelines = []

      fetch_pipelines.each do |branch, pipeline|
        parameters = Parser.new(pipeline).to_parameters
        pipelines << pipeline_to_s(branch, parameters)
      end

      pipelines.join("\n")
    end

    def pipeline_to_s(branch, parameters)
      "  #{branch}: #{parameters[:status]} (#{steps_to_s(parameters[:steps])})"
    end

    def steps_to_s(steps)
      steps.map { |step| "#{step["name"]}: #{step["result"]}" }.join(", ")
    end

    def uris
      branches.map do |branch|
        {
          branch: branch,
          path: "/project/#{owner}/#{repository}/branch/#{branch}/pipelines"
        }
      end
    end
  end
end
