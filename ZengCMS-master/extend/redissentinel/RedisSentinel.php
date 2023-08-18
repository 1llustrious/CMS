<?php
namespace redissentinel;

// 操作redis集群的类
class RedisSentinel 
{
	public $redis;
	public $master;
	public $slaver;
	public function __construct()
	{
		$this->master = new \Redis();
		$this->slaver = new \Redis();
		$this->_connect();
	}
	private function _connect(){
		// 初始化redis对象
		$redis = new \Redis();
		$master = [];
		$slaves = [];
		// 连接sentinel服务 host为ip，port为端口
		$host = '127.0.0.1';
		$port = ['26379', '26380', '26381'];
		foreach ($port as $k => $v) {
			if($redis->connect($host, $v)){
				$this->redis = $redis;
				$master = $this->parseArrayResult($redis->rawCommand('SENTINEL', 'master', 'seckill'));
				$slaves = $redis->rawCommand('SENTINEL', 'slaves', 'seckill');
				if($slaves){ // 如果从服务获取不了那只能是主服务了
					$slavesRandIndex = array_rand($slaves);
					$slaves = $this->parseArrayResult($slaves[$slavesRandIndex]);
				}else{
					$slaves = $master;
				}
				break;
			}
		}
		$this->master->connect($master['ip'], $master['port']);
		$this->slaver->connect($slaves['ip'], $slaves['port']);
	}
	// 这个方法可以将以上sentinel返回的信息解析为数组
	public function parseArrayResult(array $data)
	{
	    $result = array();
	    $count = count($data);
	    for ($i = 0; $i < $count;) {
	        $record = $data[$i];
	        if (is_array($record)) {
	            $result[] = $this->parseArrayResult($record);
	            $i++;
	        } else {
	            $result[$record] = $data[$i + 1];
	            $i += 2;
	        }
	    }
	    return $result;
	}
	public function setRedisCache($key, $value, $time=10){
		$this->master->set($key, $value, $time);
	}
	public function getRedisCache($key){
		return $this->slaver->get($key);
	}
	public function delRedisCache($key){
		$this->master->del($key);
	}
	public function checkRequestLimit($key,$limit){
		// $this->master->del($key);
		$checked=$this->master->exists($key);
		if($checked){
			$this->master->incr($key);
			$count = intval($this->master->get($key));
			if($count>=$limit){
				return false;
			}else{
				return true;
			}
		}else{
			$this->master->set($key,1);
			$this->master->expire($key,60);
			return true;
		}
	}
}
