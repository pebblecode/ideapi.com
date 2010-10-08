Feature: Control access to briefs based on user roles
    In order to manage the process of creating a brief
    As an ideapi user
    I should only be able to certain things based on my role

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
        Then I should see "We've sent an invitiaton to lord@lucan.org"
        Then I should see "Lord Lucan" within "table.friends"
        And I follow "Logout"
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
        
