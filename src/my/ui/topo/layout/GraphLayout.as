package my.ui.topo.layout
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * 布局算法基类
	 */ 
	public class GraphLayout extends EventDispatcher
	{	
		/**
		 *	布局算法计算区域，边界对象 
		 */
		protected var _layoutRegion:Rectangle;
		
		public function GraphLayout()
		{
			init();
			layout();
		}
		
		/**
		 * 初始化方法，子类继承该类通过重写该方法
		 * 进行基础数据初始化
		 */ 
		protected function init():void{
			
		}
		
		/**
		 * 布局算法，不同布局算法实现切入点
		 * 子类需重写
		 */ 
		protected function layout():void{
			
		}
		
		public function get layoutRegion():Rectangle
		{
			return _layoutRegion;
		}
		
		public function set layoutRegion(value:Rectangle):void
		{
			_layoutRegion = value;
		}
	}
}