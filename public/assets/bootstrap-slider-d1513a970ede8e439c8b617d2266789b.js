!function(t){var i=function(i,e){this.element=t(i),this.picker=t('<div class="slider"><div class="slider-track"><div class="slider-selection"></div><div class="slider-handle"></div><div class="slider-handle"></div></div><div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div></div>').insertBefore(this.element).append(this.element),this.id=this.element.data("slider-id")||e.id,this.id&&(this.picker[0].id=this.id),"undefined"!=typeof Modernizr&&Modernizr.touch&&(this.touchCapable=!0);var s=this.element.data("slider-tooltip")||e.tooltip;switch(this.tooltip=this.picker.find(".tooltip"),this.tooltipInner=this.tooltip.find("div.tooltip-inner"),this.orientation=this.element.data("slider-orientation")||e.orientation,this.orientation){case"vertical":this.picker.addClass("slider-vertical"),this.stylePos="top",this.mousePos="pageY",this.sizePos="offsetHeight",this.tooltip.addClass("right")[0].style.left="100%";break;default:this.picker.addClass("slider-horizontal").css("width",this.element.outerWidth()),this.orientation="horizontal",this.stylePos="left",this.mousePos="pageX",this.sizePos="offsetWidth",this.tooltip.addClass("top")[0].style.top=-this.tooltip.outerHeight()-14+"px"}this.min=this.element.data("slider-min")||e.min,this.max=this.element.data("slider-max")||e.max,this.step=this.element.data("slider-step")||e.step,this.value=this.element.data("slider-value")||e.value,this.value[1]&&(this.range=!0),this.selection=this.element.data("slider-selection")||e.selection,this.selectionEl=this.picker.find(".slider-selection"),"none"===this.selection&&this.selectionEl.addClass("hide"),this.selectionElStyle=this.selectionEl[0].style,this.handle1=this.picker.find(".slider-handle:first"),this.handle1Stype=this.handle1[0].style,this.handle2=this.picker.find(".slider-handle:last"),this.handle2Stype=this.handle2[0].style;var h=this.element.data("slider-handle")||e.handle;switch(h){case"round":this.handle1.addClass("round"),this.handle2.addClass("round");break;case"triangle":this.handle1.addClass("triangle"),this.handle2.addClass("triangle")}this.range?(this.value[0]=Math.max(this.min,Math.min(this.max,this.value[0])),this.value[1]=Math.max(this.min,Math.min(this.max,this.value[1]))):(this.value=[Math.max(this.min,Math.min(this.max,this.value))],this.handle2.addClass("hide"),this.value[1]="after"==this.selection?this.max:this.min),this.diff=this.max-this.min,this.percentage=[100*(this.value[0]-this.min)/this.diff,100*(this.value[1]-this.min)/this.diff,100*this.step/this.diff],this.offset=this.picker.offset(),this.size=this.picker[0][this.sizePos],this.formater=e.formater,this.layout(),this.picker.on(this.touchCapable?{touchstart:t.proxy(this.mousedown,this)}:{mousedown:t.proxy(this.mousedown,this)}),"show"===s?this.picker.on({mouseenter:t.proxy(this.showTooltip,this),mouseleave:t.proxy(this.hideTooltip,this)}):this.tooltip.addClass("hide")};i.prototype={constructor:i,over:!1,inDrag:!1,showTooltip:function(){this.tooltip.addClass("in"),this.over=!0},hideTooltip:function(){this.inDrag===!1&&this.tooltip.removeClass("in"),this.over=!1},layout:function(){this.handle1Stype[this.stylePos]=this.percentage[0]+"%",this.handle2Stype[this.stylePos]=this.percentage[1]+"%","vertical"==this.orientation?(this.selectionElStyle.top=Math.min(this.percentage[0],this.percentage[1])+"%",this.selectionElStyle.height=Math.abs(this.percentage[0]-this.percentage[1])+"%"):(this.selectionElStyle.left=Math.min(this.percentage[0],this.percentage[1])+"%",this.selectionElStyle.width=Math.abs(this.percentage[0]-this.percentage[1])+"%"),this.range?(this.tooltipInner.text(this.formater(this.value[0])+" : "+this.formater(this.value[1])),this.tooltip[0].style[this.stylePos]=this.size*(this.percentage[0]+(this.percentage[1]-this.percentage[0])/2)/100-("vertical"===this.orientation?this.tooltip.outerHeight()/2:this.tooltip.outerWidth()/2)+"px"):(this.tooltipInner.text(this.formater(this.value[0])),this.tooltip[0].style[this.stylePos]=this.size*this.percentage[0]/100-("vertical"===this.orientation?this.tooltip.outerHeight()/2:this.tooltip.outerWidth()/2)+"px")},mousedown:function(i){this.touchCapable&&"touchstart"===i.type&&(i=i.originalEvent),this.offset=this.picker.offset(),this.size=this.picker[0][this.sizePos];var e=this.getPercentage(i);if(this.range){var s=Math.abs(this.percentage[0]-e),h=Math.abs(this.percentage[1]-e);this.dragged=h>s?0:1}else this.dragged=0;this.percentage[this.dragged]=e,this.layout(),t(document).on(this.touchCapable?{touchmove:t.proxy(this.mousemove,this),touchend:t.proxy(this.mouseup,this)}:{mousemove:t.proxy(this.mousemove,this),mouseup:t.proxy(this.mouseup,this)}),this.inDrag=!0;var a=this.calculateValue();return this.element.trigger({type:"slideStart",value:a}).trigger({type:"slide",value:a}),!1},mousemove:function(t){this.touchCapable&&"touchmove"===t.type&&(t=t.originalEvent);var i=this.getPercentage(t);this.range&&(0===this.dragged&&this.percentage[1]<i?(this.percentage[0]=this.percentage[1],this.dragged=1):1===this.dragged&&this.percentage[0]>i&&(this.percentage[1]=this.percentage[0],this.dragged=0)),this.percentage[this.dragged]=i,this.layout();var e=this.calculateValue();return this.element.trigger({type:"slide",value:e}).data("value",e).prop("value",e),!1},mouseup:function(){t(document).off(this.touchCapable?{touchmove:this.mousemove,touchend:this.mouseup}:{mousemove:this.mousemove,mouseup:this.mouseup}),this.inDrag=!1,0==this.over&&this.hideTooltip(),this.element;var i=this.calculateValue();return this.element.trigger({type:"slideStop",value:i}).data("value",i).prop("value",i),!1},calculateValue:function(){var i;return this.range?(i=[this.min+Math.round(this.diff*this.percentage[0]/100/this.step)*this.step,this.min+Math.round(this.diff*this.percentage[1]/100/this.step)*this.step],this.value=i):(i=this.min+Math.round(this.diff*this.percentage[0]/100/this.step)*this.step,this.value=[i,this.value[1]]),t("#slider_value").val(i),i},getPercentage:function(t){this.touchCapable&&(t=t.touches[0]);var i=100*(t[this.mousePos]-this.offset[this.stylePos])/this.size;return i=Math.round(i/this.percentage[2])*this.percentage[2],Math.max(0,Math.min(100,i))},getValue:function(){return this.range?this.value:this.value[0]},setValue:function(t){this.value=t,this.range?(this.value[0]=Math.max(this.min,Math.min(this.max,this.value[0])),this.value[1]=Math.max(this.min,Math.min(this.max,this.value[1]))):(this.value=[Math.max(this.min,Math.min(this.max,this.value))],this.handle2.addClass("hide"),this.value[1]="after"==this.selection?this.max:this.min),this.diff=this.max-this.min,this.percentage=[100*(this.value[0]-this.min)/this.diff,100*(this.value[1]-this.min)/this.diff,100*this.step/this.diff],this.layout()}},t.fn.slider=function(e,s){return this.each(function(){var h=t(this),a=h.data("slider"),o="object"==typeof e&&e;a||h.data("slider",a=new i(this,t.extend({},t.fn.slider.defaults,o))),"string"==typeof e&&a[e](s)})},t.fn.slider.defaults={min:0,max:10,step:1,orientation:"horizontal",value:5,selection:"before",tooltip:"show",handle:"round",formater:function(t){return t}},t.fn.slider.Constructor=i}(window.jQuery);