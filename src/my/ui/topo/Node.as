
package my.ui.topo {
	import my.ui.topo.skins.DefaultNodeSkin;

    [SkinState("normal")]
    public class Node extends Renderer {
        public function Node() {
            super();
            setStyle("skinClass", DefaultNodeSkin);
        }

    }
}
