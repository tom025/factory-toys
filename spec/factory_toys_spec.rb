require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FactoryToys" do
  before do
    Object.const_set(:RAILS_ROOT, File.dirname(__FILE__) + '/../tmp/empty') unless Object.const_defined?(:RAILS_ROOT)
  end

  context '#update_features' do
    context 'with missing setup/directroies' do
      it "raises error if 'RAILS_ROOT' is not defined" do
        Object.send(:remove_const, :RAILS_ROOT)
        lambda{ FactoryToys.update_features }.should raise_error FactoryToys::MissingEnvironmentError
      end

      it 'does nothing if no ffactories directory' do
        FactoryToys.stub!(:source_files).and_return([])
        lambda{ FactoryToys.update_features}.should_not raise_error
      end
    end

    context 'with data/files for processing' do
      it 'allows custom ffactories directroy' do
        lambda{ FactoryToys.source_directory = 'myfactories' }.should_not raise_error
      end
      
      it 'allows custom features directroy' do
        lambda{ FactoryToys.features_directory = 'myfeatures' }.should_not raise_error
      end

      it 'calls Process FFactory for each file' do
        FactoryToys.stub!(:source_files).and_return(['file1', 'file2'])
        FactoryToys::FFactory.should_receive(:new).with('file1').and_return(true)
        FactoryToys::FFactory.should_receive(:new).with('file2').and_return(true)
        FactoryToys.update_features
      end
    end
  end

end
