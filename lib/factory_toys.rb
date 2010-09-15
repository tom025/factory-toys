module FactoryToys
  class MissingEnvironmentError < StandardError; end
  class CloseTagNotFoundError < StandardError; end
  class MissingForeachListError < StandardError; end
  class InternalForEachError < StandardError; end
  class MissingScenarioError < StandardError; end

  class << self
    attr_accessor :features_directory, :source_directory
    attr_accessor :factories
    attr_accessor :scenario, :scenarios

    def factories
      @factories ||= []
    end

    def source_location
      @source_location = ::RAILS_ROOT + '/' + self.source_directory
    rescue NameError
      raise MissingEnvironmentError
    end

    protected
    def source_files
      Dir.glob(self.source_location, '*')
    rescue Errno::ENOENT => e
      return "Source Directory Does not exist: #{self.source_directory}"
    end

    public
    def update_features
      self.source_files.each do |file|
        FactoryToys::FFactory.new(file)
      end
    end
  end

  autoload :FFactory, 'factory_toys/f_factory'
  autoload :Parser, 'factory_toys/parser'
end

FactoryToys.scenarios = 'feature'
FactoryToys.scenario = 'scenario'
FactoryToys.features_directory = 'features'
FactoryToys.source_directory = 'ffactories'
