package my.ui.topo.layout.randomlayout
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import my.ui.topo.Node;
	import my.ui.topo.layout.GraphLayout;
	
	import spark.components.Group;
	
	public class RandomLayout extends GraphLayout
	{
		public var nodeDataProvider:ArrayList;
		
		
		public function RandomLayout()
		{
//			this.addEventListener(FlexEvent.CREATION_COMPLETE,completeHandle);
		}
		
		protected override function layout():void{
			
		}
		
//		private function completeHandle(evt:FlexEvent):void
//		{
//			addNodes();
//		}
		
//		private var baseNode:Node;
//		private function getBaseNode():Node{
//			for each (var node:Node in nodeDataProvider){
//				if (node.isBase()){
//					nodeDataProvider.removeItem(node);
//					baseNode = node;
//				}
//			}
//			return null;
//		}
//		
//		private function addBaseNode():void{
//			getBaseNode();
//			if (baseNode!=null)
//			{
//				this.addElement(baseNode);
//				baseNode.x = this.width/2;
//				baseNode.y = this.height/2;
//			}
//		}
//		
//		private function addRandomNodes():void{
//			for (var i:uint=0; i<nodeDataProvider.length; i++)
//			{
//				var node:Node = nodeDataProvider.getItemAt(i) as Node;
//				this.addElement(node);
//				var p:Point = RandomFactory.getRandomPoint(0,1000,0,600);
//				node.x = p.x;
//				node.y = p.y;
//			}
//		}
//		
//		private function resetNodes():void{
//			var distance:Number = (nodeDataProvider.getItemAt(0) as Node).getCheckRepeatDistance();
//			var arr:ArrayList = RandomFactory.getRandomPointList(nodeDataProvider.length,baseNode,distance,0);
//			for (var i:uint=0; i<nodeDataProvider.length; i++){
//				var node:Node = nodeDataProvider.getItemAt(i) as Node;
//				var p:Point = arr.getItemAt(i) as Point;
//				TweenLite.to(node, 1, {x:p.x, y:p.y});
//			}
//		}
//		
//		public function addNodes():void
//		{
//			addBaseNode();
//			
//			addRandomNodes();
//			
//			resetNodes();
//		}
//		
//		private function drawCircle(p:Point, radius:int=10):void{
//			this.graphics.lineStyle(1, 0xaaaaaa, 100);
//			this.graphics.beginFill(0xcccccc, 100);
//			this.graphics.drawCircle(p.x, p.y, radius);
//			this.graphics.endFill();
//		}
	}
}