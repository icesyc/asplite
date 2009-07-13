/* 
** Summary:	JS Form Validator 
** author:	ice_berg16(寻梦的稻草人)
** lastModified: 2006-9-19
** copyright (c)2007 ice_berg16@163.com
*/

var Validator = {
	init:		function(){
		var n = document.forms.length;
		var self = this;
		for(var i=0; i<n; i++)
		{
			if( document.forms[i].getAttribute("validate") == "true" )
			{	
				document.forms[i].onsubmit = function(){return self.validate(this);};
			}
		}
	},
	validate:	function( form ){
		var isValid = true;
		var n = form.elements.length;
		//判断是否已经滚动
		var scrolled = false;
		for( var i=0; i<n; i++ )
		{
			if( form.elements[i].getAttribute("rule") )	//需要验证
			{
				//获得函数句柄
				var f = this[form.elements[i].getAttribute("rule")];
				var v = form.elements[i].value;
				var msg = form.elements[i].getAttribute("tip");
				if( form.elements[i].getAttribute("element") )
				{
					var e = form.elements[i].getAttribute("element");
					var p = form.elements[e].value;
					var r = f.apply(this,[v,p]);
				}
				else if( form.elements[i].getAttribute("param") )
				{
					var p = form.elements[i].getAttribute("param");
					var r = f.apply(this,[v,p]);
				}
				else
					var r = f.apply(this,[v]);
				
				if( !r )
				{
					if(!form.elements[i].label)
					{
						var label = document.createElement("label");
						label.style.marginLeft = "10px";
						label.style.color      = "#F60";
						label.innerHTML = msg;
						form.elements[i].parentNode.insertBefore(label,form.elements[i].nextSibling);
						form.elements[i].label = label;
					}
					isValid = false;
					if(form.elements[i].getAttribute("scroll") == "yes" && !scrolled)
					{
						scrolled = true;
						form.elements[i].scrollIntoView();
					}
				}
				else
				{
					if(form.elements[i].label)
					{
						form.elements[i].parentNode.removeChild(form.elements[i].label);
						form.elements[i].label = null;
					}
				}
			}

		}
		return isValid;
	},
	//===== 表单检验规则 =======
	number:		function( str )	{return this.match( str, /^\d+(\.\d+)?$/ )},
	required:	function( str )	{return !str.replace(/^\s+|\s+$/,"") == ""},
	maxLength:	function( str, length ) {if(length==0)return true; return str.length <= length},
	email:		function( str )	{return this.match( str, /^[\w\.]+@\w+\.\w+$/ )},
	date:		function( str )	{return this.match( str, /^\d{4}-\d{2}-\d{2}$/ )},
	alphaNumber:function( str ) {return this.match( str, /^[a-zA-Z0-9]+$/ )},
	phone:		function( str ) {return this.match( str, /^\d+(\-\d+){0,2}$/ )},
	equal:		function( str, str2 ) {return str == str2},
	match:		function( str, re ) {return re.test(str)}
};

$(function(){Validator.init()});