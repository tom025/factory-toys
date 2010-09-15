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
      @data = split_data(file.read)
    end

    def split_data(data)
      rows = data.split("\n")

      while rows.size > 0
        if rows[0] =~ /^[\s]*([^\s]+)[\s]*=[\s]*(<<-)([^\s]+)[\s]*$/
          
        end
      end
    end
  end
end