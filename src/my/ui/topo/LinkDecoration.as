package my.ui.topo
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * 连线悬停小圆标记类
	 */ 
	public class LinkDecoration extends UIComponent
	{
		private var _radius:Number = 5;
		
		public function LinkDecoration()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,complateHandle);
		}
		
		private function complateHandle(event:FlexEvent):void{
			drawCircle();
		}
		
		private function drawCircle():void{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.drawCircle(this.x + radius/2, this.y + radius/2, radius);
			this.graphics.beginFill(0xff0000, 0.8);
			this.graphics.endFill();
		}

		/**半径*/
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius = value;
		}

	}
}