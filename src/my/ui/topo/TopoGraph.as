/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {



    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import mx.collections.ArrayCollection;
    
    import my.ui.topo.layout.BaseLayoutFactory;
    import my.ui.topo.layout.GraphLayout;
    import my.ui.topo.layout.basic.StraightLayout;
    import my.ui.topo.layout.randomlayout.RandomFactory;
    import my.ui.topo.layout.randomlayout.RandomLayout;
import my.ui.topo.skins.DefaultTopoSkin;

import spark.components.SkinnableContainer;
    import spark.skins.spark.SkinnableContainerSkin;

	[SkinState("normal")]
    public class TopoGraph extends SkinnableContainer {
		
        [Bindable]
        private var _nodeDataProvider:ArrayCollection;
        private var _nodeDataProviderChange:Boolean;
        private var _lastMovePoint:Point;
		/**连线集合*/
        [Bindable]
        private var _linkDataProvider:ArrayCollection;
        private var _linkDataProviderChange:Boolean;
		/**节点布局*/
		[Bindable]
		public var nodeLayout:GraphLayout;
		/**连线布局*/
		[Bindable]
		public var linkLayout:GraphLayout;
		/**当前选中节点*/
		private var _selectedNode:Node;
		
		
        public function TopoGraph() {
            super();
            setStyle("skinClass", DefaultTopoSkin);
			callLater(performGraphLayout);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
        }
		
		/**
		 * 执行布局算法
		 */ 
		public function performGraphLayout():void {
			if(nodeLayout==null){
				nodeLayout = new RandomLayout();
			}
			nodeLayout.layoutRegion = new Rectangle(0, 0, this.width, this.height);
			nodeLayout.topoGraph = this;
//			if(linkLayout==null){
//				linkLayout = new StraightLayout();
//			}
//			linkLayout.topoGraph = this;
			for(var i:int=0;i<nodeDataProvider.length;i++){
				var node:Node = Node(nodeDataProvider.getItemAt(i));
				this.addElement(node);
			}
			for(var j:int=0;j<linkDataProvider.length;j++){
				var link:Link = Link(linkDataProvider.getItemAt(j));
				this.addElement(link);
			}
		}
		
		/**
		 * 将node移动到顶层
		 */ 
		public function bringToFront(node:Node):void {
			node.depth = int.MAX_VALUE;
		}
		
        private function mouseDownHandler(event:MouseEvent):void {

        }

		public function get selectedNode():Node
		{
			return _selectedNode;
		}
		
		public function set selectedNode(value:Node):void
		{
			if(value!=null&&selectedNode!=value){
                if(_selectedNode != null) {
                    _selectedNode.depth = Math.abs(Math.random());
                }
				_selectedNode = value;
				_selectedNode.depth = int.MAX_VALUE;

				//invalidateProperties();
			}
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

        override protected function commitProperties():void {
            super.commitProperties();
            if(_nodeDataProviderChange) {
                _nodeDataProviderChange = false;
                for each(var node:Node in _nodeDataProvider) {
                    node.topoGraph = this;
                }
            }
            if(_linkDataProviderChange) {
                _linkDataProviderChange = false;
            }
        }

        public function moveSelectedNode(newPoint:Point):void {
            _selectedNode.move(_selectedNode.x + (newPoint.x - _lastMovePoint.x), _selectedNode.y + (newPoint.y - _lastMovePoint.y));
            //_selectedNode.x = _selectedNode.x + (newPoint.x - _lastMovePoint.x);
            //_selectedNode.y = _selectedNode.y + (newPoint.y - _lastMovePoint.y);
            _lastMovePoint = newPoint;
        }

        function set lastMovePoint(value:Point):void {
            _lastMovePoint = value;
        }
    }

}
