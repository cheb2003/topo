
package my.ui.topo {
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


    }
}
