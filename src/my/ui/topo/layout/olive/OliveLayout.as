/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-12
 * Time: 上午11:04
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.layout.olive {
import flash.geom.Point;
import flash.geom.Point;

import mx.collections.ArrayCollection;

import my.ui.topo.Node;
import my.ui.topo.Path;

import my.ui.topo.event.AdjustComplateEvent;

import my.ui.topo.layout.GraphLayout;

    public class OliveLayout extends GraphLayout {
        private var basePoint:Point;
        private var referPoint:Point;
        private var offset:int = 100;
        public var paths:ArrayCollection.<Path> = new ArrayCollection.<Path>();

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
            basePoint = new Point(offset, layoutRegion.height / 2);
            referPoint = new Point(layoutRegion.width - offset, layoutRegion.height / 2);
            for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
                var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
                if(node.isBase)
                   topoGraph.moveNode(node, basePoint.x,  basePoint.y);
                else if(node.isRefer)
                   topoGraph.moveNode(node, referPoint.x,  referPoint.y);
            }
            movePath();
            topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
        }

        private function movePath():void{
            var len:int = paths.length;
            for(var i:int=0;i<paths.length;i++){

            }
        }


    }
}
