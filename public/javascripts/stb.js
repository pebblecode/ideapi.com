(function(d){d.SmartTextBox={};var f=d.SmartTextBox;f.BaseClass=function(){};f.BaseClass.prototype.construct=function(){};f.BaseClass.extend=function(a){function b(){arguments[0]!==f.BaseClass&&this.construct.apply(this,arguments)}var c=new this(f.BaseClass);for(var e in a){var g=a[e];c[e]=g}b.prototype=c;b.extend=this.extend;return b};f.SmartTextBox=f.BaseClass.extend({_options:{autocomplete:true,minSearchLength:2,maxResults:10,caseSensitive:false,highlight:true,fullSearch:true,autocompleteValues:[],
autocompleteUrl:null,placeholder:"Please start typing to receive suggestions",onlyAutocomplete:false,uniqueValues:true,submitKeys:[13],submitChars:[";",","],separator:";",updateOriginal:true,onElementAdd:null,onElementRemove:null,onElementFocus:null,onElementBlur:null,hideEmptyInputs:true,editOnFocus:false,editOnDoubleClick:false,containerClass:"smartTextBox",debug:false},construct:function(a,b){this.options={};b=b||{};d.extend(this.options,this._options);d.extend(this.options,b);var c=this;this.original=
d(a);this.focused=false;this.elements=[];d(this.original).data("SmartTextBox",this);this.original.hide();this.container=d("<div></div>").addClass(this.options.containerClass).click(function(e){if((c.container.index(e.target)>-1||c.list.index(e.target)>-1)&&(!c.currentFocus||c.currentFocus!=c.elements[c.elements.length-1]))c.focusLast()}).insertAfter(this.original);this.list=d("<ul></ul>").addClass(this.options.containerClass+"-items").appendTo(this.container);d(document).keydown(function(e){c.onKeyDown(e)}).click(function(e){if(c.currentFocus){if(e.target.className.indexOf(c.options.containerClass)>
-1){if(c.container.index(e.target)>-1)return;e=d(e.target).parents("."+c.options.containerClass);if(e.index(c.container)>-1)return}c.blur()}});if(this.options.autocomplete)this.autocomplete=new f.AutoComplete(this,this.options);this.add("input");this.loadOriginal()},setValues:function(a){this.removeAll();var b=this;d.each(a,function(c,e){b.addBox(e)})},removeAll:function(){var a=[];d.each(this.elements,function(){this.is("box")&&a.push(this)});d.each(a,function(){this.remove()})},setAutocompleteValues:function(a){if(this.options.autocomplete)typeof a==
"string"?this.autocomplete.setValues(a.split(this.options.separator)):this.autocomplete.setValues(a)},onKeyDown:function(a){if(this.currentFocus){var b=this.currentFocus.is("input")?this.currentFocus.getCaret():null,c=this.currentFocus.getValue(),e=this.currentFocus.is("input")&&this.currentFocus.isSelected();this.currentFocus.valueContainer.focus();switch(a.keyCode){case 37:if(this.currentFocus.is("box")||(b==0||!c.length)&&!e){a.preventDefault();this.focusRelative("previous")}break;case 39:if(this.currentFocus.is("box")||
b==c.length&&!e){a.preventDefault();this.focusRelative("next")}break;case 8:if(this.currentFocus.is("box")){this.currentFocus.remove();a.preventDefault()}else if((b==0||!c.length)&&!e){this.focusRelative("previous");a.preventDefault()}break;case 27:this.blur();break}}},create:function(a,b,c){var e;if(a=="box")e=new f.BoxElement(b,this,c);else if(a=="input")e=new f.InputElement(b,this,c);return e},getElementIndex:function(a){return d(this.elements).index(a)},getElement:function(a){if(a<0||a>this.elements.length-
1)return null;return this.elements[a]},getElementsByType:function(a){var b=[];d.each(this.elements,function(){this.is(a)&&b.push(this)});return b},getLastBox:function(){for(var a=this.elements.length-1;a>-1;a--)if(this.elements[a].is("box"))return this.elements[a];return null},insertElement:function(a,b){var c=arguments.length>1?b:this.elements.length;this.elements.splice(c,0,a)},add:function(a,b,c,e){a=a||"box";b=b||"";e=e||"after";c=c||this.getLastBox();a=this.create(a,b);b=0;if(c)b=this.getElementIndex(c)+
(e=="after"?1:0);this.insertElement(a,b);c?a.inject(c,e):a.inject();return a},addBox:function(a,b,c){if(d.trim(a).length)return this.add("box",d.trim(a),b,c)},removeBox:function(a){var b=null;d.each(this.elements,function(){if(this.getValue()==a){b=this;return false}});if(!b&&!isNaN(a)){var c=this.getElementsByType("box");if(c.length>a)b=c[a]}b&&b.remove()},handleElementEvent:function(a,b,c){switch(a){case "add":this.onElementAdd(b,c);break;case "focus":this.onElementFocus(b,c);break;case "blur":this.onElementBlur(b,
c);break;case "remove":this.onElementRemove(b,c);break}},onElementAdd:function(a){this.autocomplete&&this.autocomplete.setupElement(a);if(a.is("box")){var b=this.getElementIndex(a);if((b=this.getElement(b-1))&&b.is("box")||!b){b=this.add("input","",a,"before");this.options.hideEmptyInputs&&b.hide()}this.options.updateOriginal&&this.updateOriginal();this.options.onElementAdd&&this.options.onElementAdd(a,this)}},onElementFocus:function(a){if(this.currentFocus!=a){this.currentFocus&&this.currentFocus.blur();
this.currentFocus=a;this.currentFocus.is("input")&&this.autocomplete&&this.autocomplete.search(this.currentFocus);this.options.onElementFocus&&this.options.onElementFocus(a,this)}},onElementBlur:function(a){if(this.currentFocus==a){this.currentFocus=null;this.autocomplete&&this.autocomplete.hide();this.options.onElementBlur&&this.options.onElementBlur(a,this)}},onElementRemove:function(a){var b=this.getElementIndex(a);this.focusRelative(b==this.elements.length-1?"previous":"next",a);this.elements.splice(b,
1);if(this.getElement(b)&&this.getElement(b).is("input"))if(this.getElement(b+1)&&this.getElement(b+1).is("input")||this.getElement(b-1)&&this.getElement(b-1).is("input"))this.getElement(b).remove();this.options.updateOriginal&&this.updateOriginal();this.elements.length==1&&this.elements[0].is("input")&&this.elements[0].show();this.options.onElementRemove&&this.options.onElementRemove(a,this)},blur:function(){d.each(this.elements,function(a,b){b.blur()})},focusLast:function(){this.elements[this.elements.length-
1].focus()},focusRelative:function(a,b){b=b||this.currentFocus;b=d(this.elements).index(b);b=a=="previous"?b-1:b+1;if(!(b<0))if(!(b>=this.elements.length)){this.elements[b].focus();if(this.elements[b].is("input"))a=="previous"?this.elements[b].setCaretToEnd():this.elements[b].setCaretToStart()}},getBoxValues:function(){var a=[];d.each(this.elements,function(){this.is("box")&&a.push(this.getValue())});return a},containsValue:function(a){return d(this.getBoxValues()).index(a)>-1},serialize:function(){return this.getBoxValues().join(this.options.separator)},
updateOriginal:function(){this.original.attr("value",this.serialize())},loadOriginal:function(){this.load(this.original.attr("value"))},load:function(a){if(typeof a=="string")a=a.split(this.options.separator);this.setValues(a)}});f.AutoComplete=f.BaseClass.extend({_options:{},construct:function(a,b){this.stb=a;this.currentValue="";this.options={};d.extend(this.options,this._options);d.extend(this.options,b||{});this.options.autocompleteUrl?this.ajaxLoad(this.options.autocompleteUrl):this.setValues(this.options.autocompleteValues);
this.baseClass=this.stb.options.containerClass+"-autocomplete";this.container=d("<div></div>").addClass(this.baseClass).css("width",this.stb.container.width()).appendTo(this.stb.container);this.placeHolder=d("<div></div>").addClass(this.baseClass+"-placeholder").html(this.options.placeholder).appendTo(this.container).hide();this.resultList=d("<div></div>").addClass(this.baseClass+"-results").appendTo(this.container).hide()},ajaxLoad:function(a){var b=this;d.get(a,{},function(c){c=c.values;b.setValues(c)},
"json")},setValues:function(a){this.values=a||[]},getValues:function(){return this.values||[]},setupElement:function(a){if(a.is("input")){var b=this;a.valueContainer.keydown(function(c){b.navigate(c)}).keyup(function(){b.search()})}},navigate:function(a){switch(a.keyCode){case 38:this.currentSelection&&this.currentSelection.prev().length?this.focusRelative("prev"):this.blur();break;case 40:this.currentSelection?this.focusRelative("next"):this.focusFirst();break;case 13:if(this.currentSelection){a.stopPropagation();
this.addCurrent();this.currentElem.focus();this.search()}break}},search:function(a){if(a)this.currentElem=a;if(this.getValues().length){window.clearTimeout(this.hidetimer);a=this.currentElem.getValue();a.length<this.options.minSearchLength&&this.showPlaceHolder();if(a!=this.currentValue){this.currentValue=a;this.hideResultList();a.length<this.options.minSearchLength||this.showResults(a)}}},showPlaceHolder:function(){this.placeHolder&&this.placeHolder.show()},hidePlaceHolder:function(){this.placeHolder&&
this.placeHolder.hide()},showResultList:function(){this.resultList.show()},hideResultList:function(){this.resultList.hide()},hide:function(){var a=this;this.hidetimer=window.setTimeout(function(){a.hidePlaceHolder();a.hideResultList();a.currentValue=""},150)},showResults:function(a){var b=this.searchResults(a);this.hidePlaceHolder();if(b.length){this.blur();this.resultList.empty().show();var c=this;b.sort();d.each(b,function(e,g){c.addResult(g,a)});this.results=b}},searchResults:function(a){var b=
[];a=new RegExp((this.options.fullSearch?"":"\\b")+a,this.caseSensitive?"":"i");for(var c=this.getValues(),e=0;e<c.length;e++)if(!(this.stb.options.uniqueValues&&this.stb.containsValue(c[e]))){a.test(c[e])&&b.push(c[e]);if(b.length>=this.options.maxResults)break}return b},addResult:function(a,b){var c=this,e=d("<div></div>").addClass(this.baseClass+"-result").appendTo(this.resultList).mouseenter(function(){c.focus(this)}).mousedown(function(g){g.stopPropagation();window.clearTimeout(c.hidetimer);
c.doAdd=true}).mouseup(function(){if(c.doAdd){c.addCurrent();c.currentElem.focus();c.search();c.doAdd=false}});d("<span>").addClass(c.baseClass+"-value").html(a).css("display","none").appendTo(e);d("<span>").addClass(c.baseClass+"-display").html(c.formatResult(a,b)).appendTo(e)},formatResult:function(a,b){if(this.options.highlight){var c=a.toLowerCase(),e=b.toLowerCase();c=c.indexOf(e);return a="<span>"+a.substring(0,c)+"</span><span class='"+this.baseClass+"-highligh'>"+a.substring(c,c+b.length)+
"</span><span>"+a.substring(c+b.length)+"</span>"}else return a},addCurrent:function(){var a=d("."+this.baseClass+"-value",this.currentSelection).html();this.currentElem.setValue(a);this.currentElem.saveAsBox();this.currentSelection=null},focus:function(a){this.blur();this.currentSelection=d(a).addClass(this.baseClass+"-result-focus")},focusFirst:function(){this.focus(this.resultList.children(":first"))},focusRelative:function(a){a=="next"?this.focus(this.currentSelection.next().length?this.currentSelection.next():
this.currentSelection):this.focus(this.currentSelection.prev().length?this.currentSelection.prev():this.currentSelection)},blur:function(){if(this.currentSelection){this.currentSelection.removeClass(this.baseClass+"-result-focus");this.currentSelection=null}}});f.GrowingInput=f.BaseClass.extend({options:{min:0,max:null,startWidth:2,correction:10},construct:function(a,b){b=b||{};d.extend(this.options,b);var c=this;this.element=d(a);this.calc=d("<span></span>").css({"float":"left",display:"inline-block",
position:"absolute",left:-1000}).insertAfter(this.element);this.requiredStyles=["font-size","font-family","padding-left","padding-top","padding-bottom","padding-right","border-left","border-right","border-top","border-bottom","word-spacing","letter-spacing","text-indent","text-transform"];this.copyCat();this.resize();function e(){c.resize()}this.element.click(e).blur(e).keyup(e).keydown(e).keypress(e)},copyCat:function(){var a=this;d.each(this.requiredStyles,function(b,c){a.calc.css(c,a.element.css(c))})},
calculate:function(a){this.calc.html(a);a=this.calc.width();return(a?a:this.options.startWidth)+this.options.correction},resize:function(){this.lastvalue=this.value;var a=this.value=this.element.attr("value");if((this.options.min||this.options.min==0)&&this.value.length<this.options.min){if((this.lastvalue||this.lastvalue==0)&&this.lastvalue.length<=this.options.min)return;for(var b=0;b<this.options.min;b++)a+="-"}if((this.options.max||this.options.max==0)&&this.value.length>this.options.max){if((this.lastvalue||
this.lastvalue==0)&&this.lastvalue.length>=this.options.max)return;a=this.value.substr(0,this.options.max)}a=this.calculate(a);this.element.width(a);return this}});f.BaseElement=f.BaseClass.extend({type:"base",options:{},construct:function(a,b,c){c=c||{};d.extend(this.options,c);this.value=a;this.stb=b;this.className=this.stb.options.containerClass+"-elem";this.elemClassName=this.stb.options.containerClass+"-"+this.type+"-elem";this.focused=false;this.init()},init:function(){this.constructElement()},
constructElement:function(){this.el=null},is:function(a){return this.type==a},inject:function(a,b){if(a)b=="before"?this.getElement().insertBefore(a.getElement()):this.getElement().insertAfter(a.getElement());else this.getElement().prependTo(this.stb.list);this.notifyEvent("add")},remove:function(a){this.blur();this.el.remove();this.onRemove();(a=typeof a=="undefined"?true:a)&&this.notifyEvent("remove")},focus:function(a){if(this.focused)return this;this.show();this.el.addClass(this.className+"-focus").addClass(this.className+
"-"+this.type+"-focus");this.focused=true;(a=typeof a=="undefined"?true:a)&&this.notifyEvent("focus");this.onFocus();return this},blur:function(a){if(!this.focused)return this;this.el.removeClass(this.className+"-focus").removeClass(this.className+"-"+this.type+"-focus");this.focused=false;(a=typeof a=="undefined"?true:a)&&this.notifyEvent("blur");this.onBlur();return this},onMouseIn:function(){this.el.addClass(this.className+"-hover").addClass(this.className+"-"+this.type+"-hover")},onMouseOut:function(){this.el.removeClass(this.className+
"-hover").removeClass(this.className+"-"+this.type+"-hover")},onFocus:function(){},onBlur:function(){},onRemove:function(){},show:function(a){this.el.show();(a=typeof a=="undefined"?true:a)&&this.notifyEvent("show");return this},hide:function(a){this.el.hide();(a=typeof a=="undefined"?true:a)&&this.notifyEvent("hide");return this},setValue:function(a,b){this.value=a;this.valueContainer.text(a);(a=typeof b=="undefined"?true:b)&&this.notifyEvent("setValue");return this},getValue:function(){return this.value},
getElement:function(){return this.el},notifyEvent:function(a){this.stb.handleElementEvent(a,this);return this},toString:function(){return"[BoxElement type='"+this.type+"' value='"+this.getValue()+"']"}});f.BoxElement=f.BaseElement.extend({type:"box",constructElement:function(){var a=this;this.el=d("<li></li>").addClass(this.className).addClass(this.elemClassName).hover(function(){a.onMouseIn()},function(){a.onMouseOut()}).mousedown(function(){a.focus()});this.stb.options.editOnDoubleClick&&this.el.dblclick(function(b){b.preventDefault();
a.toInput()});this.valueContainer=d("<span></span>").addClass(this.className+"-valueContainer").appendTo(this.el);this.removeButton=d("<a></a>").addClass(this.className+"-deleteButton").attr("href","javascript:;").click(function(b){a.remove();b.stopPropagation()}).appendTo(this.el);this.setValue(this.value)},onFocus:function(){var a=this;this.stb.options.editOnFocus&&window.setTimeout(function(){a.toInput()},50)},onBlur:function(){},toInput:function(){var a=this.getValue(),b=this.stb.getElementIndex(this);
this.remove();b=this.stb.getElement(b-1);if(b.is("input")&&!d.trim(b.getValue()).length){b.setValue(a);b.valueContainer.focus();b.setCaretToEnd()}}});f.InputElement=f.BaseElement.extend({type:"input",constructElement:function(){var a=this;this.el=d("<li></li>").addClass(this.className).addClass(this.elemClassName).hover(function(){a.onMouseIn()},function(){a.onMouseOut()}).click(function(){a.focus()});this.valueContainer=d("<input />").addClass(this.elemClassName+"-valueInput").focus(function(b){b.stopPropagation();
a.focus()}).blur(function(){a.blur()}).appendTo(this.el);this.growingInput=new f.GrowingInput(this.valueContainer);d(document).keydown(function(b){a.onKeyDown(b)});d(document).keypress(function(b){a.onKeyPress(b)});this.setValue(this.value)},getValue:function(){return this.valueContainer.attr("value")},setValue:function(a){this.value=a;this.valueContainer.attr("value",a);this.growingInput.resize();this.notifyEvent("setValue");return this},getCaret:function(){var a=this.valueContainer[0];if(a.createTextRange){var b=
document.selection.createRange().duplicate();b.moveEnd("character",a.value.length);if(b.text==="")return a.value.length;return a.value.lastIndexOf(b.text)}else return a.selectionStart},getCaretEnd:function(){var a=this.valueContainer[0];if(a.createTextRange){var b=document.selection.createRange().duplicate();b.moveStart("character",-a.value.length);return b.text.length}else return a.selectionEnd},setCaret:function(a){var b=this.valueContainer[0];if(b.createTextRange){b.focus();var c=document.selection.createRange();
c.moveStart("character",-b.value.length);c.moveStart("character",a);c.moveEnd("character",0);c.select()}else{b.selectionStart=a;b.selectionEnd=a}},setCaretToStart:function(){this.setCaret(0)},setCaretToEnd:function(){this.setCaret(this.valueContainer.attr("value").length||0)},isSelected:function(){return this.focused&&this.getCaret()!==this.getCaretEnd()},saveAsBox:function(){var a=this.getValue();if(a){this.stb.add("box",d.trim(a),this,"before");this.setValue("")}},onKeyDown:function(a){if(this.focused)if(d.inArray(a.keyCode,
this.stb.options.submitKeys)>-1&&!this.stb.options.onlyAutocomplete&&!(this.stb.options.uniqueValues&&this.stb.containsValue(this.getValue()))){a.preventDefault();this.saveAsBox()}},onKeyPress:function(a){if(this.focused)if(d.inArray(String.fromCharCode(a.charCode||a.keyCode||0),this.stb.options.submitChars)>-1&&!this.stb.options.onlyAutocomplete&&!(this.stb.options.uniqueValues&&this.stb.containsValue(this.getValue()))){a.preventDefault();this.saveAsBox()}},onFocus:function(){this.show();this.valueContainer.focus();
this.growingInput.resize()},onBlur:function(){this.valueContainer.blur();this.stb.options.hideEmptyInputs&&this.el.next().length&&!this.getValue()&&this.hide();this.stb.options.editOnFocus&&this.saveAsBox()}});d.fn.extend({smartTextBox:function(a,b){return this.each(function(){var c=d(this).data("SmartTextBox");if(c)switch(a){case "add":c.addBox(b);break;case "remove":c.removeBox(b);break;case "load":c.load(b);break;case "clear":c.removeAll();break;case "autocomplete":c.setAutocompleteValues(b);break}else new d.SmartTextBox.SmartTextBox(this,
a)})}})})(jQuery);