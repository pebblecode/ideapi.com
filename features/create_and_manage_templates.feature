#Feature: Allow account admins to create and manage their own templates
#    In order to create templates that are relvant to my business
#    As an ideapi account admin
#    I want to be able to create and manage templates
#
#    Background:
#        Given there are free, basic and premium plans
#        And a default ideapi template brief exists
#    
#    Scenario: Managing templates
#        Given I am logged in as an account admin
#        When I go to the documents
#        Then I should see "documents"
#        And I follow "templates"
#        Then I should see "You have no templates - create a template to get started."
#
#    @javascript
#    Scenario: Adding a new template
#        Given I am logged in as an account admin
#        When I go to the template briefs page
#        And I follow "create a template"
#        Then I should see "You can add as many questions as you like to your template."
#        And I follow "hide"
#        Then I should not see "You can add as many questions as you like to your template."
#    Scenario: Viewing a list of templates
#        Given I have a template called "My freaking awesome template"
#        And I visit the templates page 
#        Then I should see "My freaking awesome template"
#
#    Scenario: Adding a new template
#        When I go to the templates page
#        Then I should see "Add a new template"
#        And when I follow "Add a new template"
#        Then I should see a page where I can add a new template
#
#    Scenario: Adding a new section to a template
#        Given I have a template called "A mega template"
#        When I go to the templates page 
#        Then I should see "A mega template"
#        And I click edit
#
#    Scenario: Reordering a template
#        Given I have a template called "The best template evarrr!'
#        When I visit the template page
#        Then I should see "Reorder"
#        And when I follow "Reorder"
#        Then I should be able to reorder sections:w



