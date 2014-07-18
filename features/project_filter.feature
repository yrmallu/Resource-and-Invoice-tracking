 Feature: Project Filter
  
 @javascript 
 Scenario: User is signed in and Load project filter partial
   Given a User is signed in and visits the project index page 
   When clicked on Advanced Search link
   Then project_filter partial has select box
   Then user see a _project_filter partial 
  
 @javascript   
 Scenario: User selects some of the filter options and gets corresponding results
    Given a User is signed in and visits the project index page 
 	When clicked on Advanced Search link
    Then press Search button
    Then user see results in main content
 	
 @javascript   
 Scenario: User clicks on Cancel link in project_filter panel
    Given a User is signed in and visits the project index page 
 	When clicked on Advanced Search link
    Then clicked on Cancel link 
    Then user should see Advanced Search link back
     
	 