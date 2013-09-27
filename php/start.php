<?php

include('includes/functions.php');

if ( $_POST && isPostField('userId') && isPostField('deviceId') && isPostField('devicePass') )
{
	include_once('includes/startup.php');
	
	$user_id = (int) $_POST['userId'];
	$device_id = (string) $_POST['deviceId'];
	$device_pass = (string) $_POST['devicePass'];
	
	$user = $db->getUser($user_id);
	$device = $db->getDevice($device_id);
	
	if ( isset($user) && isset($device) && $user == $device->user && $db->verifyPassword($device_pass, $device->device_pass) ) {
		// create new token
		$token = new Token;
		$token->setUserId($user->id);
		$token->setDeviceId($device->device_id);
		$token->setTTL(600);
		$token->generateHash();
		
		// create signed session token
		$tokenstr = $token->serialize();
		$session_token = urlencode($notary->encrypt($tokenstr));
		
		// present to client
		$data = array(
			"success" => "true",
			"userId" => $user->id,
			"deviceId" => $device->device_id,
			"session" => array(
				"token" => $session_token,
				"expires" => $token->getExpireTime()
			)
		);
		header("HTTP/1.0 200 OK", true, 200);
		header("Content-type: application/json");
		echo json_encode($data);
	} else if ( empty($user) ) {
		// if user isn't registered
		showUnauthorized("user not registered");
	} else if ( empty($device) ) {
		// if device isn't registered
		showUnauthorized("device not registered");
	} else if ( $user != $device->user ) {
		// if device isn't registered for the given user
		showUnauthorized('device not registered for user');
	} else {
		// if device password didn't pass the check
		showUnauthorized('not authorized');
	}
} 
else 
{
	showForbidden();
}

?>