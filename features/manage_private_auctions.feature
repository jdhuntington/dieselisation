Feature: Manage private auctions
  just implmenting rules
  
  Scenario: Everyone buys the cheapest
    Given there is a game with Fred, Bob, Joe, and Jim
    And the game has started
    And the player order is Fred, Bob, Joe, and Jim

    When I am logged in as Fred
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    When I choose to buy the "Lexington Terminal RR"
    And I confirm my action
    Then I should see that it is Bob's turn

    When I am logged in as Bob
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Midland Railroad Co." for 40
    When I choose to buy the "Midland Railroad Co."
    And I confirm my action
    Then I should see that it is Joe's turn

    When I am logged in as Joe
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Waycross & Southern RR" for 70
    When I choose to buy the "Waycross & Southern RR"
    And I confirm my action
    Then I should see that it is Jim's turn

    When I am logged in as Jim
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Ocilla Southern RR" for 100
    When I choose to buy the "Ocilla Southern RR"
    And I confirm my action
    Then I should see that it is Fred's turn
  
    When I am logged in as Fred
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Macon & Birmingham RR" for 150
    When I choose to buy the "Macon & Birmingham RR"
    And I confirm my action
    Then I should see that it is Bob's turn