package my.ui.topo.layout.randomlayout
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	
	import my.ui.topo.Node;
	import my.ui.topo.layout.GraphLayout;
	
	import spark.components.Group;
	
	public class RandomLayout extends GraphLayout
	{
//		public var nodeDataProvider:ArrayList;
		
		
		public function RandomLayout()
		{
//			this.addEventListener(FlexEvent.CREATION_COMPLETE,completeHandle);
		}
		
		/*
		 * 重设布局边界
		 */
		private var REGION_OFFSET:uint = 10;
		private function resetLayoutRegion():Rectangle{
			var startX:Number = layoutRegion.topLeft.x;
			var startY:Number = layoutRegion.topLeft.y;
			var endX:Number = layoutRegion.bottomRight.x;
			var endY:Number = layoutRegion.bottomRight.y;
			
			startX += REGION_OFFSET;
			startY += REGION_OFFSET;
			
			var node:Node = topoGraph.nodeDataProvider.getItemAt(0) as Node;
			endX = endX - node.skin.width -REGION_OFFSET;
			endY = endY - node.skin.height - REGION_OFFSET;
			return new Rectangle(startX, startY, endX-startX, endY-startY);
		}
		
		protected override function layout():void{
//			var rect:Rectangle = layoutRegion;
//			var xMin:Number = rect.x;
//			var yMin:Number = rect.y;
//			var xMax:Number = rect.x + rect.width;
//			var yMax:Number = rect.y + rect.height;
//			var x:Number;
//			var y:Number;
//			for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
//				var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
//				x = xMin + (xMax - xMin) * Math.random();
//				y = yMin + (yMax - yMin) * Math.random();
//				topoGraph.moveNode(node, x, y);
//			}
			var distance:Number = (topoGraph.nodeDataProvider.getItemAt(0) as Node).getCheckRepeatDistance();
			var arr:ArrayList = RandomFactory.getRandomPointList(topoGraph.nodeDataProvider.length, distance, resetLayoutRegion());
			for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
				var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
				if (node.isBase())
					topoGraph.moveNode(node, layoutRegion.x + layoutRegion.width/2, layoutRegion.y + layoutRegion.height/2);
				else{
					var p:Point = arr.getItemAt(i) as Point;
					topoGraph.moveNode(node, p.x, p.y);
				}
			}
		}
		
//		private function completeHandle(evt:FlexEvent):void
//		{
//			addNodes();
//		}
		
//		private var baseNode:Node;
//		private function getBaseNode():Node{
//			for each (var node:Node in topoGraph.nodeDataProvider){
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