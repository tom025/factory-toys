module FactoryToys
  class FFactory # Feature Factory
    attr_accessor :filename
    attr_accessor :data

    def initialize(filename)
      @filename = filename

      @output = "# Auto Generated Features\n"
      @output += "# Generated: #{Time.now.to_s}\n"
      @output += "# Source File: #{@filename}\n\n"

    end

    def write
      filename = File.basename(@filename, '.rb') + '.feature'
      File.open(FactoryToys.features_location + "/" + filename, 'w') do |f|
        f.puts self.output
      end
    end
    
    def output
      eval(self.data[:base])

      self.add_feature(self.data[:feature])

      locals = self.send(:local_variables)
      scenarios = locals.find_all{|var| var =~ /_#{FactoryToys.scenarios}$/}
      scenarios.each do |scenario_name|
        feature = eval(scenario_name)
        options = get_options(feature)
        options.each do |option|
          eval(self.option_string(feature, option))
          scenario_name =~ /^(.+)_#{FactoryToys.scenarios}$/
          identifier = $1
          scenario = "#{identifier}_#{FactoryToys.scenario}".to_sym
          raise MissingScenarioError, scenario unless self.data[scenario]
          eval(self.data[scenario])
          @output += eval(scenario.to_s) + "\n\n"
        end
      end
      @output
    end

    def add_feature(feature)
      raise FactoryToys::MissingFeatureDefinitionError if feature.blank?
      eval(feature)
      @output += eval('feature') + "\n\n"
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
      all_options = []
      if scenario[:foreach]
        self.get_option_types(scenario[:foreach]).each do |element|
          raise MissingForeachListError, element.to_s unless scenario[element].is_a?(Array)
          if all_options.empty?
            all_options = scenario[element].map{|element_value| [element_value]}
          else
            all_options = add_option(all_options, scenario[element])
          end
        end
      end
      return all_options
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
