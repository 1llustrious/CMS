<?php
// +----------------------------------------------------------------------
// | ZengCMS [ 火火 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2018 http://zengcms.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 火火 <zengcms@qq.com>
// +----------------------------------------------------------------------

// +----------------------------------------------------------------------
// | 数据库管理控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use backup\Backup;
use think\facade\Db;
use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="数据库管理")
 * Class Data
 * @package app\admin\controller
 */
class Data extends Base
{
	protected $config;
	public function initialize()
	{
		parent::initialize();
		$this->config = [
			// 这里只是为了防止app同级生成空目录
            'path' => PROJECT_PATH.'/runtime/Data/',
        ];		
	}
	/**
     * @NodeAnotation(title="获取数据库中表的列表信息")
     */
	public function sql_index()
	{
		$backup = new Backup($this->config);
		$list=$backup->dataList();
		View::assign([
			'meta_title'=>'SQL命令行工具',
			'list'=>$list,
		]);
		return view();
	}
	/**
     * @NodeAnotation(title="执行sql语句")
     */
	public function sql_query()
	{
		if(request()->isAjax()){
			$type = input('post.type');
			$sql_query = input('post.sql_query');
			if(empty($sql_query)){
				return json(['code'=>0,'msg'=>'请输入正确的sql语句！']);
			}
			//array_filter() 函数用回调函数过滤数组中的值 对空值进行过滤
            $arr_sql=array_filter(explode(";",$sql_query));//可以安装多张表
            $sql_num = count($arr_sql);
            if($type == 1){ //单行命令
            	$db = Db::connect();
            	$data = $db->query($arr_sql[0]);
            	if(stripos($arr_sql[0],'select')!==false){ //查询语句
            		$msg = "运行SQL：".$arr_sql[0]."，共有".count($data)."条记录，最大返回100条！\n";
            		if($data){
            			foreach ($data as $k1=>$v) {
            				$msg.="记录".($k1+1)."\n";
            				foreach ($v as $k2 => $v2) {
            					$m = $k2." : ".$v2."\n";
            					$msg.=$m;
            				}
            			}
            		}
            		return json(['code'=>1,'msg'=>$msg]);
            	}
            	return json(['code'=>1,'msg'=>'成功执行1个SQL语句！']);
            }else{ //多行命令
            	$sql_status=true;
            	foreach ($arr_sql as $v){
            		$a=true;
            		$a=Db::execute($v);
            		if($a!==false){
            			$a=true;
            		}
            		$sql_status=$a && $sql_status;
            	}
            	if($sql_status===false){
            		return json(['code'=>0,'msg'=>'执行失败！']);
            	}
            	return json(['code'=>1,'msg'=>"成功执行{$sql_num}个SQL语句！"]);
            }
        }
    }
	/**
     * @NodeAnotation(title="获取表结构和insert数据语句")
     */
	public function get_table_insert()
	{
		if(request()->isAjax()){
			$table = input('post.table');
			$sql_table = $this->sql_table($table);
			$sql_insert = $this->sql_insert($table);
			return json(['code'=>1,'sql_table'=>$sql_table,'sql_insert'=>$sql_insert]);
		}
	}
	/**
     * @NodeAnotation(title="获取表结构")
     */
	public function sql_table($table)
	{
		$db = Db::connect();
		$result = $db->query("SHOW CREATE TABLE `{$table}`");
		$sql = "\n";
		$sql .= "-- -----------------------------\n";
		$sql .= "-- Table structure for `{$table}`\n";
		$sql .= "-- -----------------------------\n";
		$sql .= "DROP TABLE IF EXISTS `{$table}`;\n";
		$sql .= trim($result[0]['Create Table']) . ";\n\n";
		return $sql;
	}
	/**
     * @NodeAnotation(title="获取insert语句")
     */
	public function sql_insert($table,$start=0,$sql='')
	{
		$db = Db::connect();
		//数据总数
		$result = $db->query("SELECT COUNT(*) AS count FROM `{$table}`");
		$count = $result['0']['count'];
        //备份表数据
		if ($count) {
            //写入数据注释
			if (0 == $start) {
				$sql = "-- -----------------------------\n";
				$sql .= "-- Records of `{$table}`\n";
				$sql .= "-- -----------------------------\n";
			}
            //备份数据记录
			$result = $db->query("SELECT * FROM `{$table}` LIMIT {$start}, 1000");
			foreach ($result as $row) {
				$row = array_map('addslashes', $row);
				$field_arr = array_keys($row);
				$field_arr = array_map("sql_field", $field_arr);
				$field_str = implode(',', $field_arr);
				$s = "INSERT INTO `{$table}`({$field_str}) VALUES ('" . str_replace(array("\r", "\n"), array('\\r', '\\n'), implode("', '", $row)) . "');\n";
				$sql.=$s;
			}
            //还有更多数据
			if ($count > $start + 1000) {
				return $this->sql_insert($table, $start + 1000,$sql);
			}
		}
		return $sql;
	}
	/**
     * @NodeAnotation(title="表的修复")
     */
	public function repair()
	{
		if(request()->isPost()){
			$table=input('post.tablename');
			if(!empty($table)){
				$backup= new Backup($this->config);
				$result=$backup->repair($table);
				if($result[0]['Msg_text']=="OK"){
					return json(['code'=>1,'msg'=>'修复成功']);
				}
				return json(['code'=>0,'msg'=>'修复失败']);
			}
		}else{
			return json(['code'=>0,'msg'=>'请求异常']);
		}
	}
	/**
     * @NodeAnotation(title="表的优化")
     */
	public function optimize()
	{
    	if(request()->isPost()){
    		$table=input('post.tablename');
    		if(!empty($table)){
    			$backup= new Backup($this->config);
    			$result=$backup->optimize($table);
    			if($result == $table){
    				return json(['code'=>1,'msg'=>'优化成功']);
    			}
    			return json(['code'=>0,'msg'=>'优化失败']);
    		}
    	}else{
    		return json(['code'=>0,'msg'=>'请求异常']);
    	}
    }
	/**
     * @NodeAnotation(title="批量修复")
     */
	public function repairAll()
	{
    	if(request()->isAjax()){
    		$backup=new Backup($this->config);
			$list=$backup->dataList();
    		$tables=array_column($list, 'name');
    		if(is_array($tables)){
    			foreach ($tables as $v){
    				$backup->repair($v);
    			}
    			return json(['code'=>1,'msg'=>'修复完成']);
    		}
    		return json(['code'=>0,'msg'=>'修复失败']);
    	}
    	return json(['code'=>0,'msg'=>'请求异常']);
    }
	/**
     * @NodeAnotation(title="优化所有表")
     */
	public function optimizeAll()
	{
    	if(request()->isAjax()){
    		$backup=new Backup($this->config);
			$list=$backup->dataList();
    		$tables=array_column($list, 'name');
    		if(is_array($tables)){
    			foreach ($tables as $v){
    				$backup->optimize($v);
    			}
    			return json(['code'=>1,'msg'=>'优化完成']);
    		}
    		return json(['code'=>0,'msg'=>'优化失败']);
    	}
    	return json(['code'=>0,'msg'=>'请求异常']);
    }
	/**
     * @NodeAnotation(title="清空表数据")
     */
	public function clear_table_data()
	{
    	$table=input('post.tablename');
    	$db = Db::connect();
		$res = $db->query("TRUNCATE TABLE `{$table}`");
		if($res !== false){
			return json(['code'=>1,'msg'=>'清空表数据成功！','url'=>'']);
		}
		return json(['code'=>1,'msg'=>'清空表数据失败！','url'=>'']);
    }
	/**
     * @NodeAnotation(title="删除表")
     */
	public function del_table()
	{
    	$table=input('post.tablename');
    	$db = Db::connect();
		$res = $db->query("DROP TABLE `{$table}`");
		if($res !== false){
			return json(['code'=>1,'msg'=>'删除表成功！','url'=>'']);
		}
		return json(['code'=>1,'msg'=>'删除表失败！','url'=>'']);
    }
}