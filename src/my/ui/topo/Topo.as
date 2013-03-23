/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {


import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.collections.ICollectionView;
import mx.controls.Alert;

import my.ui.topo.layout.BaseLayoutFactory;
import my.ui.topo.layout.randomlayout.RandomFactory;

import spark.components.SkinnableContainer;
import spark.skins.spark.SkinnableContainerSkin;

	[SkinState("normal")]
    public class Topo extends SkinnableContainer {
		/**节点集合*/
		[Bindable]
		public var nodeDataProvider:ArrayCollection;
		/**连线集合*/
		[Bindable]
		public var linkDataProvider:ArrayCollection;
		/**节点布局*/
		[Bindable]
		public var nodeLayout:BaseLayoutFactory = new RandomFactory();
		/**当前选中节点*/
		private var _selectedNode:Node;
		
		
        public function Topo() {
            super();
            setStyle("skinClass", SkinnableContainerSkin);
			callLater(performGraphLayout);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
        }

		/**
		 * 执行布局算法
		 */ 
		public function performGraphLayout():void {
			if(nodeLayout){
				nodeLayout.layoutRegion = new Rectangle(0, 0, this.width, this.height);
			}
			for(var i:int=0;i<nodeDataProvider.length;i++){
				var node:Node = Node(nodeDataProvider.getItemAt(i));
				this.addElement(node);
			}
		}
		
		/**
		 * 将node移动到顶层
		 */ 
		public function bringToFront(node:Node):void {
			node.depth = int.MAX_VALUE;
		}
		
        private function mouseDown(event:MouseEvent):void {

        }
		
		public function get selectedNode():Node
		{
			return _selectedNode;
		}
		
		public function set selectedNode(value:Node):void
		{
			_selectedNode = value;
			_selectedNode.depth = int.MAX_VALUE;
		}
    }

}
