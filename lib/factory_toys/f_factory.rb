module FactoryToys
  class FFactory # Feature Factory
    attr_accessor :filename
    attr_accessor :data

    def method_missing(name, *args, &block)
      value = eval("@#{name}")
      return value if value
      super(name, *args, &block)
    end

    def initialize(filename)
      @filename = filename
      @header = ["# last update: #{File.mtime(@filename)}"]
      @header << "# Auto Generated Features"
      @header << "# Generated: #{Time.now.to_s}"
      @header << "# Source File: #{@filename}"
      @header << ''
      check_output_length
    end
    
    def check_output_length
      @outputs ||= []
      unless @output && @output.size > 400
        @output = []
        @outputs << @output
      end
    end

    def process_files
      eval(self.data[:base])
      self.add_feature(self.data[:feature])
      conf_names = self.instance_variables
      self.process_file(conf_names)
    end
       
    def output_filename
      filename = File.basename(@filename, ".rb")
      dir = FactoryToys.features_location + filename
      File.join(dir, "#{filename}_0.feature")
    end
    
    def write
      process_files
      
      filename = File.basename(@filename, ".rb")
      dir = File.join(FactoryToys.features_location, filename)
      FileUtils.mkdir_p(dir)
      FileUtils.rm_r(Dir.glob(File.join(dir, "*.feature")))

      @outputs.each_with_index do |output, i|
        File.open(File.join(dir, "#{filename}_#{i}.feature"), 'w') do |f|
          f.puts (@header + output).join("\n") rescue (debugger; puts '????')
        end
      end
    end
    
    def add_feature(feature_def)
      raise FactoryToys::MissingFeatureDefinitionError if feature_def.blank?
      eval(feature_def)
      @header << eval('feature')
      @header << ""
    end

    def process_file(conf_names)
      scenarios = conf_names.find_all{|var| var =~ /_#{FactoryToys.scenarios}$/}
      scenarios.each do |feature_name|
        self.process_scenarios(feature_name)
      end
    end

    def process_scenarios(feature_name)
      feature = eval(feature_name)
      options = self.get_options(feature)
      options.each do |option|
        self.add_scenario(feature, option, feature_name)
      end
    end

    def add_scenario(feature, option, feature_name)
      eval(self.option_string(feature, option))
      scenario_name = self.get_scenario_name(feature_name)
      raise MissingScenarioError, scenario_name unless self.data[scenario_name]
      eval(self.data[scenario_name])
      @output << eval(scenario_name.to_s)
      @output << ''
      check_output_length
    end

    def get_scenario_name(feature_name)
      feature_name =~ /^@(.+)_#{FactoryToys.scenarios}$/
      identifier = $1
      return "#{identifier}_#{FactoryToys.scenario}".to_sym
    end

    def data
      return @data if @data
      file = File.open(@filename, 'r')
      @data = Parser.new(file.read).elements
    end

    def option_string(scenario, option)
      return '' unless scenario[:foreach]
      foreach = get_option_types(scenario[:foreach], false)
      raise InternalForEachError unless foreach.size == option.size
      foreach.map(&:to_s).join(', ') + ' = ' + option.map{|o| self.write_value(o)}.join(', ')
    end

    def write_value(o)
      case o
      when Symbol
        return ":#{o}"
      when String
        return "'#{o}'"
      when Numeric
        return o.to_s  
      when Array
        "[#{o.map{|v| self.write_value(v).join(',')}}]"
      when Hash
        "{#{o.map{|k,v| self.write_value(k) + ' => ' + self.write_value(v)}.join(', ')}}"
      end
    end

    def get_options(scenario)
      all_options = [[]]
      if scenario[:foreach]
        self.get_option_types(scenario[:foreach]).each do |element|
          all_options = process_options(all_options, scenario[element], element)
        end
      end
      return all_options
    end

    def process_options(all_options, elements, element)
      raise MissingForeachListError, element.to_s unless elements.is_a?(Array)
#      return elements.map{|element_value| [element_value]} if all_options.empty?
      return self.add_option(all_options, elements)
    end

    def add_option(all_options, elements)
      options = all_options.clone
      all_options = []
      elements.each do |element_value|
        cur_options = options.clone
        cur_options.map!{|row| [element_value] + row }
        all_options += cur_options
      end
      return all_options
    end

    def get_option_types(option, reverse=true)
      return [option] unless option.is_a?(Array)
      return option unless reverse
      option.reverse
    end
  end
end

#ing_feature = {
#  :foreach => [:direction, :settlement_method],
#  :direction => ['buy', 'sell'],
#  :settlement_method => [1,2,3]
#}
#
#all_options,  options,     current_options
#[]            []             []
#                             [['b'],['s']]
#[['b'],['s']] [['b'],['s']]  [['b'],['s']]
#[]            [['b'],['s']]  [['b'],['s']]
#[]            [['b'],['s']]  a =[['b',1],['s',1]]
#a             [['b'],['s']]  [['b'],['s']]
#a             [['b'],['s']]  b =[['b',2],['s',2]]
#a + b
#
#all_options = [['b', 1], ['b',2],['b',3],['s',1]...]
