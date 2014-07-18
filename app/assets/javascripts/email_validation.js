
var email_validation;
email_validation = function(){
	jQuery(".email_validation").blur(function(){
	  emailRegex = new RegExp(/^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$/i);
      emailAddress = jQuery("#"+this.id).val();
      valid = emailRegex.test(emailAddress);
      email_id = this.id;
      if (!valid) {
        //jQuery("#"+this.id).parent().find(".help-inline").html("Enter valid email address");
        //	return false;
      } else{
        jQuery("#"+this.id).parent().find(".help-inline").html("\t");
           jQuery.get(email_valid,{ email : jQuery("#"+this.id).val() },
 function(data) {
              if(data=='avaiable')
               {
				   jQuery("#"+email_id).parent().find(".help-inline").html("\t");
              }
                else

              {
				  jQuery("#"+email_id).parent().find(".help-inline").html(data);
              }
  });

  return true;
}
});
}
jQuery(document).ready(email_validation);
$(document).on('page:load', email_validation);



var project_contacts;
project_contacts = function(){
	$( "#project_client_id" ).change(function() {
		if(!(jQuery("#"+this.id).val()=="")){
			jQuery("#client_contact").hide();
	  //alert( "Handler for .change() called." );
	        jQuery("#client_contact_point").show();
	          jQuery.get(project_cont,{ client_id : jQuery("#"+this.id).val() },
	function(data) {
		         
	             if(data)
	              {
			   
				   jQuery("#client_contact_point").html(data);
	             }
	               else

	             {
				  jQuery("#"+email_id).parent().find(".help-inline").html(data);
                  j

	             }


	 });
 }else{
 	jQuery("#client_contact").show();
	jQuery("#client_contact_point").hide();
 }
	}).trigger('change');
}
jQuery(document).ready(project_contacts);
$(document).on('page:load', project_contacts);



var emp_code_validation;
emp_code_validation = function(){
jQuery(".emp_code_validation").blur(function(){
	emp_code_id = this.id;
    empCodeRegex = new RegExp(/^[a-zA-Z0-9]+$/);
    empCode = jQuery("#"+this.id).val();
    valid = empCodeRegex.test(empCode);
	   if (!valid) 
	   {
         jQuery("#"+this.id).parent().find(".help-inline").html("Enter a valid employee code");
         return false;
       } 
	   else
	   {
          jQuery.get(emp_code_valid,{ emp_code : jQuery("#"+this.id).val() },
function(data) {
             if(data=='avaiable')
              {
			      jQuery("#"+emp_code_id).parent().find(".help-inline").html("\t");
				  return true;
              }
              else
              {
			      jQuery("#"+emp_code_id).parent().find(".help-inline").html(data);
				  return false;
              }
		 });
 		 
	 }
});
}
jQuery(document).ready(emp_code_validation);
$(document).on('page:load', emp_code_validation);
