
package my.ui.topo {
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import my.ui.topo.layout.BaseLayoutFactory;
    import my.ui.topo.skins.DefaultNodeSkin;

	[Bindable]
    [SkinState("normal")]
    [SkinState("selected")]
    [SkinState("mouseOver")]
    [SkinState("selectedAndShowLabel")]
    public class Node extends Renderer {
        [Embed('/my/ui/topo/asserts/person.png')]
        private static const defaultImageSource:Class;
        private var _imageSource:*;
        private var _isMouseDown:Boolean;
        private var _isMouseOver:Boolean;
        
		/**输入连线集合*/
		private var _incomingLinks:Vector.<Link> = new Vector.<Link>();
		/**输出连线集合*/
		private var _outgoingLinks:Vector.<Link> = new Vector.<Link>();
		
        public var topoGraph:TopoGraph;
        public function Node() {
            super();
            setStyle("skinClass", DefaultNodeSkin);
            addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);


        }

        private function mouseUpHandler(event:MouseEvent):void {
            event.stopPropagation();
            _isMouseDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP,mouseMoveHandler)
        }

        private function rollOutHandler(event:MouseEvent):void {
            if(_isMouseDown){
                return;
            }
            event.stopPropagation();
            removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler)
            _isMouseOver = false;
            invalidateSkinState()

        }

        private function rollOverHandler(event:MouseEvent):void {
            event.stopPropagation();
            if(!_isMouseOver) {
                _isMouseOver = true;
                invalidateSkinState()
                addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
            }

        }

        private function mouseDownHandler(event:MouseEvent):void {
            event.stopPropagation();
            _isMouseDown = true;
            topoGraph.selectedNode = this;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);

            stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
            topoGraph.lastMovePoint = new Point(event.stageX, event.stageY);

        }

        private function mouseMoveHandler(event:MouseEvent):void {
            topoGraph.moveSelectedNode(new Point(event.stageX,event.stageY));
        }


        public function set imageSource(source:*) {
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
		
		public function isBase():Boolean{
			//TODO 基准点判断规则
			return false;
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

        override protected function getCurrentSkinState():String {
            if(_isMouseOver){
                return "mouseOver";
            } else {
                return "normal";
            }
        }
    }
}
