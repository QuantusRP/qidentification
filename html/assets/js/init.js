$(document).ready(function(){
  // LUA listener
  window.addEventListener('message', function( event ) {
	console.log("a thing")
	if (event.data.action == 'open') {
		console.log("open requested")
	  var metadata	= event.data.metadata;
	  var type		= event.data.metadata.cardtype;
	  var licenseData = metadata.licenses;
	  var sex		 = metadata.sex;
	  var mugshot	 = metadata.mugshoturl
	  console.log(type)
	  if ( type == 'identification' || type == null || type == "drivers_license") {
		console.log("It's a drivers license")
		$('img').show();
		$('#name').css('color', '#282828');
		$('#fname').css('color', '#282828');

		if ( sex.toLowerCase() == 'm' ) {
		  $('#sex').text('m');
		} else {
		  $('#sex').text('f');
		}
		$('img').attr('src', mugshot);
		$('#idnum').text(metadata.citizenid);
		$('#expiry').text(metadata.expireson);
		$('#name').text(metadata.lastName);
		$('#fname').text(metadata.firstName);
		$('#dob').text(metadata.dateofbirth);
		var inches = metadata.height
		var feet = Math.floor(inches / 12);
		inches %= 12;
		$('#height').text(feet + "ft " + inches + 'in');
		$('#signature').text(metadata.firstName + ' ' + metadata.lastName);

		if ( type == 'drivers_license' ) {
		  if ( licenseData != null ) {
		  Object.keys(licenseData).forEach(function(key) {
			var type = licenseData[key].type;

			if ( type == 'drive_bike') {
			  type = 'bike';
			} else if ( type == 'drive_truck' ) {
			  type = 'truck';
			} else if ( type == 'drive' ) {
			  type = 'car'; 
			}

			if ( type == 'bike' || type == 'truck' || type == 'car' ) {
			  $('#licenses').append('<p>'+ type +'</p>');
			}
		  });
		}

		  $('#id-card').css('background', 'url(assets/images/license.png)');
		} else {
		  $('#id-card').css('background', 'url(assets/images/idcard.png)');
		}
	  } else if ( type == 'firearms_license' ) {
		$('img').show();
		$('#idnum').text(metadata.citizenid);
		$('#name').css('color', '#282828');
		$('#fname').css('color', '#282828');
		$('img').attr('src', mugshot);
		$('#name').text(metadata.lastName);
		$('#fname').text(metadata.firstName);
		$('#dob').text(metadata.dateofbirth);
		$('#signature').text(metadata.firstName + ' ' + metadata.lastName);
		$('img').attr('src', mugshot);
		$('#expiry').text(metadata.expireson);
		$('#id-card').css('background', 'url(assets/images/firearm.png)');
	  }

	  $('#id-card').show();
	} else if (event.data.action == 'close') {
	  $('#name').text('');
	  $('#fname').text('');
	  $('#dob').text('');
	  $('#height').text('');
	  $('#signature').text('');
	  $('#sex').text('');
	  $('#id-card').hide();
	  $('#licenses').html('');
	}
  });
});
