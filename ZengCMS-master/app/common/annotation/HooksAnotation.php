<?php
namespace app\common\annotation;

use Doctrine\Common\Annotations\Annotation\Attributes;
/**
 * 创建Hoods注解类
 *
 * @Annotation
 * @Target({"METHOD","CLASS"})
 * @Attributes({
 *   @Attribute("time", type = "int")
 * })
 */
final class HooksAnotation
{
    /**
     * 钩子(行为)名称
     * @var string
     */
    public $name='';
    /**
     * 钩子(行为)描述
     * @Required()
     * @var string
     */
    public $description=NULL;
    /**
     * 钩子类型(1:视图,2:控制器)
     * @Enum({1,2})
     * @var string
     */
    public $type=1;
    /**
     * 钩子(行为)是否系统
     * @Enum({1,0})
     * @var string
     */
    public $system=0;
    /**
     * 钩子(行为)状态
     * @Enum({1,0})
     * @var string
     */
    public $status=1;
}