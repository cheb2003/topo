
package my.ui.topo {
	import flash.geom.Point;
	
	import my.ui.topo.layout.BaseLayoutFactory;
	import my.ui.topo.skins.DefaultNodeSkin;

    [SkinState("normal")]
    public class Node extends Renderer {
        public function Node() {
            super();
            setStyle("skinClass", DefaultNodeSkin);
        }
	
		public function getCenterPoint():Point{
			return new Point(this.x+this.width/2, this.y+this.height/2);
		}
		
		public function getCheckRepeatDistance():Number{
			return BaseLayoutFactory.getDistance(new Point(this.x,this.y), getCenterPoint());
		}
    }
}
