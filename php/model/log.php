<?php

class AuthLog {
	protected static $instance;
	protected static $LOG_FILE_NAME = "AuthLog";
	protected $logfile;
	
	protected function __construct() {
		// don't allow this
		date_default_timezone_set("America/New_York");
	}
	
	protected function __clone() {
		// don't allow this
	}
	
	function __destruct() {
		if ( isset($this->logfile) ) {
			fclose($this->logfile);
		}
	}
	
	static function getInstance() {
		if (!self::$instance) {
			self::$instance = new self();
		}
		return self::$instance;
	}
		
	function isConnected() {
		return isset($this->logfile);
	}
	
	function connect() {
		$filenm = sys_get_temp_dir() . AuthLog::$LOG_FILE_NAME . "_" . date('Ymd') . ".txt";
		$this->logfile = fopen($filenm, 'a');
	}
	
	function info($msg) {
		if ($this->isConnected()) {
			$line = date("Y-m-d H:i:s:u") . " " . __FILE__ . ":" . __LINE__ . " " . $msg . "\n";
			$result = fwrite($this->logfile, $line);
		}
	}
	
	function debug($msg) {
		if ($this->isConnected()) {
			$line = date("Y-m-d H:i:s:u") . " [DEBUG] " . __FILE__ . ":" . __LINE__ . " " . $msg . "\n";
			$result = fwrite($this->logfile, $line);
		}
	}
}
?>