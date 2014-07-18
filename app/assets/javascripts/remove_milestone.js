var remove_milestone;
remove_milestone = function(){
    $('.playr-icon-delete').on('click',function(){
         console.log(this);
         var that = this;
          var id = jQuery(this).prev("input[type=hidden]").val();
          if(id ==""  || id==undefined){
            return;
            }
    			jQuery.get(milestone,{fc_id:id},function(data){
   	               console.log(data.status);
   	               if(data.status){
   	                console.log($(that));
   	               removeContainer($(that),id);
   				   $(that).hide();
   	               }else{
   	                // $(that).next(".spinner_fan").hide();
   	                // $(that).show();
   	               }
   	          },'json')
    });
 

}

function removeContainer(link,id){
   jQuery("."+id).remove();
   jQuery(link).prev("input[type=hidden]").remove();

  }

jQuery(document).ready(remove_milestone);
$(document).on('page:load', remove_milestone);