Feature: Managing ideas
    In order to collaborate with my documents
    As an ideapi account admin
    I want to be able to manage ideas

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template document exists
        And I am logged in as an account admin
    
    Scenario: Creating a proposal
        Given I have documents called Advert document, Website document, Photoshoot document
        When I go to the documents 
        And I follow "Advert document"
        And I follow "Draft new idea"
        And I fill in "Add a title" with "Hey! I've got an idea!"
        And I fill in "Describe your idea..." with "Here's a crazy idea..."
        And I press "Save" within ".submit"
        Then I should see "Idea successfully created"
        And I should see "Hey! I've got an idea!"
        
    Scenario: Editing a proposal
        Given I have documents called Advert document
        When I go to the documents 
        And I follow "Advert document"
        And I follow "Draft new idea"
        And I fill in "Add a title" with "Hey! I've got an idea!"
        And I fill in "Describe your idea..." with "Here's a crazy idea..."
        And I press "Save" within ".submit"
        Then I should see "Idea successfully created"
        And I should see "Hey! I've got an idea!"
        And I follow "edit" within "#options-menu"
        And I fill in "Add a title" with "One piece at a time"
        And I press "Save" within ".submit"
        Then I should see "Idea successfully updated"
        And I should see "One piece at a time"
        

    # Scenario: Adding new sections to the document
    #     Given I have documents called Advert document, Website document, Photoshoot document
    #     When I go to the documents 
    #     And I follow "Advert document"
    #     And I fill in "new-section-title" with "New Section"
    #     And I fill in "new-section-body" with "Body content"
    #     And I press "submit" within "#new-section"
    #     Then I should see "New Section" within ".section"
    #     And I should see "Body content" within ".section"
    #     
    # Scenario: Deleting a document after creating it
    #     When I go to the documents 
    #     And I follow "Create document"
    #     Then I should see "Create a new document"
    #     And I fill in the following:
    #         | document_title                   | My document      |
    #     And I press "Create"
    #     Then I should see "Document was successfully created"
    #     And I press "publish"
    #     And I press "delete"
    #     Then I should see "Document deleted"
    # 
    # Scenario: Deleting an existing document
    #     Given I have documents called Advert document, Website document, Photoshoot document
    #     When I go to the documents 
    #     And I follow "Website document"
    #     And I press "delete"
    #     Then I should see "Document deleted"
    #     And I should not see "Website document"
    # 
    # Scenario: Marking a document as complete
    #     Given I have documents called Advert document, Website document, Photoshoot document
    #     When I go to the documents 
    #     And I follow "Website document"
    #     And I press "archive"
    #     Then I should see "Document has been saved and marked as complete."
    # 
    # Scenario: Reactivating a completed document
    #     Given I have documents called Advert document, Website document, Photoshoot document
    #     And "Advert document" is marked as "complete"
    #     When I go to the documents
    #     And I should see "Advert document" within "#archived_documents"
    #     And I follow "Advert document"
    #     Then I should see "ARCHIVED" within "#content-header"
    #     And I press "reactivate"
    #     Then I should see "Document has been saved and marked as published."
