# last update: Wed Sep 15 18:00:01 +0100 2010
# Auto Generated Features
# Generated: Tue Oct 05 14:45:43 +0100 2010
# Source File: /Users/tom025/rails/factory-toys/spec/../tmp/ffactories/simple_factory.rb

  Test Instruction Queue and Processiung
  In order to ensure the Back Office Processes work as expected
  Back Office
  wants to ensure trades process through queues as required


  @selenium @buy_trade_ticket_requirements @login_as_middle_office
  Ing Trade Ticket Instructions - buy dcc from dcc
    Given I am on the Instructions Screen
    When I click the trade row
    Then I should see "Instruction Details"
    When I set Settlement Method to "dcc from dcc" for trade
    Then I should see Settlement Method "dcc from dcc" for trade
    When I follow "Broker Confirm"
    Then I should see "Instruct Trade"
    And I should see trade row
    When I follow "Instruct Trade" with confirmation
    Then I should not see trade row
    And Instruction File exists on Hard Drive


  @selenium @buy_trade_ticket_requirements @login_as_middle_office
  Ing Trade Ticket Instructions - buy reg from reg
    Given I am on the Instructions Screen
    When I click the trade row
    Then I should see "Instruction Details"
    When I set Settlement Method to "reg from reg" for trade
    Then I should see Settlement Method "reg from reg" for trade
    When I follow "Broker Confirm"
    Then I should see "Instruct Trade"
    And I should see trade row
    When I follow "Instruct Trade" with confirmation
    Then I should not see trade row
    And Instruction File exists on Hard Drive


  @selenium @sell_trade_ticket_requirements @login_as_middle_office
  Ing Trade Ticket Instructions - sell 
    Given I am on the Instructions Screen
    When I click the trade row
    Then I should see "Instruction Details"
    When I set Settlement Method to "" for trade
    Then I should see Settlement Method "" for trade
    When I follow "Broker Confirm"
    Then I should see "Instruct Trade"
    And I should see trade row
    When I follow "Instruct Trade" with confirmation
    Then I should not see trade row
    And Instruction File exists on Hard Drive


  @selenium @sell_trade_ticket_requirements @login_as_middle_office
  Ing Trade Ticket Instructions - sell 
    Given I am on the Instructions Screen
    When I click the trade row
    Then I should see "Instruction Details"
    When I set Settlement Method to "" for trade
    Then I should see Settlement Method "" for trade
    When I follow "Broker Confirm"
    Then I should see "Instruct Trade"
    And I should see trade row
    When I follow "Instruct Trade" with confirmation
    Then I should not see trade row
    And Instruction File exists on Hard Drive


