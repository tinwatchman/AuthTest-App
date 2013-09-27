<?php

include_once('model/log.php');
include_once('model/database.php');
include_once('model/notary.php');

$log = AuthLog::getInstance();
if (!$log->isConnected()) {
	$log->connect();
	$log->info('=== log startup ===');
}

$db = AuthDB::getInstance();
if (!$db->isConnected()) {
	$db->connect();
	$log->info('=== db startup ===');
}

$notary = Notary::getInstance();
if (!$notary->isLoaded()) {
	$notary->load('cert/self.crt', 'cert/private.key');
	$log->info('=== notary startup ===');
}

?>