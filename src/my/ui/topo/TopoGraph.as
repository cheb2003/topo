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
    import mx.controls.Alert;


    import my.ui.topo.layout.BaseLayoutFactory;
    import my.ui.topo.layout.randomlayout.RandomFactory;
    
    import spark.components.SkinnableContainer;
    import spark.skins.spark.SkinnableContainerSkin;

	[SkinState("normal")]
    public class TopoGraph extends SkinnableContainer {
		/**节点集合*/
        [Bindable]
        private var _nodeDataProvider:ArrayCollection;
        private var _nodeDataProviderChange:Boolean;
		/**连线集合*/
        [Bindable]
        private var _linkDataProvider:ArrayCollection;
        private var _linkDataProviderChange:Boolean;
		/**节点布局*/
		[Bindable]
		public var nodeLayout:BaseLayoutFactory = new RandomFactory();
		
		
        public function TopoGraph() {
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
			var nodes:ArrayCollection = ArrayCollection(_nodeDataProvider);
			for(var i:int=0;i<nodes.length;i++){
				var node:Node = Node(nodes.getItemAt(i));
				this.addElement(node);
			}
		}
        private function mouseDown(event:MouseEvent):void {
            Alert.show("topo")
        }

        public function get nodeDataProvider():ArrayCollection {
            return _nodeDataProvider;
        }

        public function set nodeDataProvider(value:ArrayCollection):void {
            if(_nodeDataProvider != value || (value != null && value.length != _nodeDataProvider.length)) {
                _nodeDataProviderChange = true;
                _nodeDataProvider = value;
                invalidateProperties();
            }
        }

        public function get linkDataProvider():ArrayCollection {
            return _linkDataProvider;
        }

        public function set linkDataProvider(value:ArrayCollection):void {
            if(_linkDataProvider != value || (value != null && value.length != _linkDataProvider.length)) {
                _linkDataProviderChange = true;
                _linkDataProvider = value;
                invalidateProperties();
            }
        }
    }

}
