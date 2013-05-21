/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-20
 * Time: 下午4:38
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.layout.radial {
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.ArrayList;

import my.ui.topo.Node;
import my.ui.topo.event.AdjustComplateEvent;
import my.ui.topo.layout.GraphLayout;
import my.ui.topo.layout.randomlayout.RandomFactory;

/**
 * Radia布局，用于图3
 * 
 */
public class RadialLayout extends GraphLayout {
    public function RadialLayout() {
        super();
    }

	/**
	 * 初始化组件位置
	 * 
	 */
    public override function initPosition():void{
        for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
            var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
            topoGraph.addNode(node);
            if (node.isBase)
                node.depth = int.MAX_VALUE;
            node.x = 80;
            node.y = 80;
        }
    }

	private var REGION_OFFSET:uint = 10;
	/**
	 * 计算随机点限制区域
	 * 
	 */
	private function resetCircleLayoutRegion():Rectangle{
		var startX:Number = layoutRegion.topLeft.x+80;
		var startY:Number = layoutRegion.topLeft.y+80;
		var endX:Number = layoutRegion.bottomRight.x;
		var endY:Number = layoutRegion.bottomRight.y;
		
		startX += REGION_OFFSET;
		startY += REGION_OFFSET;
		var tempHeight:Number = layoutRegion.bottomRight.y-layoutRegion.topLeft.y-80;
		var tempWidth:Number = layoutRegion.bottomRight.x - layoutRegion.topLeft.x-80;
		
		var node:Node = topoGraph.nodeDataProvider.getItemAt(0) as Node;
		endX = tempWidth - node.skin.width -REGION_OFFSET;
		endY = tempHeight - node.skin.height - REGION_OFFSET;
		return new Rectangle(startX, startY, endX,endY);
	}
	
	/**
	 * 布局方法
	 * 
	 */
    protected override function layout():void{
		super.layout()
		var distance:Number = (topoGraph.nodeDataProvider.getItemAt(0) as Node).getCheckRepeatDistance();
		var arr:ArrayList = RandomFactory.getRandomPointList(topoGraph.nodeDataProvider.length, distance, resetCircleLayoutRegion(),0,topoGraph.getBasePoint());
		for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
			var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
			if (node.isBase)
				topoGraph.moveNode(node, layoutRegion.x+80+ node.width/2, layoutRegion.y+80 + node.height/2);
			else{
				var p:Point = arr.getItemAt(i) as Point;
				topoGraph.moveNode(node, p.x, p.y);
			}
		}
		topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
    }
}
}
