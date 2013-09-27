<?php

class Notary {
	protected static $instance;
	protected $public_key;
	protected $private_key;
	
	protected function __construct() {
		// don't allow this
	}
	
	protected function __clone() {
		// don't allow this
	}
		
	static function getInstance() {
		if (!self::$instance) {
			self::$instance = new self();
		}
		return self::$instance;
	}
	
	function load($publicKeyLocation, $privateKeyLocation) {
		if ( file_exists($publicKeyLocation) ) {
			$certstr = file_get_contents($publicKeyLocation);
			$this->public_key = openssl_x509_read($certstr);
		}
		if ( file_exists($privateKeyLocation) ) {
			$privstr = file_get_contents($privateKeyLocation);
			$this->private_key = openssl_pkey_get_private($privstr);
		}
	}
	
	function isLoaded() {
		return ($this->public_key != NULL && $this->private_key != NULL);
	}
	
	function encrypt($value) {
		if ($this->isLoaded()) {
			$result = "";
			openssl_private_encrypt($value, $result, $this->private_key);
			return base64_encode($result);
		}
		return NULL;
	}
	
	function decrypt($value) {
		if ($this->isLoaded()) {
			$result = "";
			$rawvalue = base64_decode($value);
			openssl_public_decrypt($rawvalue, $result, $this->public_key);
			return $result;
		}
		return NULL;
	}
}

?>