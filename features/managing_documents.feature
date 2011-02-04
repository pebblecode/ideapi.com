Feature: Managing documents
    In order manage my ideapi account
    As an ideapi account admin
    I want to be able to manage my documents

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template document exists
        And I am logged in as an account admin
    
    # Scenario OK
    Scenario: Creating a document and publishing it
        When I go to the documents 
        And I follow "Create document"
        Then I should see "Create a new document"
        And I fill in the following:
            | document_title                   | My document      |
        And I press "Create"
        Then I should see "Document was successfully created"
        And I press "publish"
        Then I should see "Document has been saved and marked as published"
    
    # INLINE EDITING
    # 1. Editing the title
    # 2. Editing a document section
    Scenario: Editing a document
        Given I have documents called Advert document, Website document, Photoshoot document
        When I go to the documents 
        And I follow "Advert document"
        Then I follow "Actions"
        And I follow "Edit document"
        And I fill in "document_most_important_message" with "New most important message"
        And I press "update"
        Then I should see "Document was successfully edited"
        And I should see "New most important message"

    Scenario: Deleting a document after creating it
        When I go to the documents 
        And I follow "Create document"
        Then I should see "Create a new document"
        And I fill in the following:
            | document_title                   | My document      |
            | document_most_important_message  | My one liner  |
        And I press "Create"
        Then I should see "Document was successfully created"
        And I press "publish"
        And I press "delete"
        Then I should see "Document deleted"
        
    Scenario: Deleting an existing document
        Given I have documents called Advert document, Website document, Photoshoot document
        When I go to the documents 
        And I follow "Website document"
        And I press "delete"
        Then I should see "Document deleted"
        And I should not see "Website document"

    Scenario: Marking a document as complete
        Given I have documents called Advert document, Website document, Photoshoot document
        When I go to the documents 
        And I follow "Website document"
        And I press "archive"
        Then I should see "Document has been saved and marked as complete."

    Scenario: Reactivating a completed document
        Given I have documents called Advert document, Website document, Photoshoot document
        And "Advert Document" is marked as "complete"
        When I go to the documents
        And I should see "Advert ..." within ".side_box"
        And I follow "Advert ..."
        Then I should see "This document has been marked as complete, and therefore is read-only."        
        And I press "reactivate"
        Then I should see "Document has been saved and marked as published."
