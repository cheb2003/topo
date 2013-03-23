package my.ui.topo.layout.randomlayout
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	
	public class RandomPoint extends Group
	{
		public var num:uint;
		
		public function RandomPoint()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,completeHandle);
		}
		
		private function completeHandle(evt:FlexEvent):void
		{
			drawTopo();
		}
		
		public function drawTopo():void{
			var arr:Array = RandomFactory.getRandomPointList(num,null);
			for each(var p:Point in arr){
				drawCircle(p);
			}
		}
		
		private function drawCircle(p:Point, radius:int=10):void{
			this.graphics.lineStyle(1, 0xaaaaaa, 100);
			this.graphics.beginFill(0xcccccc, 100);
			this.graphics.drawCircle(p.x, p.y, radius);
			this.graphics.endFill();
		}
	}
}