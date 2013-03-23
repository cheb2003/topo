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
		public var nodeDataProvider:Object;
		/**连线集合*/
		[Bindable]
		public var linkDataProvider:Object;
		/**节点布局*/
		[Bindable]
		public var nodeLayout:BaseLayoutFactory = new RandomFactory();
		
		
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
			var nodes:ArrayCollection = ArrayCollection(nodeDataProvider);
			for(var i:int=0;i<nodes.length;i++){
				var node:Node = Node(nodes.getItemAt(i));
				this.addElement(node);
			}
		}
        private function mouseDown(event:MouseEvent):void {

        }
		
    }

}
