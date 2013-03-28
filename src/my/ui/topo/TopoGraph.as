/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {
    import com.greensock.TweenLite;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import mx.collections.ArrayCollection;
    
    import my.ui.topo.event.AdjustComplateEvent;
    import my.ui.topo.layout.GraphLayout;
    import my.ui.topo.layout.basic.StraightLayout;
    import my.ui.topo.layout.randomlayout.RandomFactory;
    import my.ui.topo.layout.randomlayout.RandomLayout;
    import my.ui.topo.skins.DefaultTopoSkin;
    
    import org.un.cava.birdeye.ravis.graphLayout.visual.VisualGraph;
    import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
    import org.un.cava.birdeye.ravis.utils.geom.PoincareIsometry;
    
    import spark.components.Group;
    import spark.components.SkinnableContainer;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;
	
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
		private var _nodeLayout:GraphLayout;
		/**连线布局*/
		private var _linkLayout:GraphLayout;
		/**当前选中节点*/
		private var _selectedNode:Node;
		private var g:Group = new Group();
				
        public function TopoGraph() {
            super();
            setStyle("skinClass", DefaultTopoSkin);
			callLater(performGraphLayout);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler,false,0,true)
			addEventListener(AdjustComplateEvent.NODE_ADJUST_COMPLATE,addLinks,false,0,true);
			this.addElement(g);
        }

        private function mouseWheelHandler(event:MouseEvent):void {
			if (event.delta>0){
				if (g.scaleX<1.4){
					g.scaleX = g.scaleX+0.1;
					g.scaleY = g.scaleY+0.1;
					
					contentGroup.x = contentGroup.x - (contentGroup.width*0.1)/2;
					contentGroup.y = contentGroup.y - (contentGroup.height*0.1)/2;
				}
			}else if (event.delta<0){
				if (g.scaleX>0.8){
					g.scaleX = g.scaleX-0.1;
					g.scaleY = g.scaleY-0.1;
					
					contentGroup.x = contentGroup.x + (contentGroup.width*0.1)/2;
					contentGroup.y = contentGroup.y + (contentGroup.height*0.1)/2;
				}
			}
			
//			scaleAtPoint(contentGroup,new Point(contentGroup.width/2, contentGroup.height/2));
//            if(event.delta > 0 && contentGroup.scaleX > 2) {
//                return
//            }
//            if(event.delta < 0 && contentGroup.scaleX < .5) {
//                return
//            }
//            var a:Animate = new Animate(contentGroup);
//            var ve:Vector.<MotionPath> = new Vector.<MotionPath>();
//            var aSX:SimpleMotionPath;
//            var aSY:SimpleMotionPath;
//
//
//            if(event.delta > 0) {
//
//                aSX = new SimpleMotionPath("scaleX",contentGroup.scaleX,contentGroup.scaleX +.3)
//                aSY = new SimpleMotionPath("scaleY",contentGroup.scaleX,contentGroup.scaleY +.3)
//            } else {
//                aSX = new SimpleMotionPath("scaleX",contentGroup.scaleX,contentGroup.scaleX -.3)
//                aSY = new SimpleMotionPath("scaleY",contentGroup.scaleX,contentGroup.scaleY -.3)
//            }
//            ve.push(aSX, aSY);
//            a.motionPaths = ve;
//            a.play();
//			scaleAtPoint(contentGroup,new Point(contentGroup.width/2, contentGroup.height/2));
        }
		
		public function getCenterPoint():Point{
			return new Point(this.x+this.width/2,this.y+this.height/2);
		}
		
		/**
		 * 执行布局算法
		 */ 
		public function performGraphLayout():void {
			if(nodeLayout==null){
				nodeLayout = new RandomLayout();
			}
			var totalWidth:Number = this.width;
			if (totalWidth==0)
				totalWidth = this.parentApplication.width * this.percentWidth/100;
			var totalHeight:Number = this.height;
			if (totalHeight==0)
				totalHeight = this.parentApplication.height * this.percentHeight/100;
			
			nodeLayout.layoutRegion = new Rectangle(0, 0, totalWidth, totalHeight);
			nodeLayout.topoGraph = this;
			
			for(var i:int=0;i<nodeDataProvider.length;i++){
				var node:Node = Node(nodeDataProvider.getItemAt(i));
				var p:Point = RandomFactory.getRandomPoint(new Rectangle(0,0,totalWidth,totalHeight));
				g.addElement(node);
				node.x = p.x;
				node.y = p.y;
			}
			
//			nodeLayout.performLayout();
		}
		
		private function addLinks(evt:AdjustComplateEvent):void
		{
//			if(linkLayout==null){
//				linkLayout = new StraightLayout();
//			}
			
			for(var j:int=0;j<linkDataProvider.length;j++){
				var link:Link = Link(linkDataProvider.getItemAt(j));
				g.addElement(link);
			}
		}
		
		/**
		 * 移动节点位置
		 */ 
		public function moveNode(node:Node, nodeX:Number, nodeY:Number):void {
			TweenLite.to(node,1.5,{x:nodeX,y:nodeY});
		}
		
		/**
		 * 将node移动到顶层
		 */ 
		public function bringToFront(node:Node):void {
			node.depth = int.MAX_VALUE;
		}
		
        private function mouseDownHandler(event:MouseEvent):void {
            event.stopPropagation();

            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);

            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
            lastMovePoint = new Point(event.stageX, event.stageY);
        }

        private function mouseUpHandler(event:MouseEvent):void {
            event.stopPropagation();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP,mouseMoveHandler)
        }

        private function mouseMoveHandler(event:MouseEvent):void {
            contentGroup.move(contentGroup.x + (event.stageX - _lastMovePoint.x), contentGroup.y + (event.stageY - _lastMovePoint.y));
            //_selectedNode.x = _selectedNode.x + (newPoint.x - _lastMovePoint.x);
            //_selectedNode.y = _selectedNode.y + (newPoint.y - _lastMovePoint.y);
            _lastMovePoint.x = event.stageX;
            _lastMovePoint.y = event.stageY;
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

       public function set lastMovePoint(value:Point):void {
            _lastMovePoint = value;
        }

		[Bindable]
		public function get nodeLayout():GraphLayout
		{
			return _nodeLayout;
		}

		public function set nodeLayout(value:GraphLayout):void
		{
			_nodeLayout = value;
		}

		[Bindable]
		public function get linkLayout():GraphLayout
		{
			return _linkLayout;
		}

		public function set linkLayout(value:GraphLayout):void
		{
			_linkLayout = value;
		}

        public function fit():void{
            var a:Animate = new Animate(contentGroup);
            var ve:Vector.<MotionPath> = new Vector.<MotionPath>();
            var aSX:SimpleMotionPath;
            var aSY:SimpleMotionPath;
            aSX = new SimpleMotionPath("x",contentGroup.x,0)
            aSY = new SimpleMotionPath("y",contentGroup.y,0)
            ve.push(aSX, aSY);
            a.motionPaths = ve;
            a.play()
        }
    }

}
