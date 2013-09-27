<?php

include_once("includes/functions.php");

if ( $_POST && isPostField('userEmail') && isPostField('userPass') && isPostField('deviceId') && isPostField('devicePass') ) 
{
	include_once('includes/startup.php');
	$email = (string) $_POST['userEmail'];
	$pass = (string) $_POST['userPass'];
	$device_id = (string) $_POST['deviceId'];
	$device_pass = (string) $_POST['devicePass'];
	
	// first, check to see if user already exists
	$user = $db->getUserByEmail($email);
	if ( $user == NULL || !$db->verifyPassword($pass, $user->pass) ) {
		showBadRequest("Invalid user credentials");
	}
	
	if ( $db->verifyNewDeviceId($device_id) ) {
		$device = $db->addDevice($device_id, $device_pass, $user);
	} else {
		showBadRequest("Device already registered");
	}
	
	$data = array(
		"success" => "true",
		"userId" => $user->id,
		"deviceId" => $device->device_id
	);
	header("HTTP/1.0 200 OK", true, 200);
	header("Content-type: application/json");
	echo json_encode($data);
}
else
{
	showForbidden();
}

?>