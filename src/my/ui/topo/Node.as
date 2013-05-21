
package my.ui.topo {
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.events.MoveEvent;
    
    import my.ui.topo.layout.BaseLayoutFactory;
    import my.ui.topo.skins.DefaultNodeSkin;

    /**
     * 节点图元类
     */
	[Bindable]
    [SkinState("normal")]
    [SkinState("selected")]
    [SkinState("mouseOver")]
    [SkinState("selectedAndShowLabel")]
    public class Node extends Renderer {
        [Embed('/my/ui/topo/asserts/defaultPic.png')]
        private static const defaultImageSource:Class;
        private var _imageSource:*;
        private var _isMouseDown:Boolean;
        private var _isMouseOver:Boolean;
        public var isPlaying:Boolean;
		/**输入连线集合*/
		private var _incomingLinks:Vector.<Link> = new Vector.<Link>();
		/**输出连线集合*/
		private var _outgoingLinks:Vector.<Link> = new Vector.<Link>();
        public var topoGraph:TopoGraph;
        /**是否基础节点*/
		public var isBase:Boolean = false;
        /**是否参照节点*/
        public var isRefer:Boolean = false;
		public var labelName:String = "";
		public var info:String = "";
		public var rid:String = "";
		//是否可点击后切换为中心节点，0：不可点，1：可点
		public var isClick:int = 0;
		public var shadowColor:uint;
        private const MAX_WIDTH:Number = 70;
        private const MAX_HEIGHT:Number = 80;

        public function Node() {
        	super();
            setStyle("skinClass", DefaultNodeSkin);

            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
        }

        private function mouseOverHandler(event:MouseEvent):void{
            //悬停的时候将画布选择节点置为本身，以便Node Tip能置顶显示
            if(!_isMouseDown){
                event.stopPropagation();
                if(!topoGraph.isMoving)
                    topoGraph.selectedNode = this;
            }
        }

        public function mouseUpHandler(event:MouseEvent):void {
            event.stopPropagation();
            _isMouseDown = false;
            topoGraph.isMoving = false;
			if (stage){
	            stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
	            stage.removeEventListener(MouseEvent.MOUSE_UP,mouseMoveHandler)
			}
        }

        private function rollOutHandler(event:MouseEvent):void {
            if(_isMouseDown){
                return;
            }
            event.stopPropagation();
            _isMouseOver = false;
            if(isPlaying) {
                return;
            }
            removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler)
            invalidateSkinState()
        }

        private function rollOverHandler(event:MouseEvent):void {
            event.stopPropagation();
            if(!_isMouseOver) {
                _isMouseOver = true;
                if(isPlaying) {
                    return;
                }
                invalidateSkinState()
                addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler, false, 0, true);
            }

        }

        public function mouseDownHandler(event:MouseEvent):void {
            event.stopPropagation();
            topoGraph.isMoving = true;
            _isMouseDown = true;
            topoGraph.selectedNode = this;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);

            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
            topoGraph.lastMovePoint = new Point(event.stageX, event.stageY);

        }

        private function mouseMoveHandler(event:MouseEvent):void {
            topoGraph.moveSelectedNode(new Point(event.stageX,event.stageY));
        }


        public function set imageSource(source:*):void {
            _imageSource = source;
        }
        public function get imageSource():* {
            if(_imageSource == null) {
                return defaultImageSource;
            }
            return _imageSource;
        }
	
		public function getCenterPoint():Point{
			return new Point(this.x+this.skin.width/2, this.y+this.skin.height/2);
		}
		
		public function getCheckRepeatDistance():Number{
			return BaseLayoutFactory.getDistance(new Point(this.x,this.y), getCenterPoint());
		}
		

		/**
		 *	获取输入连线集合 
		 */
		public function getIncomingLinks():Vector.<Link>
		{
			return _incomingLinks;
		}

		/**
		 * 获取输出连线集合
		 */ 
		public function getOutgoingLinks():Vector.<Link>
		{
			return _outgoingLinks;
		}

        /**
         * 获取总线集合
         * @return
         */
        public function getLinks():Vector.<Link>{
            return _incomingLinks.concat(_outgoingLinks);
        }

        /**
         * 动态计算节点宽度
         * @return
         */
        public function calcWidth():Number{
            if(isBase)
                return MAX_WIDTH;
            var linkNum:int = getLinks().length;
            switch(linkNum){
                case 1:
                    return 40;
                case 2:
                    return 45;
                case 3:
                    return 50;
                case 4:
                    return 55;
                case 5:
                    return 60;
                default :
                    return 65;
            }
        }

        /**
         * 动态计算节点高度
         * @return
         */
        public function calcHeight():Number{
            if(isBase)
                return MAX_HEIGHT;
            var linkNum:int = getLinks().length;
            switch(linkNum){
                case 1:
                    return 50;
                case 2:
                    return 55;
                case 3:
                    return 60;
                case 4:
                    return 65;
                case 5:
                    return 70;
                default :
                    return 75;
            }
        }

        override protected function getCurrentSkinState():String {
            if(_isMouseOver){
                return "mouseOver";
            } else {
                return "normal";
            }
        }
        public function getSkinState():String{
            return getCurrentSkinState();
        }
    }
}
