/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {
    import com.greensock.TweenLite;
    
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLVariables;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.core.FlexGlobals;
    import mx.graphics.RadialGradient;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import my.ui.topo.data.DataAnalyzer;
    import my.ui.topo.event.AdjustComplateEvent;
    import my.ui.topo.layout.GraphLayout;
    import my.ui.topo.layout.olive.OliveLayout;
    import my.ui.topo.layout.radial.RadialLayout;
    import my.ui.topo.layout.randomlayout.RandomLayout;
    import my.ui.topo.skins.DefaultTopoSkin;
    
    import spark.components.Group;
    import spark.components.Image;
    import spark.components.SkinnableContainer;
    import spark.core.SpriteVisualElement;
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;
	
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
        [Embed('/my/ui/topo/asserts/loading.gif')]
        public static const loading:Class;
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
        //服务端地址
        public var SERVICE_PATH:String="THUMTSAN001.json";
		public var SERVICE_PATH2:String = "";
		public var SERVICE_PATH3:String = "";
        public var rid:String="";
		public var rid1:String = "";
		public var form:String="";
		public var to:String="";
//		private var SERVICE_URL:String = "http://127.0.0.1:8080/TestWebData/THUMTSAN001.json";
//		private var SERVICE_URL1:String = "http://localhost:8080/TestWebData/THUMTSAL003.json";
		//本地测试用
		private var SERVICE_URL:String = "THUMTSAN001.json";
		private var SERVICE_URL1:String = "THUMTSAL003.json";
        //是否开启拖拽模式
        public var isMoving:Boolean = false;

        public static const RANDOM_LAYOUT:String = "random";
        public static const OLIVE_LAYOUT:String = "olive";
        public static const RADIAL_LAYOUT:String = "radial";
        public var current_layout:String = RANDOM_LAYOUT;
        public var loading:SpriteVisualElement;

		/**
		 * 初始化构造函数
		 * 
		 */
        public function TopoGraph() {
            super();
            setStyle("skinClass", DefaultTopoSkin);
			//callLater(performGraphLayout);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler,false,0,true);
			addEventListener(AdjustComplateEvent.NODE_ADJUST_COMPLATE,addLinks,false,0,true);
//			service.url = SERVICE_URL;
			this.addElement(g);
        }

		/**
		 * 加载数据，用于图2
		 * 
		 */
		public function loadData2(form:String,to:String):void
		{
			showLoading(true);
			service.addEventListener(ResultEvent.RESULT,loadComplateHandle);
			var params:URLVariables = new URLVariables();
			params.form = encodeURIComponent(form);
			params.to = encodeURIComponent(to);
			service.send(params);
		}
		
		/**
		 * 加载数据，用于图1，图3
		 * 
		 */
		public function loadData(id:String):void{
            showLoading(true);
			service.addEventListener(ResultEvent.RESULT,loadComplateHandle);
			var params:URLVariables = new URLVariables();
			params.rid = encodeURIComponent(id);
			service.send(params);
		}
		
		/**
		 * 加载数据完成，回调方法。用于图1，图3
		 * 
		 */
		private function loadComplateHandle(evt:ResultEvent):void{
			var data:Object = evt.result;
			var str:String = data.toString();
			if (str==null || str=="" || str.length<1)
				return;
			var reg:RegExp = new RegExp("'","gm");
			str = str.replace(reg,'"');
			var begin:int = str.indexOf('nodes":[');
			if (begin<0)
				begin = str.indexOf("nodes':[");
			if (begin<0){
				Alert.show("数据加载错误");
				return;
			}
			begin += 'nodes":'.length;
			var end:int = str.indexOf('"links":[');
			if (end<0)
				end = str.indexOf("'links':[");
			if (end<0){
				Alert.show("数据加载错误");
				return;
			}
			var str1:String = str.substring(begin,end);
			
			nodeDataProvider = DataAnalyzer.getNodeList(str1);
			begin = end+'"links":'.length;
			end = str.length-1;
			str1 = str.substring(begin,end);
			linkDataProvider = DataAnalyzer.getLinkList(str1,nodeDataProvider.toArray());
            showLoading(false);
            if(nodeLayout is OliveLayout)
                OliveLayout(nodeLayout).paths = DataAnalyzer.analysePath(nodeDataProvider, linkDataProvider);
			performGraphLayout();
			if (!nodeLayout){
				if (nodeLayout is RandomLayout)
					nodeLayout = new RandomLayout();
				else if (nodeLayout is RadialLayout)
					nodeLayout = new RadialLayout();
			}
			nodeLayout.performLayout();
		}

		/**
		 * 显示/隐藏加载动画
		 * 
		 */
        public function showLoading(flag:Boolean):void{
			loading.x = (this.x+this.width)/2;
			loading.y = (this.y+this.height)/2;
			loading.visible = flag;
            loading.includeInLayout = flag;
			
        }

		/**
		 * 放大
		 * 
		 */
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
		
		/**
		 * 缩小
		 * 
		 */
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
		
		/**
		 * 监听鼠标滚轮，处理放大缩小
		 * 
		 */
        private function mouseWheelHandler(event:MouseEvent):void {
			if (event.delta>0){
				zoomIn();
			}else if (event.delta<0){
				zoomOut();				
			}
        }
		
		/**
		 * 计算布局中心点
		 * 
		 */
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
		}

		/**
		 * 添加Node对象
		 * 
		 */
        public function addNode(node:Node):void{
            g.addElement(node);
        }

		/**
		 * 添加Link对象
		 * 
		 */
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
                linkTip.x = link.linkDecoration.x - 30
                linkTip.y = link.linkDecoration.y - 55
                link.linkDecoration.addEventListener("xChanged",linkTip.xChanged,false,0,false)
                link.linkDecoration.addEventListener("yChanged",linkTip.yChanged,false,0,false)
                link.linkDecoration.linkTip = linkTip
                g.addElement(linkTip)
			}
		}
		
		/**
		 * 移动节点位置
		 */
        private var delay:Number = 1;
        public function resetDelayAnimationFactor():void{
            delay = 1;
        }
		/**
		 * 移动节点（有缓动效果）
		 * 
		 */
		public function moveNode(node:Node, nodeX:Number, nodeY:Number):void {
			TweenLite.delayedCall(delay,moveNode1, [node, nodeX,nodeY]);
            delay += 0.1;
		}
		/**
		 * 移动节点（无缓动效果）
		 * 
		 */
        private function moveNode1(node:Node, nodeX:Number, nodeY:Number):void {
            TweenLite.to(node,1.5,{x:nodeX,y:nodeY});
        }
		
		/**
		 * 移除节点（缓动）
		 * 
		 */
		public function moveOut(node:Node, nodeX:Number, nodeY:Number, isLast:Boolean,loadId:String):void
		{

//			moveOut1(node,nodeX,nodeY,isLast);
            TweenLite.delayedCall(delay,moveOut1, [node, nodeX,nodeY,isLast,loadId]);
			trace(delay);
			if (delay<2)
            delay += 0.05;

//			g.removeElement(node);
		}
		/**
		 * 移除节点（无缓动）
		 * 
		 */
        private function moveOut1(node:Node, nodeX:Number, nodeY:Number, isLast:Boolean,loadId:String):void{
            TweenLite.to(node,1.5,{x:nodeX,y:nodeY,onComplete:testFuncabc,onCompleteParams:[node,isLast,loadId]});
        }
		
		/**
		 * 移除完毕后回调函数，从新加载拓扑图
		 * 
		 */
		private function testFuncabc(node:Node, isLast:Boolean,loadId):void
		{
			g.removeElement(node);
			if (isLast) {
                if(current_layout == TopoGraph.RANDOM_LAYOUT)
                    showCoAuthorGraph(loadId);
                else if(current_layout == TopoGraph.OLIVE_LAYOUT)
                    showCoAuthorPath(form,to);
                else if(current_layout == TopoGraph.RADIAL_LAYOUT)
                    showCitaionGraph(node.rid);
            }
		}
		/**
		 * 将node移动到顶层
		 */ 
		public function bringToFront(node:Node):void {
			node.depth = int.MAX_VALUE;
		}
		
		/**
		 * 节点拖拽方法
		 * 
		 */
        private function mouseDownHandler(event:MouseEvent):void {
            event.stopPropagation();

            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);

            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
            lastMovePoint = new Point(event.stageX, event.stageY);
        }

		/**
		 * 节点拖拽方法，处理释放拖拽
		 * 
		 */
        private function mouseUpHandler(event:MouseEvent):void {
            event.stopPropagation();
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP,mouseMoveHandler)
        }

		/**
		 * 监听拖拽移动
		 * 
		 */
        private function mouseMoveHandler(event:MouseEvent):void {
            contentGroup.move(contentGroup.x + (event.stageX - _lastMovePoint.x), contentGroup.y + (event.stageY - _lastMovePoint.y));
            //_selectedNode.x = _selectedNode.x + (newPoint.x - _lastMovePoint.x);
            //_selectedNode.y = _selectedNode.y + (newPoint.y - _lastMovePoint.y);
            _lastMovePoint.x = event.stageX;
            _lastMovePoint.y = event.stageY;
        }

		/**
		 * 播放节点移动动画
		 * 
		 */
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

		/**
		 * 监听属性变更，通知界面重绘
		 * 
		 */
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

		/**
		 * 移动选中节点
		 * 
		 */
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

		/**
		 * 整体大小还原，居中
		 * 
		 */
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
		
		/**
		 * 移除所有节点
		 * 
		 */
		public function removeAllNode(id:String):void
		{
            resetDelayAnimationFactor()
			var p:Point = getCenterPoint();
			if (linkDataProvider.length>30){
				for (var j:int=0; j<linkDataProvider.length; j++){
					var link:Link = linkDataProvider.getItemAt(j) as Link;
					g.removeElement(link);
				}
			}

			for (var i:int=0; i<nodeDataProvider.length; i++){
				var node:Node = nodeDataProvider.getItemAt(i) as Node;
				if (node.isBase){
					g.removeElement(node);
					continue;
				}
				if (node.x <= p.x){
					if (node.y <= p.y)
						moveOut(node,this.x-node.width,this.y-node.height,i==nodeDataProvider.length-1,id)
					else
						moveOut(node,this.x-node.width, this.y+this.height+node.height,i==nodeDataProvider.length-1,id);
				}else{
					if (node.y <= p.y)
						moveOut(node, this.x+this.width+node.width, this.y-node.height,i==nodeDataProvider.length-1,id);
					else
						moveOut(node, this.x+this.width+node.width,this.y+this.height+node.height,i==nodeDataProvider.length-1,id);
				}
			}
		}
		
		private var service:HTTPService = new HTTPService();

		/**
		 * 请求图2数据
		 * 
		 */
		public function requestData2(url:String,form:String,to:String):void
		{
			service.url = url;
			loadData2(form,to);
		}
			
        /**
         * 请求数据
         * @param id
         */
		public function requestData(url:String,id:String):void{
			service.url = url;
			loadData(id);
		}

		/**
		 * 获取居中节点
		 * 
		 */
		public function getBasePoint():Point{
			for (var i:int=0; i<nodeDataProvider.length; i++){
				var node:Node = nodeDataProvider.getItemAt(i) as Node;
				if (node.isBase){
					return getCenterPoint();
				}
			}
			return null;
		}

		/**
		 * 清除所有展示对象
		 * 
		 */
        public function clearCanvas():void{
            g.removeAllElements();
            nodeDataProvider = null;
            linkDataProvider = null;
        }

		/**
		 * 加载CoAuthor图
		 * 
		 */
        public function showCoAuthorGraph(id:String=""):void{
            clearCanvas();
            current_layout = TopoGraph.RANDOM_LAYOUT;
            nodeLayout = new RandomLayout();
            requestData(SERVICE_PATH,id);
        }

		/**
		 * 加载CoAuthorPath图
		 * 
		 */
        public function showCoAuthorPath(form,to):void{
            clearCanvas();
            current_layout = TopoGraph.OLIVE_LAYOUT;
            nodeLayout = new OliveLayout();
			requestData2(SERVICE_PATH2,form,to);
        }

		/**
		 * 加载CitationGraph图
		 * 
		 */
        public function showCitaionGraph(id:String=""):void{ 
            clearCanvas();
			current_layout = TopoGraph.RADIAL_LAYOUT;
			nodeLayout = new RadialLayout();
			requestData(SERVICE_PATH3,id);
        }
    }

}
