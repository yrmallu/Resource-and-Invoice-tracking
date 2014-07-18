$.validator.addMethod("contact_firstname_required", $.validator.methods.required, "Name can't be blank.");
$.validator.addClassRules("class_contact_firstname", {contact_firstname_required:true});

$.validator.addMethod("contact_email_required", $.validator.methods.required, "Email can't be blank.");
$.validator.addMethod("contact_email_valid", $.validator.methods.email, "Please enter a valid email.");
$.validator.addClassRules("class_contact_email", {contact_email_required:true, contact_email_valid:true});

$.validator.addMethod("t_m_emp_name_required", $.validator.methods.required, "Select Employee.");
$.validator.addClassRules("class_employee_name", {t_m_emp_name_required:true});

$.validator.addMethod("mobile_number", $.validator.methods.number, "Enter only numbers.");
$.validator.addClassRules("class_emp_mobile", {mobile_number:true});

$.validator.addMethod("tel_number", $.validator.methods.number, "Enter only numbers.");
$.validator.addClassRules("class_emp_tel", {tel_number:true});

var required_field;
required_field = function(){
	
	$(".form_validation").validate({
		rules: {
			id: {
				required:true
			},
			"department[name]":"required",
			"role[name]":"required",
			"client[name]":"required",
			"client[website]": "url",	
			"user[firstname]":"required",
			"project[title]":"required",
			"project[user_id]":"required",
			"user[role_id]":"required",
			"user[resource_type]":"required",
			"user[date_of_birth]":"required",
			"fixed_cost[reason]":"required",
			"billable":"required",
			"blah":"required",
			"timesheet_date":"required",
			"timesheet[tasks][name]":"required",
			"timesheet[tasks][task_type_id]":"required",
			"timesheet[tasks][hours]":"required",
//			"project[start_date]":"required",
//			"project[end_date]":"required",
			"project[project_type]":"required",
			"team_member_name":"required",
			"project_id":"required",
            email: {
				required:true,
				email:true
			 },
            "session[email]":{
				required:true,
				email:true
			},
            "session[password]":{
				required:true,
				minlength: 5
			},
			password: {
				required: true,
				minlength: 5
			},
			password_confirmation: {
				required: true,
				minlength: 5,
				equalTo: "#password"
			},
			"exp":{
				number: true
			},
			"user[email]":{
				required:true,
				email:true
			},
			"session[email]":{
				required:true,
				email:true
			},
			"project[total_amount]":{
				required:true,
				number: true
			},
			"project[advanced_amount]":{
				required:true,
				number: true
			},
			"project[sign_off_amount]":{
				required:true,
				number: true
			},
			"project[no_of_milestones]":{
				required:true,
				number: true
			},
			"client[address_attributes][mobile]": {
				number: true,
			},
			"client[address_attributes][telephone_number]": {
				number: true		
				},
			},
			
		messages: {
			    id: "Select Designation.",
				"department[name]": "Department Name cannot be left blank.",
				"role[name]": "Role name cannot be left blank.",
				"client[name]": "Client name cannot be left blank.",
				"client[website]": "Invalid Url.",
				"user[firstname]": "Name cannot be left blank.",
				"user[email]": "Enter a valid email address.",
				"session[email]": "Enter a valid email address.",
				"project[title]":"Project name cannot be left blank.",
				"project[user_id]":"Select project incharge.",
				"user[role_id]":"Select Designation.",
				"user[resource_type]":"Select Employee Type.",
				"user[date_of_birth]":"Date of birth cannot be left blank.",
				"client[address_attributes][telephone_number]": "Please enter only number.",
				"client[address_attributes][mobile]": "Please enter only number.",
				"project[total_amount]":"Please enter only number.",
				"project[advanced_amount]":"Please enter only number.",
				"project[sign_off_amount]":"Please enter only number.",
				"project[no_of_milestones]":"Please enter only number.",
				"fixed_cost[reason]":"Please enter milestone delay reason.",
				"timesheet_date":"Please enter task date.",
				"timesheet[tasks][name]":"Task name cannot be left blank.",
				"timesheet[tasks][task_type_id]":"Select Task Type.",
				"timesheet[tasks][hours]":"Select Task Time.",
//				"project[start_date]":"Project start date cannot be left blank.",
//				"project[end_date]":"Project end date cannot be left blank.",
				"project[project_type]":"Select project type",
				"project_id":"Select Project.",
				"exp":"Please enter only number.",
				"session[email]": "Enter a valid email address",
				"team_member_name":"Enter project member name.",
				email: "Enter a valid email address.",
				telcode: "Please enter less than 4 characters.",
				"session[password]": {
					required: "Please provide a password.",
					minlength: "Your password must be at least 5 characters long."
				},
				password: {
					required: "Please provide a password",
					minlength: "Your password must be at least 5 characters long."
				},
				password_confirmation: {
					required: "Please provide a password",
					minlength: "Your password must be at least 5 characters long.",
					equalTo: "Please enter the same password as above."
				}
		}
	});
}

jQuery(document).ready(required_field);
$(document).on('page:load', required_field);
