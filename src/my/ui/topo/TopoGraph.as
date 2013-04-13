/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {
    import com.greensock.TweenLite;
    import com.greensock.events.TweenEvent;
    import com.greensock.plugins.OnChangeRatioPlugin;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLVariables;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.FlexEvent;
import mx.messaging.errors.NoChannelAvailableError;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import my.ui.topo.data.DataAnalyzer;
    import my.ui.topo.data.TestData;
    import my.ui.topo.event.AdjustComplateEvent;
    import my.ui.topo.layout.GraphLayout;
    import my.ui.topo.layout.basic.StraightLayout;
import my.ui.topo.layout.olive.OliveLayout;
import my.ui.topo.layout.randomlayout.RandomFactory;
    import my.ui.topo.layout.randomlayout.RandomLayout;
    import my.ui.topo.skins.DefaultTopoSkin;

import spark.components.ButtonBar;

import spark.components.Group;
    import spark.components.SkinnableContainer;
    import spark.components.supportClasses.SkinnableComponent;
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;
    import spark.primitives.Line;
	
    [SkinState("normal")]
    public class TopoGraph extends SkinnableContainer {


        [Embed('/my/ui/topo/asserts/min1.jpg')]
        public static const min1:Class;
        [Embed('/my/ui/topo/asserts/min2.jpg')]
        public static const min2:Class;
        [Embed('/my/ui/topo/asserts/plus1.jpg')]
        public static const plus1:Class;
        [Embed('/my/ui/topo/asserts/plus2.jpg')]
        public static const plus2:Class;
        [Embed('/my/ui/topo/asserts/c1.jpg')]
        public static const c1:Class;
        [Embed('/my/ui/topo/asserts/c2.jpg')]
        public static const c2:Class;
        [Embed('/my/ui/topo/asserts/c11.jpg')]
        public static const c11:Class;
        [Embed('/my/ui/topo/asserts/c12.jpg')]
        public static const c12:Class;
        [Embed('/my/ui/topo/asserts/c13.jpg')]
        public static const c13:Class;
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
		private var SERVICE_URL:String = "";
        //是否开启拖拽模式
        public var isMoving:Boolean = false;

        public static const RANDOM_LAYOUT:String = "random";
        public static const OLIVE_LAYOUT:String = "olive";
        public var current_layout:String = RANDOM_LAYOUT;
		
        public function TopoGraph() {
            super();
            setStyle("skinClass", DefaultTopoSkin);
			callLater(performGraphLayout);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler,false,0,true);
			addEventListener(AdjustComplateEvent.NODE_ADJUST_COMPLATE,addLinks,false,0,true);
			service.url = SERVICE_URL;
			this.addElement(g);
        }

		public function loadData(id:String):void{
			service.addEventListener(ResultEvent.RESULT,loadComplateHandle);
			var params:URLVariables = new URLVariables();
			params.nodeId = encodeURIComponent(id);
			service.send(params);
		}
		
		private function loadComplateHandle(evt:ResultEvent):void{
			var data:Object = evt.result;

			nodeDataProvider = DataAnalyzer.getNodeList(data.nodeList.toString());
			linkDataProvider = DataAnalyzer.getLinkList(data.linkList.toString(), nodeDataProvider.toArray());
			performGraphLayout();
		}

		public function zoomOut():void
		{
			if (g.scaleX>0.8){
				var trans:Matrix = new Matrix();
				trans.translate(-(width/2), -(height/2));
				trans.scale(g.scaleX-0.1,g.scaleY-0.1); 
				trans.translate(width/2, height/2);
				g.transform.matrix = trans;
			}
		}
		
		public function zoomIn():void
		{
			if (g.scaleX<1.4){
				var trans:Matrix = new Matrix();
				trans.translate(-(width/2), -(height/2));
				trans.scale(g.scaleX+0.1,g.scaleY+0.1); 
				trans.translate(width/2, height/2);
				g.transform.matrix = trans;
			}
		}
		
        private function mouseWheelHandler(event:MouseEvent):void {
			if (event.delta>0){
				zoomIn();
			}else if (event.delta<0){
				zoomOut();				
			}
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
			nodeLayout.initPosition();

//            nodeLayout.addEventListener(FlexEvent.CREATION_COMPLETE, function(evt:FlexEvent):void{
//                GraphLayout(evt.target).performLayout();
//            });
//			for(var i:int=0;i<nodeDataProvider.length;i++){
//				var node:Node = Node(nodeDataProvider.getItemAt(i));
//				var p:Point = RandomFactory.getRandomPoint(new Rectangle(0,0,totalWidth,totalHeight));
//				g.addElement(node);
//				if (node.isBase)
//					node.depth = int.MAX_VALUE;
//				node.x = p.x;
//				node.y = p.y;
//			}
		}

        public function addNode(node:Node):void{
            g.addElement(node);
        }

		private function addLinks(evt:AdjustComplateEvent):void
		{

            var linkTip:LinkTip
			for(var j:int=0;j<linkDataProvider.length;j++){
				var link:Link = Link(linkDataProvider.getItemAt(j));
                link.topoGraph = this;
				g.addElement(link);
                linkTip = new LinkTip()
                linkTip.linkInfo = link.linkInfo
                linkTip.linkLine = link.linkLine
                linkTip.linkName = link.linkName
                linkTip.label = link.label
                link.linkDecoration.addEventListener("xChanged",linkTip.xChanged,false,0,false)
                link.linkDecoration.addEventListener("yChanged",linkTip.yChanged,false,0,false)
                link.linkDecoration.linkTip = linkTip
                g.addElement(linkTip)
			}
		}
		
		/**
		 * 移动节点位置
		 */ 
		public function moveNode(node:Node, nodeX:Number, nodeY:Number):void {
			TweenLite.to(node,1.5,{x:nodeX,y:nodeY});
		}
		
		public function moveOut(node:Node, nodeX:Number, nodeY:Number, isLast:Boolean):void
		{
			TweenLite.to(node,1.5,{x:nodeX,y:nodeY,onComplete:testFuncabc,onCompleteParams:[node,isLast]});
//			g.removeElement(node);
		}
		
		private function testFuncabc(node:Node, isLast:Boolean):void
		{
			g.removeElement(node);
			if (isLast)
                requestData("");
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

        public function moveBy(x:Number,y:Number):void{
            var a:Animate = new Animate(contentGroup);
            var ve:Vector.<MotionPath> = new Vector.<MotionPath>();
            var cgX:SimpleMotionPath;
            var cgY:SimpleMotionPath;
            cgX = new SimpleMotionPath("x",contentGroup.x,contentGroup.x + x)
            cgY = new SimpleMotionPath("y",contentGroup.y,contentGroup.y + y)
            ve.push(cgX, cgY);
            a.motionPaths = ve;
            a.play()
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
//			g.scaleX = 1;
//			g.scaleY = 1;
			var trans:Matrix = new Matrix();
			trans.translate(-(width/2), -(height/2));
			trans.scale(1,1); 
			trans.translate(width/2, height/2);
			g.transform.matrix = trans;
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
		
		public function removeAllNode(id:String):void
		{
			var p:Point = getCenterPoint();
			for (var j:int=0; j<linkDataProvider.length; j++){
				var link:Link = linkDataProvider.getItemAt(j) as Link;
				g.removeElement(link);
			}

			for (var i:int=0; i<nodeDataProvider.length; i++){
				var node:Node = nodeDataProvider.getItemAt(i) as Node;
				if (node.isBase){
					g.removeElement(node);
					continue;
				}
				if (node.x <= p.x){
					if (node.y <= p.y)
						moveOut(node,this.x-node.width,this.y-node.height,i==nodeDataProvider.length-1)
					else
						moveOut(node,this.x-node.width, this.y+this.height+node.height,i==nodeDataProvider.length-1);
				}else{
					if (node.y <= p.y)
						moveOut(node, this.x+this.width+node.width, this.y-node.height,i==nodeDataProvider.length-1);
					else
						moveOut(node, this.x+this.width+node.width,this.y+this.height+node.height,i==nodeDataProvider.length-1);
				}
			}
		}
		
		private var service:HTTPService = new HTTPService();

        /**
         * 请求数据
         * @param id
         */
		public function requestData(id:String):void{
			if (id == TestData.RANDOM_DATA)//this.parentApplication.isTest)
			{
				nodeDataProvider = DataAnalyzer.getNodeList(TestData.testNodeJsonStr);
				linkDataProvider = DataAnalyzer.getLinkList(TestData.testLinkJsonStr,nodeDataProvider.toArray());
			}else if (id == TestData.OLIVE_DATA){
                nodeDataProvider = DataAnalyzer.getNodeList(TestData.olive_nodes);
                linkDataProvider = DataAnalyzer.getLinkList(TestData.olive_lines,nodeDataProvider.toArray());
                if(nodeLayout==null)
                    nodeLayout = new OliveLayout();
                OliveLayout(nodeLayout).paths = DataAnalyzer.analysePath(nodeDataProvider, linkDataProvider);
            }else
				loadData(id);
		}

		public function getBasePoint():Point{
			for (var i:int=0; i<nodeDataProvider.length; i++){
				var node:Node = nodeDataProvider.getItemAt(i) as Node;
				if (node.isBase){
					return getCenterPoint();
				}
			}
			return null;
		}

        public function clearCanvas():void{
            g.removeAllElements();
            nodeDataProvider = null;
            linkDataProvider = null;
        }

        public function showCoAuthorGraph():void{
            clearCanvas();
            current_layout = TopoGraph.RANDOM_LAYOUT;
            requestData(TestData.RANDOM_DATA);
            nodeLayout = new RandomLayout();
            performGraphLayout();
            nodeLayout.performLayout();
        }

        public function showCoAuthorPath():void{
            clearCanvas();
            current_layout = TopoGraph.OLIVE_LAYOUT;
            nodeLayout = new OliveLayout();
            requestData(TestData.OLIVE_DATA);
            performGraphLayout();
            nodeLayout.performLayout();
        }

        public function showCitaionGraph():void{
            clearCanvas();
        }
    }

}
