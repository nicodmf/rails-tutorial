(function($, undefined) {
	$(document).ready(function(){
		console.log("init micromessage length")
		var counter_first = 0;
		function update_characters_count(){
			console.log("update micromessage length")
			message_box = $("#micropost_content")
			length = message_box.val().length;
			count_box = message_box.parent().find(".counter");
			if(length>140 || (length<1 && counter_first>3)){
				count_box.addClass("length_error");
			}else{
				count_box.removeClass("length_error");
			}
			plurial=length>1?"s":"";
			count_box.html("<span class=\"counter\">" + length +"</span>"+ " character" + plurial)
			counter_first++; 
			
		}
		$("#micropost_content").val("");
		update_characters_count();
		message_box.keyup(function(){update_characters_count();})
		//message_box.keypress(function(){update_characters_count();})
		message_box.keydown(function(){update_characters_count();})
		
	})
})( jQuery );