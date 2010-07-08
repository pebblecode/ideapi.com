Feature: Allow users to sign up and register
    In order to use ideapi
    As a general punter
    I want to be able to create an account and login

    Scenario: Logging in 
        Given I have created a valid account
        When I go to the login page
        And I fill in # with #
        And I fill in # with #
        Then I should see 
