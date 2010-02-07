Feature: Manage private auctions
  just implmenting rules
  
  Scenario: Everyone buys the cheapest
    Given there is a game with Fred, Bob, Joe, and Jim
    And the game has started
    And the player order is Fred, Bob, Joe, and Jim

    When I log in as Fred
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    When I choose to buy the "Lexington Terminal RR"
    And I confirm my action
    Then I should see that it is Bob's turn

    When I log in as Bob
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Midland Railroad Co." for 40
    When I choose to buy the "Midland Railroad Co."
    And I confirm my action
    Then I should see that it is Joe's turn

    When I log in as Joe
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Waycross & Southern RR" for 70
    When I choose to buy the "Waycross & Southern RR"
    And I confirm my action
    Then I should see that it is Jim's turn

    When I log in as Jim
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Ocilla Southern RR" for 100
    When I choose to buy the "Ocilla Southern RR"
    And I confirm my action
    Then I should see that it is Fred's turn
  
    When I log in as Fred
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Macon & Birmingham RR" for 150
    When I choose to buy the "Macon & Birmingham RR"
    And I confirm my action
    Then I should see that it is Bob's turn

  Scenario: Bid on the second, someone buys the first, the rest progresses normally
    Given there is a game with Fred, Bob, Joe, and Jim
    And the game has started
    And the player order is Fred, Bob, Joe, and Jim

    When I log in as Fred
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    And I should see the option to bid on "Midland Railroad Co." for 40
    When I choose to bid "40" on "Midland Railroad Co."
    And I confirm my action
    Then I should see that I have "410" dollars left
    Then I should see that it is Bob's turn

    When I log in as Bob
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    When I choose to buy the "Lexington Terminal RR"
    And I confirm my action
    Then player Fred should be in posession of "Midland Railroad Co."
    And I should see that it is Joe's turn

  @purple
  Scenario: Three people bid on the second, someone buys the first
    Given there is a game with Fred, Bob, Joe, and Jim
    And the game has started
    And the player order is Fred, Bob, Joe, and Jim

    When I log in as Fred
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    And I should see the option to bid on "Midland Railroad Co." for 40
    When I choose to bid "40" on "Midland Railroad Co."
    And I confirm my action
    Then I should see that I have "410" dollars left
    Then I should see that it is Bob's turn

    When I log in as Bob
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    And I should see the option to bid on "Midland Railroad Co." for 45
    When I choose to bid "50" on "Midland Railroad Co."
    And I confirm my action
    Then I should see that I have "400" dollars left
    And I should see that it is Joe's turn

    When I log in as Joe
    And I navigate to the current game's play interface
    Then I should see that it is my turn
    And I should see the option to buy the "Lexington Terminal RR" for 20
    And I should see the option to bid on "Midland Railroad Co." for 55
    When I choose to bid "55" on "Midland Railroad Co."
    And I confirm my action
    Then I should see that I have "395" dollars left
    And I should see that it is Jim's turn

