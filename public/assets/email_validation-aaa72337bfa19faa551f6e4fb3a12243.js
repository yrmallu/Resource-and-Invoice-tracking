var email_validation;email_validation=function(){jQuery(".email_validation").blur(function(){return emailRegex=new RegExp(/^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$/i),emailAddress=jQuery("#"+this.id).val(),valid=emailRegex.test(emailAddress),email_id=this.id,valid?(jQuery("#"+this.id).parent().find(".help-inline").html("	"),jQuery.get(email_valid,{email:jQuery("#"+this.id).val()},function(e){"avaiable"==e?jQuery("#"+email_id).parent().find(".help-inline").html("	"):jQuery("#"+email_id).parent().find(".help-inline").html(e)}),!0):void 0})},jQuery(document).ready(email_validation),$(document).on("page:load",email_validation);var project_contacts;project_contacts=function(){$("#project_client_id").change(function(){""!=jQuery("#"+this.id).val()?(jQuery("#client_contact").hide(),jQuery("#client_contact_point").show(),jQuery.get(project_cont,{client_id:jQuery("#"+this.id).val()},function(e){e?jQuery("#client_contact_point").html(e):jQuery("#"+email_id).parent().find(".help-inline").html(e)})):(jQuery("#client_contact").show(),jQuery("#client_contact_point").hide())}).trigger("change")},jQuery(document).ready(project_contacts),$(document).on("page:load",project_contacts);