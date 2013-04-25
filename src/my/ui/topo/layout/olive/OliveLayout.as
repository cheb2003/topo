/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-12
 * Time: 上午11:04
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.layout.olive {
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

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
        /**基础半径，用于绘制椭圆轨迹参照*/
        public static const RADIUS:int = 30;
        public var paths:ArrayCollection = new ArrayCollection();

        public function OliveLayout() {
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
            super.layout()
            basePoint = new Point(peak_margin, layoutRegion.height / 2);
            referPoint = new Point(layoutRegion.width - peak_margin, layoutRegion.height / 2);
            for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
                var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
                if(node.isBase)
                   topoGraph.moveNode(node, basePoint.x,  basePoint.y);
                else if(node.isRefer)
                    topoGraph.moveNode(node, referPoint.x,  referPoint.y);
            }
            movePath2();
            topoGraph.dispatchEvent(new AdjustComplateEvent(AdjustComplateEvent.NODE_ADJUST_COMPLATE));
        }

        private function movePath():void{
            topoGraph.resetDelayAnimationFactor();
            var len:int = paths.length > MAX_PATH ? MAX_PATH : paths.length;
            for(var i:int=0;i<len;i++){
                var path:Path = Path(paths.getItemAt(i));
                var nodeY:Number = path_margin  + (layoutRegion.height - path_margin * 2) / (len + 1)  * (i + 1);
                var nodeNum:int = path.length;
                for(var j:int = 0;j<nodeNum;j++){
                    var node:Node = Node(path.getNodes().getItemAt(j));
                    var nodeX:Number = (peak_margin + peak_offset) + (layoutRegion.width - peak_margin * 2 - peak_offset * 2) / (nodeNum + 1) * (j+1);
                    topoGraph.moveNode(node, nodeX, nodeY);
                }
            }
        }

       private function movePath2():void{
           topoGraph.resetDelayAnimationFactor();
           var centerPoint:Point = topoGraph.getCenterPoint();
           var centerX:Number = centerPoint.x;
           var len:int = paths.length > MAX_PATH ? MAX_PATH : paths.length;
           for(var i:int=0;i<len;i++){
               var path:Path = Path(paths.getItemAt(i));
//               var nodeY:Number = path_margin  + (layoutRegion.height - path_margin * 2) / (len + 1)  * (i + 1);
               var nodeNum:int = path.length;
               for(var j:int = 0;j<nodeNum;j++){
                   var node:Node = Node(path.getNodes().getItemAt(j));
                   var nodeX:Number = (peak_margin + peak_offset) + (layoutRegion.width - peak_margin * 2 - peak_offset * 2) / (nodeNum + 1) * (j+1);
//                   var cos:Number = (nodeX > centerX) ? nodeX - centerX
                   var nodeY:Number = 0;
                   topoGraph.moveNode(node, nodeX, nodeY);
               }
           }
       }
    }
}
