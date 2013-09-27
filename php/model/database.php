<?php

include_once('data.php');

class AuthDB {
	protected static $instance;
	protected static $blowfish_salt_complexity = "07";
	protected $db;
		
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
	
	function connect() {
		$filenm = sys_get_temp_dir() . 'authdb.db';
		if (!file_exists($filenm)) {
			$this->db = sqlite_open($filenm);
			sqlite_exec($this->db, 'CREATE TABLE user ( id INTEGER PRIMARY KEY, email TEXT, pass TEXT );');
			sqlite_exec($this->db, 'CREATE TABLE device ( id INTEGER PRIMARY KEY, device_id TEXT, user_id INTEGER, device_pass TEXT, FOREIGN KEY(user_id) REFERENCES user(id) );');
		} else {
			$this->db = sqlite_open($filenm);
		}
	}
	
	function isConnected() {
		return isset($this->db);
	}
	
	function addUser($email, $pass) {
		$safe_email = urlencode($email);
		$pass_salt = "$2y$" . AuthDB::$blowfish_salt_complexity . "$" . $this->getPasswordSalt(22);
		$safe_pass = crypt($pass, $pass_salt);
		$sql = 'INSERT INTO user (email, pass) VALUES ("' . $safe_email . '", "' . $safe_pass . '");';
		sqlite_exec($this->db, $sql);
		$user = new User();
		$user->id = sqlite_last_insert_rowid($this->db);
		$user->email = $email;
		$user->pass = $safe_pass;
		return $user;
	}
	
	function getUser($id) {
		$safe_id = (int) $id;
		$sql = "SELECT * FROM user WHERE id = $safe_id;";
		$result = sqlite_query($this->db, $sql);
		if (sqlite_num_rows($result) > 0) {
			$row = sqlite_fetch_array($result);
			return User::create($row);
		}
		return NULL;
	}
	
	function getUserByEmail($email) {
		$safe_email = urlencode($email);
		$sql = "SELECT * FROM user WHERE email = '$safe_email';";
		$result = sqlite_query($this->db, $sql);
		if (sqlite_num_rows($result) > 0) {
			$row = sqlite_fetch_array($result);
			return User::create($row);
		}
		return NULL;
	}
	
	function addDevice($deviceId, $devicePass, $user) {
		$safe_id = $this->sterilizeDeviceId($deviceId);
		$pass_salt = "$2y$" . AuthDB::$blowfish_salt_complexity . "$" . $this->getPasswordSalt(22);
		//echo "Device pass: $devicePass<br>";
		//echo "Pass salt: $pass_salt<br>";
		$safe_pass = crypt($devicePass, $pass_salt);
		//echo "Safe pass: $safe_pass<br>";
		$sql = "INSERT INTO device (device_id, user_id, device_pass) VALUES ('$safe_id', $user->id, '$safe_pass');";
		sqlite_exec($this->db, $sql);
		$device = new Device();
		$device->id = sqlite_last_insert_rowid($this->db);
		$device->device_id = $safe_id;
		$device->device_pass = $safe_pass;
		$device->user = $user;
		return $device;
	}
	
	function getDevice($device_id) {
		return $this->_getDevice($device_id);
	}
	
	function hasDevice($device_id) {
		return ( $this->_getDevice($device_id, FALSE) != NULL );
	}
	
	function removeDevice($device) {
		$safe_id = $this->sterilizeDeviceId($device->device_id);
		$sql = "DELETE FROM device WHERE device_id='$safe_id';";
		sqlite_exec($this->db, $sql);
	}
	
	function getUserDevices($user) {
		$list = array();
		$sql = "SELECT * FROM device WHERE user_id = $user->id;";
		$results = sqlite_query($this->db, $sql);
		$len = sqlite_num_rows($results);
		for ($i = 0; $i < $len; $i++) {
			$row = sqlite_fetch_array($results);
			$device = Device::create($row);
			if ($row['user_id'] == $user->id) {
				$device->user = $user;
				array_push($list, $device);
			}
		}
		return $list;
	}
	
	function verifyNewDeviceId($new_id) {
		if ($this->sterilizeDeviceId($new_id) != $new_id) {
			return FALSE;
		}
		if ( $this->isConnected() && $this->hasDevice($new_id) ) {
			return FALSE;
		}
		return TRUE;
	}
	
	function verifyPassword($raw_input, $pass_hash) {
		if (crypt($raw_input, $pass_hash) == $pass_hash) {
			return true;
		}
		return false;
	}
	
	function sterilizeDeviceId($device_id) {
		return preg_replace('/[^A-z0-9\+\/]/i', '', $device_id);
	}
	
	function dumpAllUsers() {
		$q = 'SELECT * FROM user;';
		$result = sqlite_query($this->db, $q);
		$allResults = sqlite_fetch_all($result);
		echo "<p>Users: <br>";
		var_dump($allResults);
		echo "</p>";
	}
	
	function dumpAllDevices() {
		$q = "SELECT * FROM device;";
		$result = sqlite_query($this->db, $q);
		$allResults = sqlite_fetch_all($result);
		echo "<p>Devices: <br>";
		var_dump($allResults);
		echo "</p>";
	}
	
	protected function getPasswordSalt($length) {
		$rawSalt = base64_encode(openssl_random_pseudo_bytes($length));
		$rawSalt = preg_replace('/[\+\/\=]/i', '', $rawSalt);
		$start = mt_rand(0, strlen($rawSalt)-$length);
		return substr($rawSalt, 0, $length);
	}
	
	protected function _getDevice($device_id, $populateUser = TRUE) {
		$safe_device_id = $this->sterilizeDeviceId($device_id);
		$sql = "SELECT * FROM device WHERE device_id = '$safe_device_id'";
		$result = sqlite_query($this->db, $sql);
		if (sqlite_num_rows($result) > 0) {
			$row = sqlite_fetch_array($result);
			$device = Device::create($row);
			if ($populateUser) {
				$device->user = $this->getUser($row['user_id']);
			}
			return $device;
		}
		return NULL;
	}
}

?>