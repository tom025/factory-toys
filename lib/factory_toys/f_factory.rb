module FactoryToys
  class FFactory # Feature Factory
    attr_accessor :filename
    attr_accessor :data

    def initialize(filename)
      @output = ''
      @filename = filename
      #build_output(filename)
    end

    def write
      filname = @filename.gsub(/.rb/,'.feature')
      File.open(FactoryToys.features_location + "/" + filename, 'w') do |f|
        f.puts self.output
      end
    end
    
    def output
      eval(self.data[:base])

      self.build_feature(self.data[:feature])

      locals = self.send(:local_variables)
      scenarios = locals.find_all{|var| var =~ /_#{FactoryToys.scenarios}$/}
      scenarios.each do |scenario|
        options = get_options(scenario)
        options.each do |option|
          eval(self.get_option_string(scenario, option))
          option =~ /^(.+)_#{FactoryToys.scenarios}$/
          identifier = $1
          scenario = "#{identifer}_#{FactoryToys.scenario}"
          raise MissingScenarioError, scenario unless scenarios[scenario]
          eval(scenarios[scenario])
          output += scenario + "\n\n"
        end
      end
    end

    def add_feature(feature)
      raise FactoryToys::MissingFeatureDefinitionError if feature.blank?
      output += feature
    end

    def add_scenario(scenario, options)

    end

    def data
      return @data if @data
      file = File.open(FactoryToys.source_location + "/" + @filename, 'r')
      @data = Parser.new(file.read).elements
    end

    def option_string(scenario, option)
      return '' unless scenario[:foreach]
      foreach = get_option_types(scenario[:foreach], false)
      raise InternalForEachError unless foreach.size == option.size
      foreach.map(&:to_s).join(', ') + ' = ' + option.map(&:to_s).join(', ')
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
