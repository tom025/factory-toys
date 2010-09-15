SETTLEMENT_METHODS = [DCC_DCC = {:buy => 'dcc from dcc', :to => 'dcc to dcc'},
                      REG_REG = {:buy => 'reg from reg', :to => 'reg to reg'}
                      ]
feature = <<-Data
  Test Instruction Queue and Processiung
  In order to ensure the Back Office Processes work as expected
  Back Office
  wants to ensure trades process through queues as required
Data

ing_feature = {
  :foreach => [:direction, :settlement_method],
  :direction => ['buy', 'sell'],
  :settlement_method => SETTLEMENT_METHODS
}

ing_scenario = <<-Data1
  @selenium @#{direction}_trade_ticket_requirements @login_as_middle_office
  Ing Trade Ticket Instructions - #{direction} #{settlement_method[direction]}
    Given I am on the Instructions Screen
    When I click the trade row
    Then I should see "Instruction Details"
    When I set Settlement Method to "#{settlement_method[direction]}" for trade
    Then I should see Settlement Method "#{settlement_method[direction]}" for trade
    When I follow "Broker Confirm"
    Then I should see "Instruct Trade"
    And I should see trade row
    When I follow "Instruct Trade" with confirmation
    Then I should not see trade row
    And Instruction File exists on Hard Drive
Data1
