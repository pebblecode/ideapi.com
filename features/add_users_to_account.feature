Feature: Allow account admins to add new users to an account with permissions
    In order to manage users on an account
    As an ideapi account admin
    I want to be able to add users and permissions to the account

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template brief exists
        And I am logged in as an account admin

    Scenario: Adding a new user to an account with no privileges
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Lord    |
            | Last name     | Lucan   | 
            | Email         | lord@lucan.org |
        And I press "Add to account"
        Then I should see "Lord Lucan"
        And I follow "logout"
        And I press "Yes log me out"
        Then "lord@lucan.org" should receive an email with subject "You now have an ideapi.com account"
        When I open the email
        And I click the first link in the email
        Then I should see "Signup"
        Then the "First name:" field should contain "Lord" 
        And the "Last Name:" field should contain "Lucan"
        And the "Email:" field should contain "lord@lucan.org"
        And I fill in the following:
            | Screename             | thelord       |
            | Password              | youcantfindme | 
            | Password confirmation | youcantfindme |
            | Job title             | Escape Artist |
            | Telephone             | 0123456789    |
            | Telephone ext         | 123           |
        And I press "Complete registration"
        Then I should see "You have no briefs."
        

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

    Scenario: Adding collaborator permissions to a new user
        Given I have briefs called Advert brief, Website brief, Photoshoot brielf
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | John          |
            | Last name     | Doe           |
            | Email         | john@doe.com  |
        And I check "Advert brief" within "#brief-privileges" 
        And I press "Add to account"
        Then I should see "We've sent an invitiaton to john@doe.com"
        And I follow "logout"
        And I press "Yes log me out"
        And "john@doe.com" should receive an email with subject "You now have an ideapi.com account"
        When I open the email with subject "You now have an ideapi.com account"
        And I click the first link in the email
        Then I should see "Signup"
        And I fill in the following:
            | Screename             | johndoe       |
            | Password              | foobarpass    | 
            | Password confirmation | foobarpass    |
            | Job title             | Dead body     |
            | Telephone             | 0123456789    |
            | Telephone ext         | 123           |
        And I press "Complete registration"
        Then I should see "Advert brief"
        And I should not see "Website brief"
        And I should not see "Photoshoot brief"
        And I should see "collaborator" within ".brief_item h3 span.user_context"
        And I follow "Advert brief"
        Then I should see "You" within ".side_box:first"

    Scenario: Adding author permissions to a new user
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Kim                   |
            | Last name     | Jongil                |
            | Email         | kimjongil@korea.com   |
        And I check "user[user_briefs_attributes][0][author]"
        And I press "Add to account"
        Then I should see "We've sent an invitiaton to kimjongil@korea.com"
        And I follow "logout"
        And I press "Yes log me out"
        And "kimjongil@korea.com" should receive an email with subject "You now have an ideapi.com account"
        When I open the email with subject "You now have an ideapi.com account"
        And I click the first link in the email
        Then I should see "Signup"
        And I fill in the following:
            | Screename             | kimjong       |
            | Password              | usasuckz      | 
            | Password confirmation | usasuckz      |
            | Job title             | dictator      |
            | Telephone             | 0123456789    |
            | Telephone ext         | 123           |
        And I press "Complete registration"
        Then I should see "Advert brief"
        And I should see "author" within ".brief_item h3 span.user_context"
        And I follow "Advert brief"
        Then I should see "You" within ".side_box:first"
    
    Scenario: Adding approver permissions to a new user
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Tony                  |
            | Last name     | Blair                 |
            | Email         | tony@theblairs.com    |
        And I check "user[user_briefs_attributes][0][approver]"
        And I press "Add to account"
        Then I should see "We've sent an invitiaton to tony@theblairs.com"
        And I follow "logout"
        And I press "Yes log me out"
        And "tony@theblairs.com" should receive an email with subject "You now have an ideapi.com account"
        When I open the email with subject "You now have an ideapi.com account"
        And I click the first link in the email
        Then I should see "Signup"
        And I fill in the following:
            | Screename             | toneloc       |
            | Password              | ihatemandelson| 
            | Password confirmation | ihatemandelson|
            | Job title             | dictator      |
            | Telephone             | 0123456789    |
            | Telephone ext         | 123           |
        And I press "Complete registration"
        Then I should see "Advert brief"
        And I should see "approver" within ".brief_item h3 span.user_context"


    Scenario: Adding an existing user to the account
        Given I have a user called "Chuck Norris"
        When I go to the users page
        Then I should see "Add user to your account"
        And I fill in the following:
            | First name    | Chuck          |
            | Last name     | Norris       |
            | Email         | chuck@norris.com |
        And I press "Add to account"
        Then I should see "Chuck Norris" within "table.friends"
