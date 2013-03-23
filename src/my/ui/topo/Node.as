
package my.ui.topo {
	import flash.geom.Point;
	
	import my.ui.topo.layout.BaseLayoutFactory;
	import my.ui.topo.skins.DefaultNodeSkin;

    [SkinState("normal")]
    [SkinState("selected")]
    [SkinState("selectedAndShowLabel")]
    public class Node extends Renderer {
        [Embed('/my/ui/topo/asserts/person.png')]
        private static const defaultImageSource:Class;

        private var _imageSource:*;

        public function set imageSource(source:*) {
            _imageSource = source;
        }
        public function get imageSource():* {
            if(_imageSource == null) {
                return defaultImageSource;
            }
            return _imageSource;
        }

        public function Node() {
            super();
            setStyle("skinClass", DefaultNodeSkin);
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
    }
}
