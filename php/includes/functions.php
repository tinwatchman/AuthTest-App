<?php

function isPostField($key) {
	return (isset($_POST[$key]) && $_POST[$key] != NULL && $_POST[$key] != "");
}

function isGetField($key) {
	return (isset($_GET[$key]) && $_GET[$key] != NULL && $_GET[$key] != "");
}

function showUnauthorized($errorMessage = 'unauthorized') {
	$error = array(
		"success" => "false",
		"error" => array(
			"code" => 401,
			"status" => "401 Unauthorized",
			"message" => $errorMessage
		)
	);
	header("HTTP/1.0 401 Unauthorized", true, 401);
	header("Content-type: application/json");
	die(json_encode($error));
}

function showBadRequest($message) {
	$error = array(
		"success" => "false",
		"error" => array(
			"code" => 400,
			"status" => "400 Bad Request",
			"message" => $message
		)
	);
	header("HTTP/1.0 400 Bad Request", true, 400);
	header("Content-type: application/json");
	die(json_encode($error));
}

function showForbidden($message = "Request denied") {
	$error = array(
		"success" => "false",
		"error" => array(
			"code" => 403,
			"status" => "403 Forbidden",
			"message" => $message
		)
	);
	header("HTTP/1.0 403 Forbidden", true, 403);
	header("Content-type: application/json");
	die(json_encode($error));
}

?>