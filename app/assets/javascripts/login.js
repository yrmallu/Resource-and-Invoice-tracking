var required_field;
required_field = function(){
	
	$('.validate-form').validate({

                rules: {
                    session_email: {
                        required: true
                    },
                    session_password: {
                        required: true,
                    }
                },

				messages: {
						session_email: "Email can't be blank",
						session_password: "Password can't be blank"
				}
            });	

}

jQuery(document).ready(required_field);
$(document).on('page:load', required_field);
