$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'ruby-debug'
require 'factory_toys'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

begin
  SETTLEMENT_METHODS
rescue
  SETTLEMENT_METHODS = [DCC_DCC = {:buy => 'dcc from dcc', :to => 'dcc to dcc'},
                        REG_REG = {:buy => 'reg from reg', :to => 'reg to reg'}
                        ]
end

#implemented here to get tests to pass as in Rails Environment and not ruby core??
class String
  def blank?
    self.nil? or self == ''
  end
end
