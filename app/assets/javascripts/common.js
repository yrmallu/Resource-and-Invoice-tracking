function showHideMenu(liclass)
{
    li=$("#"+liclass)
        
    if(li.hasClass("open"))
    {
        li.removeClass("open") 
        li.find("ul.sub-menu").slideUp('fast'); //hide sub-menu
        li.find("span.arrow:first").removeClass('open'); //remove open class to arrow
    }
    else
    {
       li.removeClass("open").addClass("open"); //add open class to li show li expanded
       li.find("ul.sub-menu").slideDown('fast'); //show sub-menu
       li.find("span.arrow:first").removeClass('open').addClass('open'); //add open class to arrow
    }
}


$(document).ready(function(){
	
	/* Toggle submenu on left panel*/
	$('.page-sidebar span.arrw-pos').on('click', function (e) {
		var container = $(this).attr('container_li');
		showHideMenu(container);
	});
	
	
	//**********************************BEGIN MAIN MENU********************************
		jQuery('.page-sidebar1 li > a').on('click', function (e) {
	            if ($(this).next().hasClass('sub-menu') == false) {
	                return;
		}
     
	            if($(this).attr("redirect") != 'true')
	            {
			        var parent = $(this).parent().parent();

			               parent.children('li.open').children('a').children('.arrow').removeClass('open');
			               parent.children('li.open').children('.sub-menu').slideUp(200);
			               parent.children('li.open').removeClass('open');

			               var sub = jQuery(this).next();
			               if (sub.is(":visible")) {
			                   jQuery('.arrow', jQuery(this)).removeClass("open");
			                   jQuery(this).parent().removeClass("open");
			                   sub.slideUp(200, function () {
			                       handleSidenarAndContentHeight();
			                   });
			               } else {
			                   jQuery('.arrow', jQuery(this)).addClass("open");
			                   jQuery(this).parent().addClass("open");
			                   sub.slideDown(200, function () {
			                       handleSidenarAndContentHeight();
			                   });
			               }
	                e.preventDefault();
	            }
	        });
	//**********************************END MAIN MENU********************************	
	
	
	//this is for showing limited menu on LHS page
$("#li_projects .projectoptions .morelinks").hide();
$('#li_projects .projectoptions  #showmore').on('click', function(e) {
    e.preventDefault();
    if($(this).text() =='show more')
    {
        $("#li_projects .projectoptions .morelinks").slideDown('slow');
        $(this).text('Hide')
    } 
    else        
    {
        $("#li_projects .projectoptions .morelinks").slideUp("slow");
        $(this).text('show more')
    }
        
});


//toggle the LHS menu in mini sidebar mode
$('.page-sidebar li > a').on('click', function(e) {
    if($("#main-menu").hasClass('mini'))
    {
       thiselem=$(this);
       
       if(thiselem.parent('li').attr('id')!= undefined && thiselem.attr('redirect')== 'true')
       {
            e.preventDefault();    
       }
       
        li=$("#"+thiselem.parent('li').attr('id'))
      
        prevstate=li.find("ul.sub-menu").css('display')
        $("#main-menu ul.sub-menu").slideUp("fast");
       
        if(prevstate == 'none')
            li.find("ul.sub-menu").slideDown('fast'); 
        else
            li.find("ul.sub-menu").slideUp('fast'); 
        
        
    }
    
    
});


});
    
    