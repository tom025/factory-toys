module FactoryToys
  class MissingEnvironmentError < StandardError; end
  
  class << self
    attr_accessor :features_directory, :source_directory
    attr_accessor :factories

    def factories_directory
      @features_directory ||= 'features'
    end

    def source_directory
      @source_directory ||= 'ffactories'
    end

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
end
