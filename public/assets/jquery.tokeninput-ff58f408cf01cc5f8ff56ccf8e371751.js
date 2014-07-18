!function(e){var t={method:"GET",contentType:"json",queryParam:"q",searchDelay:300,minChars:1,propertyToSearch:"name",profilePic:"profile",jsonContainer:null,hintText:"Type in a search term",noResultsText:"No results",searchingText:"Searching...",deleteText:"&times;",animateDropdown:!0,tokenLimit:null,tokenDelimiter:",",preventDuplicates:!1,tokenValue:"id",prePopulate:null,processPrePopulate:!1,idPrefix:"token-input-",resultsFormatter:function(e){return"<li><img src='small-profile-pic.png'>"+e[this.propertyToSearch]+"</li>"},tokenFormatter:function(e){return"<li><p><img src='small-profile-pic.png'>"+e[this.propertyToSearch]+"</p></li>"},onResult:null,onAdd:null,onDelete:null,onReady:null},n={tokenList:"token-input-list",token:"token-input-token",tokenDelete:"token-input-delete-token",selectedToken:"token-input-selected-token",highlightedToken:"token-input-highlighted-token",dropdown:"token-input-dropdown",dropdownItem:"token-input-dropdown-item",dropdownItem2:"token-input-dropdown-item2",selectedDropdownItem:"token-input-selected-dropdown-item",inputToken:"token-input-input-token"},o={BEFORE:0,AFTER:1,END:2},i={BACKSPACE:8,TAB:9,ENTER:13,ESCAPE:27,SPACE:32,PAGE_UP:33,PAGE_DOWN:34,END:35,HOME:36,LEFT:37,UP:38,RIGHT:39,DOWN:40,NUMPAD_ENTER:108,COMMA:188},a={init:function(n,o){var i=e.extend({},t,o||{});return this.each(function(){e(this).data("tokenInputObject",new e.TokenList(this,n,i))})},clear:function(){return this.data("tokenInputObject").clear(),this},add:function(e){return this.data("tokenInputObject").add(e),this},remove:function(e){return this.data("tokenInputObject").remove(e),this},get:function(){return this.data("tokenInputObject").getTokens()}};e.fn.tokenInput=function(e){return a[e]?a[e].apply(this,Array.prototype.slice.call(arguments,1)):a.init.apply(this,arguments)},e.TokenList=function(t,a,s){function l(){return null!==s.tokenLimit&&O>=s.tokenLimit?(I.hide(),g(),void 0):void 0}function r(){if(F!==(F=I.val())){var e=F.replace(/&/g,"&amp;").replace(/\s/g," ").replace(/</g,"&lt;").replace(/>/g,"&gt;");W.html(e),I.width(W.width()+30)}}function c(t){var n=s.tokenFormatter(t);n=e(n).addClass(s.classes.token).insertBefore(M),e("<span>"+s.deleteText+"</span>").addClass(s.classes.tokenDelete).appendTo(n).click(function(){return f(e(this).parent()),N.change(),!1});var o={id:t.id};return o[s.propertyToSearch]=t[s.propertyToSearch],e.data(n.get(0),"tokeninput",t),b=b.slice(0,B).concat([o]).concat(b.slice(B)),B++,k(b,N),O+=1,null!==s.tokenLimit&&O>=s.tokenLimit&&(I.hide(),g()),n}function u(t){var n=s.onAdd;if(O>0&&s.preventDuplicates){var o=null;if(G.children().each(function(){var n=e(this),i=e.data(n.get(0),"tokeninput");return i&&i.id===t.id?(o=n,!1):void 0}),o)return d(o),M.insertAfter(o),I.focus(),void 0}(null==s.tokenLimit||O<s.tokenLimit)&&(c(t),l()),I.val(""),g(),e.isFunction(n)&&n.call(N,t)}function d(e){e.addClass(s.classes.selectedToken),j=e.get(0),I.val(""),g()}function p(e,t){e.removeClass(s.classes.selectedToken),j=null,t===o.BEFORE?(M.insertBefore(e),B--):t===o.AFTER?(M.insertAfter(e),B++):(M.appendTo(G),B=O),I.focus()}function h(t){var n=j;j&&p(e(j),o.END),n===t.get(0)?p(t,o.END):d(t)}function f(t){var n=e.data(t.get(0),"tokeninput"),o=s.onDelete,i=t.prevAll().length;i>B&&i--,t.remove(),j=null,I.focus(),b=b.slice(0,i).concat(b.slice(i+1)),B>i&&B--,k(b,N),O-=1,null!==s.tokenLimit&&I.show().val("").focus(),e.isFunction(o)&&o.call(N,n)}function k(t,n){var o=e.map(t,function(e){return e[s.tokenValue]});n.val(o.join(s.tokenDelimiter))}function g(){U.hide().empty(),_=null}function m(){U.css({position:"absolute",top:e(G).offset().top+e(G).outerHeight(),left:e(G).offset().left,zindex:999}).show()}function v(){s.searchingText&&(U.html("<p>"+s.searchingText+"</p>"),m())}function T(){s.hintText&&(U.html("<p>"+s.hintText+"</p>"),m())}function y(e,t){return e.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)("+t+")(?![^<>]*>)(?![^&;]+;)","gi"),"<b>$1</b>")}function C(e,t,n){return e.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)("+t+")(?![^<>]*>)(?![^&;]+;)","g"),y(t,n))}function E(t,n){if(n&&n.length){U.empty();var o=e("<ul>").appendTo(U).mouseover(function(t){w(e(t.target).closest("li"))}).mousedown(function(t){return u(e(t.target).closest("li").data("tokeninput")),N.change(),!1}).hide();e.each(n,function(n,i){var a=s.resultsFormatter(i);a=C(a,i[s.propertyToSearch],t),a=e(a).appendTo(o),n%2?a.addClass(s.classes.dropdownItem):a.addClass(s.classes.dropdownItem2),0===n&&w(a),e.data(a.get(0),"tokeninput",i)}),m(),s.animateDropdown?o.slideDown("fast"):o.show()}else s.noResultsText&&(U.html("<p>"+s.noResultsText+"</p>"),m())}function w(t){t&&(_&&D(e(_)),t.addClass(s.classes.selectedDropdownItem),_=t.get(0))}function D(e){e.removeClass(s.classes.selectedDropdownItem),_=null}function R(){var t=I.val().toLowerCase();t&&t.length&&(j&&p(e(j),o.AFTER),t.length>=s.minChars?(v(),clearTimeout(L),L=setTimeout(function(){x(t)},s.searchDelay)):g())}function x(t){var n=t+A(),o=S.get(n);if(o)E(t,o);else if(s.url){var i=A(),a={};if(a.data={},i.indexOf("?")>-1){var l=i.split("?");a.url=l[0];var r=l[1].split("&");e.each(r,function(e,t){var n=t.split("=");a.data[n[0]]=n[1]})}else a.url=i;a.data[s.queryParam]=t,a.type=s.method,a.dataType=s.contentType,s.crossDomain&&(a.dataType="jsonp"),a.success=function(o){e.isFunction(s.onResult)&&(o=s.onResult.call(N,o)),S.add(n,s.jsonContainer?o[s.jsonContainer]:o),I.val().toLowerCase()===t&&E(t,s.jsonContainer?o[s.jsonContainer]:o)},e.ajax(a)}else if(s.local_data){var c=e.grep(s.local_data,function(e){return e[s.propertyToSearch].toLowerCase().indexOf(t.toLowerCase())>-1});e.isFunction(s.onResult)&&(c=s.onResult.call(N,c)),S.add(n,c),E(t,c)}}function A(){var e=s.url;return"function"==typeof s.url&&(e=s.url.call()),e}if("string"===e.type(a)||"function"===e.type(a)){s.url=a;var P=A();void 0===s.crossDomain&&(s.crossDomain=-1===P.indexOf("://")?!1:location.href.split(/\/+/g)[1]!==P.split(/\/+/g)[1])}else"object"==typeof a&&(s.local_data=a);s.classes?s.classes=e.extend({},n,s.classes):s.theme?(s.classes={},e.each(n,function(e,t){s.classes[e]=t+"-"+s.theme})):s.classes=n;var L,F,b=[],O=0,S=new e.TokenList.Cache,I=e('<input type="text"  autocomplete="off">').css({outline:"none"}).attr("id",s.idPrefix+t.id).focus(function(){(null===s.tokenLimit||s.tokenLimit!==O)&&T()}).blur(function(){g(),e(this).val("")}).bind("keyup keydown blur update",r).keydown(function(t){var n,a;switch(t.keyCode){case i.LEFT:case i.RIGHT:case i.UP:case i.DOWN:if(e(this).val()){var s=null;return s=t.keyCode===i.DOWN||t.keyCode===i.RIGHT?e(_).next():e(_).prev(),s.length&&w(s),!1}n=M.prev(),a=M.next(),n.length&&n.get(0)===j||a.length&&a.get(0)===j?t.keyCode===i.LEFT||t.keyCode===i.UP?p(e(j),o.BEFORE):p(e(j),o.AFTER):t.keyCode!==i.LEFT&&t.keyCode!==i.UP||!n.length?t.keyCode!==i.RIGHT&&t.keyCode!==i.DOWN||!a.length||d(e(a.get(0))):d(e(n.get(0)));break;case i.BACKSPACE:if(n=M.prev(),!e(this).val().length)return j?(f(e(j)),N.change()):n.length&&d(e(n.get(0))),!1;1===e(this).val().length?g():setTimeout(function(){R()},5);break;case i.TAB:case i.ENTER:case i.NUMPAD_ENTER:case i.COMMA:if(_)return u(e(_).data("tokeninput")),N.change(),!1;break;case i.ESCAPE:return g(),!0;default:String.fromCharCode(t.which)&&setTimeout(function(){R()},5)}}),N=e(t).hide().val("").focus(function(){I.focus()}).blur(function(){I.blur()}),j=null,B=0,_=null,G=e("<ul />").addClass(s.classes.tokenList).click(function(t){var n=e(t.target).closest("li");n&&n.get(0)&&e.data(n.get(0),"tokeninput")?h(n):(j&&p(e(j),o.END),I.focus())}).mouseover(function(t){var n=e(t.target).closest("li");n&&j!==this&&n.addClass(s.classes.highlightedToken)}).mouseout(function(t){var n=e(t.target).closest("li");n&&j!==this&&n.removeClass(s.classes.highlightedToken)}).insertBefore(N),M=e("<li />").addClass(s.classes.inputToken).appendTo(G).append(I),U=e("<div>").addClass(s.classes.dropdown).appendTo("body").hide(),W=e("<tester/>").insertAfter(I).css({position:"absolute",top:-9999,left:-9999,width:"auto",fontSize:I.css("fontSize"),fontFamily:I.css("fontFamily"),fontWeight:I.css("fontWeight"),letterSpacing:I.css("letterSpacing"),whiteSpace:"nowrap"});N.val("");var H=s.prePopulate||N.data("pre");s.processPrePopulate&&e.isFunction(s.onResult)&&(H=s.onResult.call(N,H)),H&&H.length&&e.each(H,function(e,t){c(t),l()}),e.isFunction(s.onReady)&&s.onReady.call(),this.clear=function(){G.children("li").each(function(){0===e(this).children("input").length&&f(e(this))})},this.add=function(e){u(e)},this.remove=function(t){G.children("li").each(function(){if(0===e(this).children("input").length){var n=e(this).data("tokeninput"),o=!0;for(var i in t)if(t[i]!==n[i]){o=!1;break}o&&f(e(this))}})},this.getTokens=function(){return b}},e.TokenList.Cache=function(t){var n=e.extend({max_size:500},t),o={},i=0,a=function(){o={},i=0};this.add=function(e,t){i>n.max_size&&a(),o[e]||(i+=1),o[e]=t},this.get=function(e){return o[e]}}}(jQuery);