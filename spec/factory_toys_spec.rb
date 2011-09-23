require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "FactoryToys" do
  before do
    path = File.dirname(__FILE__)
    path += Dir.pwd + '/' unless path[0..0] == '/'
    Object.send(:remove_const, :RAILS_ROOT) if Object.const_defined?(:RAILS_ROOT)
    Object.const_set(:RAILS_ROOT, path + '/../tmp/empty') 
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
        factory = mock(:fact1, :write => true, :output_filename => '')
        FactoryToys.stub!(:source_files).and_return(['file1', 'file2'])
        FactoryToys::FFactory.should_receive(:new).with('file1').and_return(factory)
        FactoryToys::FFactory.should_receive(:new).with('file2').and_return(factory)
        FactoryToys.update_features
      end

      it 'calls write for each file' do
        factory = mock(:fact1, :output_filename => '')
        FactoryToys.stub!(:source_files).and_return(['file1', 'file2'])
        FactoryToys::FFactory.stub!(:new).and_return(factory)
        factory.should_receive(:write).and_return(true)
        factory.should_receive(:write).and_return(true)
        FactoryToys.update_features
      end
    end

    context 'scenario configuration' do
      it 'default scenario text' do
        FactoryToys.scenario.should == 'scenario'
      end

      it 'default scenarios text' do
        FactoryToys.scenarios.should == 'feature'
      end
    end

    context 'actually produce a file' do
      it 'creates a file' do
        Object.send(:remove_const, :RAILS_ROOT)
        path = File.dirname(__FILE__)
        path += Dir.pwd + '/' unless path[0..0] == '/'
        Object.const_set(:RAILS_ROOT, path + '/../tmp')
        FileUtils.rm_r(FactoryToys.features_location + '/*', :force => true)
        FactoryToys.update_features
      end

      it 'does not override file if no change' do
        Object.send(:remove_const, :RAILS_ROOT)
        path = File.expand_path(File.dirname(__FILE__))
        Object.const_set(:RAILS_ROOT, File.join(path, '..', 'tmp'))
        FileUtils.rm_r(FactoryToys.features_location + '/*', :force => true)
        FactoryToys.update_features
        init_files = Dir.glob(File.join(FactoryToys.features_location, '**', '*.feature')).map{|f| [f, File.open(f){|file| file.read}]}
        FactoryToys.update_features
        new_files = Dir.glob(File.join(FactoryToys.features_location, '**', '*.feature')).map{|f| [f, File.open(f){|file| file.read}]}
        init_files.first.last.should == new_files.first.last
      end
    end

  end

end
