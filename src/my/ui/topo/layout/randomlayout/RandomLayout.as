package my.ui.topo.layout.randomlayout
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	
	import my.ui.topo.Node;
	import my.ui.topo.event.AdjustComplateEvent;
	import my.ui.topo.layout.GraphLayout;
	
	public class RandomLayout extends GraphLayout
	{
		
		public function RandomLayout()
		{
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
		
		private function resetCircleLayoutRegion():Rectangle{
			var startX:Number = layoutRegion.topLeft.x;
			var startY:Number = layoutRegion.topLeft.y;
			var endX:Number = layoutRegion.bottomRight.x;
			var endY:Number = layoutRegion.bottomRight.y;
			
			startX += REGION_OFFSET;
			startY += REGION_OFFSET;
			var tempHeight:Number = layoutRegion.bottomRight.y-layoutRegion.topLeft.y;
			var tempWidth:Number = layoutRegion.bottomRight.x - layoutRegion.topLeft.x;
			var minValue:Number = 0;
			if (tempWidth>=tempHeight)
				minValue= tempHeight;
			else
				minValue= tempWidth;
			
			var node:Node = topoGraph.nodeDataProvider.getItemAt(0) as Node;
			endX = minValue - node.skin.width -REGION_OFFSET;
			endY = minValue - node.skin.height - REGION_OFFSET;
			startX = tempWidth/2-minValue/2+REGION_OFFSET;
			startY = tempHeight/2-minValue/2+REGION_OFFSET;
			return new Rectangle(startX, startY, endX,endY);
		}
		
		protected override function layout():void{
			var distance:Number = (topoGraph.nodeDataProvider.getItemAt(0) as Node).getCheckRepeatDistance();
//			var arr:ArrayList = RandomFactory.getRandomPointList(topoGraph.nodeDataProvider.length, distance, resetLayoutRegion());
			var arr:ArrayList = RandomFactory.getRandomPointList(topoGraph.nodeDataProvider.length, distance, resetCircleLayoutRegion());
			for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
				var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
				if (node.isBase)
					topoGraph.moveNode(node, layoutRegion.x + layoutRegion.width/2, layoutRegion.y + layoutRegion.height/2);
				else{
					var p:Point = arr.getItemAt(i) as Point;
					topoGraph.moveNode(node, p.x, p.y);
				}
			}
			topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
		}
	}
}