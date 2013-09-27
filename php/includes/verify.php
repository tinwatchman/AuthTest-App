<?php 

include_once('includes/startup.php');
include_once('includes/functions.php');

// note to self: don't actually send the token via GET -- those will probably show up in the server logs.
if ( $_GET && isGetField('token') ) 
{
	$decoded = $notary->decrypt(urldecode($_GET['token']));
	$token = Token::recreate($decoded);
	if ( !$token->isValid() ) {
		showUnauthorized("bad token");
	} else if ( $token->isExpired() ) {
		showUnauthorized("token expired");
	}
} else {
	showForbidden();
}

?>