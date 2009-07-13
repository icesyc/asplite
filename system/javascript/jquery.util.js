//设置元素居中
jQuery.fn.center = function(offx, offy){
	return this.each(function(){
		var de = top.document.documentElement;
		var w = top.innerWidth || self.innerWidth || (de&&de.clientWidth) || top.document.body.clientWidth;
		var h = top.innerHeight || self.innerHeight || (de&&de.clientHeight) || top.document.body.clientHeight;
		var x = top.pageXOffset || de.scrollLeft || top.document.body.scrollLeft;
		var y = top.pageYOffset || de.scrollTop || top.document.body.scrollTop;
		l = x + (w - $(this).width()) / 2;
		t = y + (h - $(this).height()) / 2;
		offx = offx || 0;
		offy = offy || 0;
		$(this).css({"position":"absolute", "left":l+offx, "top":t+offy});
	});
}

//复选框的全选
jQuery.fn.checkAll = function(bool){
	return this.each(function(){
		if(this.type == "checkbox")
			this.checked = bool;
	});
}

//设置单选框的默认值
jQuery.fn.check = function(v){
	return this.each(function(){
		if(this.type == 'radio' && this.value == v)
		{
			this.checked = true;
			return false;
		}
	});
}

//将元素启用拖拽
jQuery.fn.drag = function(expr){
	var target = $(expr);
	return this.each(function(){
		var f = function(event){
			event = window.event || event;
			var left = (parseInt(target.attr("x")) + event.clientX - parseInt(target.attr("offx"))) + "px";
			var top  = (parseInt(target.attr("y")) + event.clientY - parseInt(target.attr("offy"))) + "px";			
			target.css({"left":left, "top":top});
		};
		$(this).mousedown(function(event){
			event = window.event || event;
			target.css("position", "absolute");
			target.attr("offx", event.clientX);
			target.attr("offy", event.clientY);
			target.attr("x", parseInt(target.css("left")));
			target.attr("y", parseInt(target.css("top")));
			if($.browser.msie){
				this.onmousemove = f;
				this.setCapture();
			}
			else if($.browser.mozilla) document.addEventListener("mousemove", f, true);
		});
		$(this).mouseup(function(e){
			if($.browser.msie){
				this.onmousemove = null;
				this.releaseCapture();
			}else if($.browser.mozilla){
				document.removeEventListener("mousemove", f, true);
			}
		});
	});
}

