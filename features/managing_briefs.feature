Feature: Managing briefs
    In order manage my ideapi account
    As an ideapi account admin
    I want to be able to manage my briefs

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template brief exists
        And I am logged in as an account admin

    Scenario: Creating a brief and publishing it
        When I go to the documents 
        And I follow "Create brief"
        Then I should see "Create a new brief"
        And I fill in the following:
            | brief_title                   | My brief      |
            | brief_most_important_message  | My one liner  |
        And I press "Create"
        Then I should see "Brief was successfully created"
        And I press "publish"
        Then I should see "Brief has been saved and marked as published"

    Scenario: Creating a brief and marking it as a draft
        When I go to the documents 
        And I follow "Create brief"
        Then I should see "Create a new brief"
        And I fill in the following:
            | brief_title                   | My brief      |
            | brief_most_important_message  | My one liner  |
        And I press "Create"
        Then I should see "Brief was successfully created"
        And I press "save draft"
        Then I should see "Brief was successfully edited"

    Scenario: Publishing a draft brief
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        And "Advert brief" is marked as "draft"
        When I go to the documents
        And I follow "Advert brief"
        And I press "publish"
        Then I should see "Brief has been saved and marked as published."

    Scenario: Editing a brief
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the documents 
        And I follow "Advert brief"
        Then I follow "Actions"
        And I follow "Edit brief"
        And I fill in "brief_most_important_message" with "New most important message"
        And I press "update"
        Then I should see "Brief was successfully edited"
        And I should see "New most important message"

    Scenario: Deleting a brief after creating it
        When I go to the documents 
        And I follow "Create brief"
        Then I should see "Create a new brief"
        And I fill in the following:
            | brief_title                   | My brief      |
            | brief_most_important_message  | My one liner  |
        And I press "Create"
        Then I should see "Brief was successfully created"
        And I press "publish"
        And I press "delete"
        Then I should see "Brief deleted"
        
    Scenario: Deleting an existing brief
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the documents 
        And I follow "Website brief"
        And I press "delete"
        Then I should see "Brief deleted"
        And I should not see "Website brief"

    Scenario: Marking a brief as complete
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        When I go to the documents 
        And I follow "Website brief"
        And I press "archive"
        Then I should see "Brief has been saved and marked as complete."

    Scenario: Reactivating a completed brief
        Given I have briefs called Advert brief, Website brief, Photoshoot brief
        And "Advert Brief" is marked as "complete"
        When I go to the documents
        And I should see "Advert ..." within ".side_box"
        And I follow "Advert ..."
        Then I should see "This brief has been marked as complete, and therefore is read-only."        
        And I press "reactivate"
        Then I should see "Brief has been saved and marked as published."
