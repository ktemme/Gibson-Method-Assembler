$(document).ready(function() {
   	$(".prefix > .control").bind("click", function(){
		if ($(this).text() == '+Prefix') {
			$(this).text('-Prefix');
		}
		else if ($(this).text() == '-Prefix') {
			$(this).text('+Prefix');
		}
		var div = $(this).parent();		
		div.find('.data').toggle();
	});
});


$(document).ready(function() {
   	$(".suffix > .control").bind("click", function(){
		if ($(this).text() == '+Suffix') {
			$(this).text('-Suffix');
		}
		else if ($(this).text() == '-Suffix') {
			$(this).text('+Suffix');
		}
		var div = $(this).parent();		
		div.find('.data').toggle();
	});
});

