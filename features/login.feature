Feature: Allow users to sign up and register
    In order to use ideapi
    As a general punter
    I want to be able to create an account and login

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template brief exists

    Scenario: Creating an account
        When I go to the sign up page
        And  I fill in the following:
            | Company               | ACME Co   |
            | Domain                | acmeco    |
            | First name            | Donald    |
            | Last name             | Smith     |
            | Screename             | dsmith    |
            | Email                 | donald@acmeco.com |
            | Password              | foobar |
            | Confirm Password      | foobar |
        And I check "user_terms_of_service"
        And I press "Create my account"
        Then I should see "Account created"

    Scenario: Logging in to an account
        Given I have a valid account for 'donald@acmeco.com'
        When I go to the account login page
        And I fill in the following:
        And I press "Login"
        Then I should see "You are now logged in"
