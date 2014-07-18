function fnFormatDetails(a,e){var t=a.fnGetData(e),o='<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;" class="inner-table">';return o+="<tr><td>Rendering engine:</td><td>"+t[1]+" "+t[4]+"</td></tr>",o+="<tr><td>Link to source:</td><td>Could provide a link here</td></tr>",o+="<tr><td>Extra info:</td><td>And any further details here (images etc)</td></tr>",o+="</table>"}$.extend(!0,$.fn.dataTable.defaults,{sDom:"<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span12'p i>>",sPaginationType:"bootstrap",oLanguage:{sLengthMenu:"_MENU_"}}),$.extend($.fn.dataTableExt.oStdClasses,{sWrapper:"dataTables_wrapper form-inline"}),$.fn.dataTableExt.oApi.fnPagingInfo=function(a){return{iStart:a._iDisplayStart,iEnd:a.fnDisplayEnd(),iLength:a._iDisplayLength,iTotal:a.fnRecordsTotal(),iFilteredTotal:a.fnRecordsDisplay(),iPage:-1===a._iDisplayLength?0:Math.ceil(a._iDisplayStart/a._iDisplayLength),iTotalPages:-1===a._iDisplayLength?0:Math.ceil(a.fnRecordsDisplay()/a._iDisplayLength)}},$.extend($.fn.dataTableExt.oPagination,{bootstrap:{fnInit:function(a,e,t){var o=(a.oLanguage.oPaginate,function(e){e.preventDefault(),a.oApi._fnPageChange(a,e.data.action)&&t(a)});$(e).addClass("pagination").append('<ul><li class="prev disabled"><a href="#"><i class="fa fa-chevron-left"></i></a></li><li class="next disabled"><a href="#"><i class="fa fa-chevron-right"></i></a></li></ul>');var n=$("a",e);$(n[0]).bind("click.DT",{action:"previous"},o),$(n[1]).bind("click.DT",{action:"next"},o)},fnUpdate:function(a,e){var t,o,n,l,s,i,r=5,d=a.oInstance.fnPagingInfo(),c=a.aanFeatures.p,_=Math.floor(r/2);for(d.iTotalPages<r?(s=1,i=d.iTotalPages):d.iPage<=_?(s=1,i=r):d.iPage>=d.iTotalPages-_?(s=d.iTotalPages-r+1,i=d.iTotalPages):(s=d.iPage-_+1,i=s+r-1),t=0,o=c.length;o>t;t++){for($("li:gt(0)",c[t]).filter(":not(:last)").remove(),n=s;i>=n;n++)l=n==d.iPage+1?'class="active"':"",$("<li "+l+'><a href="#">'+n+"</a></li>").insertBefore($("li:last",c[t])[0]).bind("click",function(t){t.preventDefault(),a._iDisplayStart=(parseInt($("a",this).text(),10)-1)*d.iLength,e(a)});0===d.iPage?$("li:first",c[t]).addClass("disabled"):$("li:first",c[t]).removeClass("disabled"),d.iPage===d.iTotalPages-1||0===d.iTotalPages?$("li:last",c[t]).addClass("disabled"):$("li:last",c[t]).removeClass("disabled")}}}}),$.extend(!0,$.fn.DataTable.TableTools.classes,{container:"DTTT ",buttons:{normal:"btn btn-white",disabled:"disabled"},collection:{container:"DTTT_dropdown dropdown-menu",buttons:{normal:"",disabled:"disabled"}},print:{info:"DTTT_print_info modal"},select:{row:"active"}}),$.extend(!0,$.fn.DataTable.TableTools.DEFAULTS.oTags,{collection:{container:"ul",button:"li",liner:"a"}}),$(document).ready(function(){function a(){$("#example3").dataTable().fnAddData([$("#val1 option:selected").text(),$("#val2 option:selected").text(),"Windows","789.","A"])}var e=void 0,t={tablet:1024,phone:480},o=$("#example");o.dataTable({sDom:"<'row'<'col-md-6'l T><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",oTableTools:{aButtons:[{sExtends:"collection",sButtonText:"<i class='fa fa-cloud-download'></i>",aButtons:["csv","xls","pdf","copy"]}]},sPaginationType:"bootstrap",aoColumnDefs:[{bSortable:!1,aTargets:[0]}],aaSorting:[[1,"asc"]],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"},bAutoWidth:!1,fnPreDrawCallback:function(){e||(e=new ResponsiveDatatablesHelper(o,t))},fnRowCallback:function(a){e.createExpandIcon(a)},fnDrawCallback:function(){e.respond()}}),$("#example_wrapper .dataTables_filter input").addClass("input-medium "),$("#example_wrapper .dataTables_length select").addClass("select2-wrapper span12"),$("#example input").click(function(){$(this).parent().parent().parent().toggleClass("row_selected")}),$("#quick-access .btn-cancel").click(function(){$("#quick-access").css("bottom","-115px")}),$("#quick-access .btn-add").click(function(){a(),$("#quick-access").css("bottom","-115px")});$("#id_user_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[5]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_project_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[5]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_role_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[2]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_department_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[2]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_client_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[3]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_contact_point_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[3]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_access_right_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[3]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#id_fc_table").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aoColumnDefs:[{bSortable:!1,aTargets:[4]}],aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#example2").dataTable({sDom:"<'row'<'col-md-6'l><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",aaSorting:[],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}}),$("#example3").dataTable({sDom:"<'row'<'col-md-6'l <'toolbar'>><'col-md-6'f>r>t<'row'<'col-md-12'p i>>",oTableTools:{aButtons:[{sExtends:"collection",sButtonText:"<i class='fa fa-cloud-download'></i>",aButtons:["csv","xls","pdf","copy"]}]},aoColumnDefs:[{bSortable:!1,aTargets:[0]}],aaSorting:[[3,"desc"]],oLanguage:{sLengthMenu:"_MENU_ ",sInfo:"Showing <b>_START_ to _END_</b> of _TOTAL_ entries"}});$("div.toolbar").html('<div class="table-tools-actions"><button class="btn btn-primary" style="margin-left:12px" id="test2">Add</button></div>'),$("#test2").on("click",function(){$("#quick-access").css("bottom","0px")}),$("#example2_wrapper .dataTables_filter input").addClass("input-medium "),$("#example2_wrapper .dataTables_length select").addClass("select2-wrapper span12"),$("#example3_wrapper .dataTables_filter input").addClass("input-medium "),$("#example3_wrapper .dataTables_length select").addClass("select2-wrapper span12"),$(".select2-wrapper").select2({minimumResultsForSearch:-1})});