Feature: Allow users to tag briefs
    In order to manage my briefs effectively
    As an ideapi user
    I want to be able to tag briefs

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template brief exists
        And I am logged in as an account admin

    Scenario: Creating and tagging a new brief
        When I go to the dashboard
        And I follow "Create brief"
        Then I should see "Create a new brief"
        And I fill in the following:
            | brief_title                   | My awesome brief      |
            | brief_most_important_message  | This is my brief      |
            | brief_tag_field               | tag1, tag2, tag3      |
        And I press "Create"
        And I go to the dashboard
        Then I should see "tag1"
        And I follow "tag1"
        Then I should see "My awesome brief"

    Scenario: Editing a brief and deleting a tag
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        When I go to the dashboard
        Then I should see "tag2"
        And I follow "My brief"
        And I follow "edit"
        Then I should see "edit brief"
        Then the "brief_tag_field" field should contain "tag1, tag2"
        When I fill in "brief_tag_field" with "tag1"
        And I press "update"
        And I go to the dashboard
        Then I should not see "tag2"

    Scenario: Editing a brief and replacing all tags
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        When I go to the dashboard
        Then I should see "tag2"
        And I should see "tag1"
        And I follow "My brief"
        And I follow "edit"
        Then I should see "edit brief"
        Then the "brief_tag_field" field should contain "tag1, tag2"
        When I fill in "brief_tag_field" with "tag3"
        And I press "update"
        And I go to the dashboard
        Then I should not see "tag1"
        And I should not see "tag2"
        And I should see "tag3"

    Scenario: Editing a brief and adding a tag
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        When I go to the dashboard
        Then I should see "tag2"
        And I should see "tag1"
        And I follow "My brief"
        And I follow "edit"
        Then I should see "edit brief"
        Then the "brief_tag_field" field should contain "tag1, tag2"
        When I fill in "brief_tag_field" with "tag1, tag2, tag3"
        And I press "update"
        And I go to the dashboard
        Then I should see "tag1"
        And I should see "tag2"
        And I should see "tag3"

    Scenario: Viewing a list of briefs with a tag
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        And I have a brief called "Another brief" tagged with "tag1, tag3"
        When I go to the dashboard 
        And I follow "tag2"
        Then I should see "My brief"
        And I should not see "Another brief"
        And I follow "tag3"
        Then I should see "Another brief"
        And I should not see "My brief"

    Scenario: Deleting a brief with an existing tag
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        When I go to the dashboard
        Then I should see "tag1"
        And I should see "tag2"
        And I follow "My brief"
        And I follow "edit"
        And I press "delete brief"
        Then I should not see "tag1" 
        And I should not see "tag2"
        
    Scenario: Incrementing the tag count
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        And I have a brief called "Another brief" tagged with "tag3"
        And I go to the dashboard
        Then I should see "tag1"
        And I should see "tag1" within ".tag-list li:first"
        And I should see "1" within ".tag-list li:first span"
        And I follow "Another brief"
        And I follow "edit"
        And I fill in "brief_tag_field" with "tag3, tag1"
        And I press "update"
        And I go to the dashboard
        Then I should see "tag1" within ".tag-list li:first"
        And I should see "2" within ".tag-list li:first span"

    Scenario: Decrementing the tag count
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        And I have a brief called "Another brief" tagged with "tag1, tag3"
        And I go to the dashboard
        Then I should see "tag1"
        And I should see "tag1" within ".tag-list li:first"
        And I should see "2" within ".tag-list li:first span"
        And I follow "Another brief"
        And I follow "edit"
        And I fill in "brief_tag_field" with "tag3"
        And I press "update"
        And I go to the dashboard
        Then I should see "tag1" within ".tag-list li:first"
        And I should see "1" within ".tag-list li:first span"

    Scenario: Moving a brief from active to completed
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        And I go to the dashboard
        Then I should see "tag1"
        And I follow "My brief"
        And I follow "edit"
        And I press "Mark as completed"
        Then I should see "Brief has been saved and marked as complete."
        And I go to the dashboard
        Then I should not see "tag1"

    Scenario: Another user tags a brief
        Given I have a brief called "My brief" tagged with "tag1, tag2"
        And I have a user called "Chuck Norris" with the email "chuck@norris.com"
        And "chuck@norris.com" is an author on "My brief"
        And I go to the dashboard
        Then I should see "tag1"
        And I should see "tag2"
        And I follow "logout"
        And I press "Yes log me out"
        Then I should see "Please login to your account"
        And I fill in the following:
            | Email     | chuck@norris.com |
            | Password  | testing          |
        And I press "Login"
        And I go to the dashboard
        Then I should see "tag1"
        And I should see "tag2"
