$(document).ready(function() {
	enablePrefixClick('');
	enableSuffixClick('');
	enableSortable();
});

function enableSortable() {
	$("#parts").sortable({
		cursor: 'move',
		handle: '.handle',
		cancel: '.delete'
	});
	$("#submit").bind("click",function() {    
      $('#partsOrder').val($('#parts').sortable('serialize'));  
    });
};

function enablePrefixClick(limits) {
	$(limits + ".prefix > .control").bind("click", function(){
		if ($(this).text() == '+Prefix') {
			$(this).text('-Prefix');
		}
		else if ($(this).text() == '-Prefix') {
			$(this).text('+Prefix');
		}
		var div = $(this).parent();		
		div.find('.data').toggle();
	});
};

function enableSuffixClick(limits){
	$(limits + ".suffix > .control").bind("click", function(){
		if ($(this).text() == '+Suffix') {
			$(this).text('-Suffix');
		}
		else if ($(this).text() == '-Suffix') {
			$(this).text('+Suffix');
		}
		var div = $(this).parent();		
		div.find('.data').toggle();
	});
};

function addFormField() {
	var id = document.getElementById("partsCount").value;
	$("#parts").append(
			"<div id='parts_"+id+"' class='part'> \
				<div class='handle'><a class='delete' href='#' onClick='removeFormField(\"#parts_" + id + "\");return false;'>Remove</a></div> \
				<div class='content'> \
								  	Name: <input type='text' name='parts["+id+"][name]' class='field name' /> \
					<div class='prefix'> \
						<div class = 'control'>+Prefix</div> \
						<div class = 'data'>Prefix: \
							<input type='text' name='parts["+id+"][prefix]' class='field additional_sequence' /> \
						</div> \
					</div> \
					<div class='sequence'> \
								  		Sequence: <input type='text' name='parts["+id+"][sequence]' class='field sequence'/> \
					</div> \
					<div class ='suffix'> \
						<div class='control'>+Suffix</div> \
						<div class='data'>Suffix: \
							<input type='text' name='parts["+id+"][suffix]' class='field additional_sequence' size='50' />	\
						</div> \
					</div> \
					<br/> \
					RC: <input type='checkbox' name='parts["+id+"][rc]' /> \
				</div> \
			</div>"	
		);

	enablePrefixClick('#parts_'+id+' > .content > ');
	enableSuffixClick('#parts_'+id+' > .content > ');

	id = (id-1)+2;
	document.getElementById("partsCount").value = id;
};

function removeFormField(id) {
	$(id).remove();
};

function submitForm() {
	$("#ape").submit();
};

function submitSampleForm() {
	$("#sample").submit();
};

function partInfo() {
	$.modal('<div>Hello</div>',{});
};