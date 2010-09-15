require 'spec_helper'

#implemented here to get tests to pass as in Rails Environment and not ruby core??
class String
  def blank?
    self.nil? or self == ''
  end
end

describe FactoryToys::FFactory do
  before do
    Object.const_set(:RAILS_ROOT, File.dirname(__FILE__) + '/../../tmp') unless Object.const_defined?(:RAILS_ROOT)
  end

  context '#new' do
    it 'takes one parameter - filename' do
      lambda{ FactoryToys::FFactory.new('simple_factory.rb') }.should_not raise_error
    end
  end

  context '#build_output' do
    it 'calls' do
      FactoryToys::FFactory.new('simple_factory.rb')
    end
  end

  context '#get_options' do
    it 'with no options' do
      get_options({}).should == []
    end

    it 'with a single foreach option' do
      get_options({:foreach => :opt1, :opt1 => [1,2,3]}).should == [[1],[2],[3]]
    end
    
    it 'with two foreach option' do
      get_options({:foreach => [:opt1, :opt2],
                    :opt1 => [1,2,3],
                    :opt2 => [3,4]}).should ==
                          [[1,3],[1,4],[2,3],[2,4],[3,3],[3,4]]
    end

    it 'raise error if missing foreach list' do
      lambda{ get_options({:foreach => :opt1, :opt => [1,2,3]})}.
          should raise_error FactoryToys::MissingForeachListError

    end

    def get_options(scenario)
      FactoryToys::FFactory.new('').get_options(scenario)
    end
  end

  context '#option_string' do
    it 'returns an empty string if no foreach' do
      option_string({}).should == ''
    end

    it 'raises an error if option != foreach' do
      lambda{option_string({:foreach => [:opt1, :opt2]}, [1])}.
          should raise_error FactoryToys::InternalForEachError
    end

    it 'returns for one element' do
      option_string({:foreach => :opt1}, [1]).
          should == 'opt1 = 1'
    end

    it 'returns for two elements' do
      option_string({:foreach => [:opt1, :opt2]}, [1, 2]).
          should == 'opt1, opt2 = 1, 2'
    end

    def option_string(scenario, option=[])
      FactoryToys::FFactory.new('').option_string(scenario, option)
    end
  end
end
