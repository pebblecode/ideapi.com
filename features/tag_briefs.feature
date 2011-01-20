Feature: Allow users to tag documents
    In order to manage my documents effectively
    As an ideapi user
    I want to be able to tag documents

    Background:
        Given there are free, basic and premium plans
        And a default ideapi template document exists
        And I am logged in as an account admin

    Scenario: Creating and tagging a new document
        When I go to the documents
        And I follow "Create document"
        Then I should see "Create a new document"
        And I fill in the following:
            | document_title                   | My awesome document      |
            | document_most_important_message  | This is my document      |
            | document_tag_field               | tag1, tag2, tag3      |
        And I press "Create"
        And I go to the documents
        Then I should see "tag1"
        And I follow "tag1"
        Then I should see "My awesome document"

    Scenario: Editing a document and deleting a tag
        Given I have a document called "My document" tagged with "tag1, tag2"
        When I go to the documents
        Then I should see "tag2"
        And I follow "My document"
        And I follow "Edit document"
        Then I should see "edit document"
        Then the "document_tag_field" field should contain "tag1, tag2"
        When I fill in "document_tag_field" with "tag1"
        And I press "update"
        And I go to the documents
        Then I should not see "tag2"

    Scenario: Editing a document and replacing all tags
        Given I have a document called "My document" tagged with "tag1, tag2"
        When I go to the documents
        Then I should see "tag2"
        And I should see "tag1"
        And I follow "My document"
        And I follow "Edit document"
        Then I should see "edit document"
        Then the "document_tag_field" field should contain "tag1, tag2"
        When I fill in "document_tag_field" with "tag3"
        And I press "update"
        And I go to the documents
        Then I should not see "tag1"
        And I should not see "tag2"
        And I should see "tag3"

    Scenario: Editing a document and adding a tag
        Given I have a document called "My document" tagged with "tag1, tag2"
        When I go to the documents
        Then I should see "tag2"
        And I should see "tag1"
        And I follow "My document"
        And I follow "Edit document"
        Then I should see "edit document"
        Then the "document_tag_field" field should contain "tag1, tag2"
        When I fill in "document_tag_field" with "tag1, tag2, tag3"
        And I press "update"
        And I go to the documents
        Then I should see "tag1"
        And I should see "tag2"
        And I should see "tag3"

    Scenario: Viewing a list of documents with a tag
        Given I have a document called "My document" tagged with "tag1, tag2"
        And I have a document called "Another document" tagged with "tag1, tag3"
        When I go to the documents 
        And I follow "tag2"
        Then I should see "My document"
        And I should not see "Another document"
        And I follow "tag3"
        Then I should see "Another document"
        And I should not see "My document"

    Scenario: Deleting a document with an existing tag
        Given I have a document called "My document" tagged with "tag1, tag2"
        When I go to the documents
        Then I should see "tag1"
        And I should see "tag2"
        And I follow "My document"
        And I press "delete"
        Then I should not see "tag1" 
        And I should not see "tag2"
        
    Scenario: Incrementing the tag count
        Given I have a document called "My document" tagged with "tag1, tag2"
        And I have a document called "Another document" tagged with "tag3"
        And I go to the documents
        Then I should see "tag1"
        And I should see "tag1" within ".tag-list li:nth-child(2)"
        And I should see "1" within ".tag-list li:nth-child(2) span"
        And I follow "Another document"
        And I follow "Edit document"
        And I fill in "document_tag_field" with "tag3, tag1"
        And I press "update"
        And I go to the documents
        Then I should see "tag1" within ".tag-list li:nth-child(2)"
        And I should see "2" within ".tag-list li:nth-child(2) span"

    Scenario: Decrementing the tag count
        Given I have a document called "My document" tagged with "tag1, tag2"
        And I have a document called "Another document" tagged with "tag1, tag3"
        And I go to the documents
        Then I should see "tag1"
        And I should see "tag1" within ".tag-list li:nth-child(2)"
        And I should see "2" within ".tag-list li:nth-child(2) span"
        And I follow "Another document"
        And I follow "Edit document"
        And I fill in "document_tag_field" with "tag3"
        And I press "update"
        And I go to the documents
        Then I should see "tag1" within ".tag-list li:nth-child(2)"
        And I should see "1" within ".tag-list li:nth-child(2) span"

    Scenario: Moving a document from active to completed
        Given I have a document called "My document" tagged with "tag1, tag2"
        And I go to the documents
        Then I should see "tag1"
        And I follow "My document"
        And I press "archive"
        Then I should see "Document has been saved and marked as complete."
        And I go to the documents
        Then I should not see "tag1"

    Scenario: Another user tags a document
        Given I have a document called "My document" tagged with "tag1, tag2"
        And I have a user called "Chuck Norris" with the email "chuck@norris.com"
        And "chuck@norris.com" is an author on "My document"
        And I go to the documents
        Then I should see "tag1"
        And I should see "tag2"
        And I follow "Logout"
        And I press "Yes log me out"
        Then I should see "Please login to your account"
        And I fill in the following:
            | Email     | chuck@norris.com |
            | Password  | testing          |
        And I press "Login"
        And I go to the documents
        Then I should see "tag1"
        And I should see "tag2"
