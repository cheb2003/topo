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
        /**顶点边距*/
        private var peak_margin:int = 100;
        /**顶点偏移量*/
        private var peak_offset:int = 50;
        /**路径边距*/
        private var path_margin:int = 80;
        /**最多路径条数*/
        public static const MAX_PATH:int = 5;
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
            basePoint = new Point(peak_margin, layoutRegion.height / 2);
            referPoint = new Point(layoutRegion.width - peak_margin, layoutRegion.height / 2);
            var baseNode:Node, referNode:Node;
            for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
                var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
                if(node.isBase){
                    baseNode = node;
                   topoGraph.moveNode(node, basePoint.x,  basePoint.y);
                }else if(node.isRefer){
                    referNode = node;
                    topoGraph.moveNode(node, referPoint.x,  referPoint.y);
                }
            }
            movePath(baseNode, referNode);
            topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
        }

        private function movePath(baseNode:Node, referNode:Node):void{
            var len:int = paths.length > MAX_PATH ? MAX_PATH : paths.length;
            for(var i:int=0;i<len;i++){
                var path:Path = Path(paths.getItemAt(i));
                var offsetY_flag:int = len == 1 ? 0 : 1;
                var nodeY:Number = path_margin * offsetY_flag + (layoutRegion.height - path_margin * 2) / (len + 1)  * (i + 1);
                var nodeNum:int = path.length;
                for(var j:int = 0;j<nodeNum;j++){
                    var node:Node = Node(path.getNodes().getItemAt(j));
                    var offsetX_flag:int = nodeNum == 1 ? 0 : 1;
                    var nodeX:Number = (offsetX_flag + peak_offset) * offsetX_flag + (layoutRegion.width - peak_margin * 2) / (nodeNum + 1) * (j+1);
                    topoGraph.moveNode(node, nodeX, nodeY);
                }
            }
        }


    }
}
