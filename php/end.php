<?php

include('includes/functions.php');

if ( $_POST && isPostField('userId') && isPostField('deviceId') && isPostField('devicePass') ) 
{
	include_once('includes/startup.php');
	
	$user_id = (int) $_REQUEST['userId'];
	$device_id = (string) $_REQUEST['deviceId'];
	$device_pass = (string) $_REQUEST['devicePass'];
	
	$device = $db->getDevice($device_id);
	
	if ( isset($device) && $user_id == $device->user->id && $db->verifyPassword($device_pass, $device->device_pass) ) {
		// delete device - note: in retrospect, should have made this a many-to-many relationship with user table
		$db->removeDevice($device);
		$data = array(
			"success" => "true",
		);
		header("HTTP/1.0 200 OK", true, 200);
		header("Content-type: application/json");
		echo json_encode($data);
	} else {
		showUnauthorized("not valid");
	}
}
else
{
	showForbidden();
}

?>