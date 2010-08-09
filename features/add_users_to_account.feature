
Feature: Allow account admins to add users to an account with permissions
    In order to manage users on an account
    As an ideapi account admin
    I want to be able to add users and permissions to the account

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template brief exists

    Scenario: Adding a new user to an account
        Given I am logged in as an account admin
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Lord    |
            | Last name     | Lucan   | 
            | Email         | lord@lucan.org |
        And I press "Add to account"
        Then I should see "Lord Lucan"

    Scenario: Adding brief permissions to a new user
        Given I am logged in as an account admin
        And I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the users page
        Then I should see "Advert brief"
        


