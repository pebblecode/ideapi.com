Feature: Allow users to sign up and use ideapi
    In order to use ideapi
    As a general punter
    I want to be able to sign up and use ideapi

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template document exists

    Scenario: Signing up for a new account
        When I go to the signup page
        Then I should see "Create an account"
        And I fill in the following:
            | Company               | pebble.code           |
            | Web Address           | pebble                |
            | First name            | George                |
            | Last name             | Ornbo                 | 
            | Screename             | shapeshed             |
            | Email                 | george@pebbleit.com   |
            | Password              | testing               |
            | Confirm Password      | testing               |
        And I check "user[terms_of_service]" 
        And I press "Create my account"
        Then I should see "Account created"
        And "george@pebbleit.com" should receive an email with subject "Welcome to ideapi!"
        When they open the email with subject "Welcome to ideapi!"
        Then they should see "http://pebble.vcap.me" in the email body

