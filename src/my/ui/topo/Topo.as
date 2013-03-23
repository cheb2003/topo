/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {


    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    
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
		
		
        public function Topo() {
            super();
            setStyle("skinClass", SkinnableContainerSkin);
			callLater(layoutGraph);
        }
		
		public function layoutGraph():void {
			var nodes:ArrayCollection = ArrayCollection(nodeDataProvider);
			for(var i:int=0;i<nodes.length;i++){
				var node:Node = Node(nodes.getItemAt(i));
				this.addElement(node);
			}
		}
    }

}
