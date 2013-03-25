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
		
		protected override function layout():void{
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
			topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
		}
	}
}