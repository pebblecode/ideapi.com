
Feature: Allow account admins to add new users to an account with permissions
    In order to manage users on an account
    As an ideapi account admin
    I want to be able to add users and permissions to the account

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template brief exists
        And I am logged in as an account admin

    Scenario: Adding a new user to an account
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Lord    |
            | Last name     | Lucan   | 
            | Email         | lord@lucan.org |
        And I press "Add to account"
        Then I should see "Lord Lucan"
        And "lord@lucan.org" should receive an email with subject "You now have an ideapi.com account"

    Scenario: Adding a new user to an account with a custom welcome message
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | James   |
            | Last name     | Brown   | 
            | Email         | makeitfunky@jbs.com |
            | Invitation Message (optional) | My custom message tra la la |
        And I press "Add to account"
        Then I should see "James Brown"
        And "makeitfunky@jbs.com" should receive an email with subject "You now have an ideapi.com account"
        When they open the email with subject "You now have an ideapi.com account"
        Then they should see "My custom message tra la la" in the email body

    Scenario: Adding brief permissions to a new user
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | John          |
            | Last name     | Doe           |
            | Email         | john@doe.com  |
        And I check "Advert brief" within "#brief-privileges" 
        And I check "Website brief" within "#brief-privileges" 
        And I check "Photoshoot brief" within "#brief-privileges" 
        And I press "Add to account"
        When I go to the dashboard
        And I follow "Photoshoot brief"
        Then I should see "John Doe"

    Scenario: Adding author permissions to a new user
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Kim           |
            | Last name     | Jongil       |
            | Email         | kimjongil@korea.com  |
        And I check "user[user_briefs_attributes][0][author]"
        And I press "Add to account"
        When I go to the dashboard
        And I follow "Advert brief"
        Then I should see "Kim Jongil"

    
    Scenario: Adding author permissions to a new user
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Tony          |
            | Last name     | Blair       |
            | Email         | tony@theblairs.com |
        And I check "user[user_briefs_attributes][0][approver]"
        And I press "Add to account"
        When I go to the dashboard
        And I follow "Advert brief"
        Then I should see "Tony Blair"


