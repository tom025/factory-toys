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
        {:base => '@hello="hello there"'}
    end

    it 'returns straight text in the under :base with multiple lines' do
      parser = FactoryToys::Parser.new("hello='hello there'\ngoodbye='bye bye'")
      parser.elements.should ==
        {:base => "@hello='hello there'\n@goodbye='bye bye'"}
    end

    it 'does not break hashs' do
      parser = FactoryToys::Parser.new("hello_hash = {\n:hello='hello there',\n:goodbye='bye bye'}")
      parser.elements.should ==
        {:base => "@hello_hash = {\n:hello='hello there',\n:goodbye='bye bye'}"}

    end

    context 'extracting from multi-line comment' do
      it 'create element for named after variable' do
        run_factory[:other_string].should_not == nil
      end

      it 'removes excess white space' do
        run_factory[:other_string].should == "@other_string = <<-TestData\n" +
                                     "value=test\n" +
                                     "TestData"
      end

      it "returns unextracted data" do
        run_factory[:base].should == "@test='testing'\n@greeting='Hello Again'"
      end

      it "does not remove blank lines" do
        run_factory("\n\ndate='Dont look at me??'")[:base].should ==
          "@test='testing'\n@greeting='Hello Again'\n\n\n@date='Dont look at me??'"
      end

      it "when named variables only" do
        string = <<-Data
other_string = <<-TestData
value=test
TestData
Data
        parser = FactoryToys::Parser.new(string)

        parser.elements[:base].should == ''
        parser.elements[:other_string].should == "@other_string = <<-TestData\n" +
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

    context 'with inline data sharing' do
      it 'supports unline use of existing elements' do
        string = <<-Data
string_one = <<-Str1
This is the test
Str1
string_two = <<-Str2
This is an inline test
<< string_one
Str2
Data

        parser = FactoryToys::Parser.new(string)

        parser.elements[:base].should == ''
        parser.elements[:string_one].should == "@string_one = <<-Str1\n" +
                      "This is the test\n" +
                      "Str1"

        parser.elements[:string_two].should == "@string_two = <<-Str2\n" +
                      "This is an inline test\n" +
                      "This is the test\n" +
                      "Str2"
      end

      it 'supports inline use of multi-line existing elements' do
        string = <<-Data
string_one = <<-Str1
This is the test
And so is this
Str1
string_two = <<-Str2
This is an inline test
<< string_one
Str2
Data

        parser = FactoryToys::Parser.new(string)

        parser.elements[:base].should == ''

        parser.elements[:string_two].should == "@string_two = <<-Str2\n" +
                      "This is an inline test\n" +
                      "This is the test\n" +
                      "And so is this\n" +
                      "Str2"
      end

      it 'when invalid inline element raises an error' do
        string = <<-Data
string_one = <<-Str1
This is the test
Str1
string_two = <<-Str2
This is an inline test
<< string_error
Str2
Data

        lambda{ FactoryToys::Parser.new(string) }.should raise_error FactoryToys::UnknownInlineError, "string_error"
      end
    end
  end
end
