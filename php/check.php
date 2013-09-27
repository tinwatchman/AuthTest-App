<?php 

include_once('includes/functions.php');

if ( $_POST && isPostField('token') ) 
{
	include_once('includes/startup.php');
	$raw_token = urldecode($_POST['token']);
	$decoded = $notary->decrypt($raw_token);
	$token = Token::recreate($decoded);
	if ( !$token->isValid() ) {
		$log->debug("bad token: raw - " . $_POST['token'] . ", decoded - " . $decoded . ", serialized - " . $token->serialize());
		showUnauthorized("bad token");
	} else if ( $token->isExpired() ) {
		$log->debug("expired token");
		showUnauthorized("token expired");
	}
	$device = $db->getDevice($token->getDeviceId());
	if ( empty($device) || $device->user->id != $token->getUserId() ) {
		showUnauthorized("device not registered");
	}
	
	// present to client
	$data = array(
		"success" => "true",
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