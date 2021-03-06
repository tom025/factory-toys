
module FactoryToys
  class MissingEnvironmentError < StandardError; end
  class CloseTagNotFoundError < StandardError; end
  class MissingForeachListError < StandardError; end
  class InternalForEachError < StandardError; end
  class MissingScenarioError < StandardError; end
  class UnknownInlineError < StandardError; end

  class << self
    attr_accessor :features_directory, :source_directory
    attr_accessor :factories
    attr_accessor :scenario, :scenarios
    attr_accessor :max_feature_length

    def factories
      @factories ||= []
    end

    def source_location
      @source_location = ::RAILS_ROOT + '/' + self.source_directory
    rescue NameError
      raise MissingEnvironmentError
    end

    def features_location
      @features_location = ::RAILS_ROOT + '/' + self.features_directory
    rescue NameError
      raise MissingEnvironmentError
    end

    protected
    def source_files
      Dir[File.join(self.source_location, '*.rb')]
    rescue Errno::ENOENT => e
      return "Source Directory Does not exist: #{self.source_directory}"
    end

    def update_required(file, output_file)
      File.open(output_file) {|f| return "# last update: #{File.mtime(file)}\n" != f.readline}
    rescue
      true
    end

    public
    def update_features
      self.source_files.each do |file|
        ft = FactoryToys::FFactory.new(file)
        if self.update_required(file, ft.output_filename)
          ft.write
        end
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
FactoryToys.max_feature_length = 60