
package my.ui.topo {
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import my.ui.topo.layout.BaseLayoutFactory;
	import my.ui.topo.skins.DefaultNodeSkin;

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
        public var topoGraph:TopoGraph;
        public function Node() {
            super();
            setStyle("skinClass", DefaultNodeSkin);
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);

        }

        private function mouseUpHandler(event:MouseEvent):void {
            _isMouseDown = false;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler)
            event.stopPropagation();
        }

        private function mouseOutHandler(event:MouseEvent):void {
            _isMouseOver = false;
            invalidateSkinState()
            event.stopPropagation();
        }

        private function mouseOverHandler(event:MouseEvent):void {
            if(!_isMouseOver) {
                _isMouseOver = true;
                invalidateSkinState()
            }
            event.stopPropagation();
        }

        private function mouseDownHandler(event:MouseEvent):void {
            _isMouseDown = true;
            topoGraph.selectedNode = this;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
            topoGraph.lastMovePoint = new Point(event.stageX, event.stageY);
            event.stopPropagation();
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

        override protected function getCurrentSkinState():String {
            if(_isMouseOver){
                return "mouseOver";
            } else {
                return "normal";
            }
        }
    }
}
