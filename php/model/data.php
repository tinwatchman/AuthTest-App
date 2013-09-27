<?php 

class User {
	public $id = 0;
	public $email = "";
	public $pass = "";
	
	static function create($row) {
		$user = new User();
		$user->id = (int) $row['id'];
		$user->email = urldecode($row['email']);
		$user->pass = $row['pass'];
		return $user;
	}
}

class Device {
	public $id = 0;
	public $user = NULL;
	public $device_id = "";
	public $device_pass = "";
	
	static function create($row) {
		$device = new Device();
		$device->id = (int) $row['id'];
		$device->device_id = $row['device_id'];
		$device->device_pass = $row['device_pass'];
		return $device;
	}
}

class Token implements Serializable {
	private $user_id;
	private $device_id;
	private $expireTime;
	private $hash;
	
	function getUserId() {
		return $this->user_id;
	}
	
	function setUserId($value) {
		$this->user_id = (int) $value;
	}
	
	function getDeviceId() {
		return $this->device_id;
	}
	
	function setDeviceId($value) {
		$this->device_id = (string) $value;
	}
	
	function getTTL() {
		if ($this->expireTime != NULL && is_int($this->expireTime)) {
			return $this->expireTime - time();
		}
		return -1;
	}
	
	function getExpireTime() {
		return $this->expireTime;	
	}
	
	function setTTL($ttl) {
		if (is_int($ttl)) {
			$this->expireTime = time() + (int) $ttl;
		}
	}
	
	function getHash() {
		return $this->hash;
	}
	
	function generateHash() {
		$this->hash = $this->getDataHash();
	}
		
	function isExpired() {
		return ($this->getTTL() <= 0);	
	}
	
	function isValid() {
		return ( !empty($this->user_id) && !empty($this->device_id) && !empty($this->expireTime) && $this->isHashValid() );	
	}
		
	function serialize() {
		$arr = array(
			"a" => $this->user_id,
			"b" => $this->device_id,
			"c" => $this->expireTime,
			"d" => $this->hash
		);
		return json_encode($arr);
	}
	
	function unserialize($value) {
		$val = json_decode($value, true);
		if (is_array($val)) {
			$this->user_id = (int) $val["a"];
			$this->device_id = (string) $val["b"];
			$this->expireTime = (int) $val["c"];
			$this->hash = (string) $val["d"];
		}
	}
	
	protected function getDataHash() {
		if (isset($this->user_id) && isset($this->device_id) && isset($this->expireTime)) {
			$basedata = array (
				"x" => $this->user_id,
				"y" => $this->device_id,
				"z" => $this->expireTime
			);
			return (string) sha1(json_encode($basedata)); // note: can use better hash here for more security
		}
		return NULL;
	}
	
	protected function isHashValid() {
		if (isset($this->hash) && $this->hash != NULL) {
			$datahash = $this->getDataHash();
			if ($datahash != NULL && $this->hash == $datahash) {
				return TRUE;
			}
		}
		return FALSE;
	}
	
	static function recreate($value) {
		$token = new Token();
		$token->unserialize($value);
		return $token;
	}
}

?>