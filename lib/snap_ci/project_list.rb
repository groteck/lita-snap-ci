require_relative 'project'

module SnapCi
  class ProjectList
    attr_reader :list

    def initialize(args)
      @list = args.projects.map do |project_info|
        Project.new(project_info, args).to_message
      end
    end

    def to_message
      list.join("\n\n")
    end
  end
end
