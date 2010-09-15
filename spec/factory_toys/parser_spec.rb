require 'spec_helper'

#implemented here to get tests to pass as in Rails Environment and not ruby core??
class String
  def blank?
    self.nil? or self == ''
  end
end

describe FactoryToys::Parser do
  context 'on initialization' do
    it 'returns straight text in the under :base' do
      parser = FactoryToys::Parser.new('hello="hello there"')
      parser.elements.should ==
        {:base => 'hello="hello there"'}
    end

    it 'returns straight text in the under :base with multiple lines' do
      parser = FactoryToys::Parser.new('hello="hello there"\ngoodbye="bye bye"')
      parser.elements.should ==
        {:base => 'hello="hello there"\ngoodbye="bye bye"'}
    end

    context 'extracting from multi-line comment' do
      it 'create element for named after variable' do
        run_factory[:other_string].should_not == nil
      end

      it 'removes excess white space' do
        run_factory[:other_string].should == "other_string = <<-TestData\n" +
                                     "value=test\n" +
                                     "TestData"
      end

      it "returns unextracted data" do
        run_factory[:base].should == "test='testing'\ngreeting='Hello Again'"
      end

      it "removes blank lines" do
        run_factory("\n\ndate='Dont look at me??'")[:base].should ==
          "test='testing'\ngreeting='Hello Again'\ndate='Dont look at me??'"
      end

      it "when named variables only" do
        string = <<-Data
        other_string = <<-TestData
          value=test
        TestData
        Data
        parser = FactoryToys::Parser.new(string)

        parser.elements[:base].should == ''
        parser.elements[:other_string].should == "other_string = <<-TestData\n" +
                                     "value=test\n" +
                                     "TestData"
      end

      def run_factory(additional_text='')
        string = <<-Data
        test='testing'
        other_string = <<-TestData
          value=test
        TestData
        greeting='Hello Again'
        Data
        parser = FactoryToys::Parser.new(string + additional_text)
        parser.elements
      end
    end
  end
end
