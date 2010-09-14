require 'spec_helper'

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
end
