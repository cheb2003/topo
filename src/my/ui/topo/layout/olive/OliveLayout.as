/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-12
 * Time: 上午11:04
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.layout.olive {
import flash.geom.Point;

import my.ui.topo.Node;

import my.ui.topo.event.AdjustComplateEvent;

import my.ui.topo.layout.GraphLayout;

    public class OliveLayout extends GraphLayout {
        public function OliveLayout() {
            super();
        }

        public override function initPosition():void{
            var centerPoint:Point = topoGraph.getCenterPoint();
            for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
                var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
                topoGraph.addNode(node);
                if (node.isBase)
                    node.depth = int.MAX_VALUE;
                node.x = centerPoint.x;
                node.y = centerPoint.y;
            }
        }

        protected override function layout():void{
            for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
                var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));

            }
            topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
        }
    }
}
