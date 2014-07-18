 Feature: User Filter
  
 @javascript 
 Scenario: User is signed in and Load user filter partial
   Given a User is signed in and visits the user index page 
   When clicked on Advanced Search link
   Then user_filter partial should contain select box
   Then user should see a partial in left panel
  
 @javascript   
 Scenario: User selects some of the filter options and gets corresponding results
    Given a User is signed in and visits the user index page 
	When clicked on Advanced Search link
    Then clicked on Search button
    Then user should see results in main content
 	
 @javascript   
 Scenario: User clicks on Cancel link in user_filter panel
    Given a User is signed in and visits the user index page 
	When clicked on Advanced Search link
    Then clicked on Cancel link 
    Then user should see Advanced Search link back
     
	 
	 
	 
  
 
 
