module FactoryToys
  class FFactory
    attr_accessor :output, :filename
    attr_accessor :data

    def initialize(filename)
      @output = ''
      @filename = filename
      build_output(filename)
    end

    def build_output(filename)
      eval(self.data)

      self.build_feature(feature)
    end

    def build_feature(feature)
      debugger
      output += feature
    end

    def build_scenario(scenario, options)

    end

    def data
      return @data if @data
      file = File.open(FactoryToys.source_location + "/" + @filename, 'r')
      @data = file.read
    end
  end
end