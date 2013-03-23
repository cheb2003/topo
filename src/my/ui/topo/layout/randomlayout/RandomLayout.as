package my.ui.topo.layout.randomlayout
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import my.ui.topo.Node;
	
	import spark.components.Group;
	
	public class RandomLayout extends Group
	{
		public var nodeDataProvider:ArrayList;
		
		public function RandomLayout()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,completeHandle);
		}
		
		private function completeHandle(evt:FlexEvent):void
		{
			addNodes();
		}
		
		public function addNodes():void{
//			var distance:Number = (nodeDataProvider.getItemAt(i) as Node).getCheckRepeatDistance();
			var distance:Number = 30;
			var arr:ArrayList = RandomFactory.getRandomPointList(nodeDataProvider.length,null,distance,10);
			for (var i:uint=0; i<arr.length; i++)
			{
				var p:Point = arr.getItemAt(i) as Point;
				var node:Node = nodeDataProvider.getItemAt(i) as Node;
				node.x = p.x;
				node.y = p.y;
				this.addElement(node);
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