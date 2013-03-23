/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-3-22
 * Time: 下午9:28
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {


    import spark.components.SkinnableContainer;
    import spark.skins.spark.SkinnableContainerSkin;

	[SkinState("normal")]
    public class Topo extends SkinnableContainer {
		/**节点集合*/
		protected var nodeDataProvider:Object;
		/**连线集合*/
		protected var linkDataProvider:Object;
		
		
        public function Topo() {
            super();
            setStyle("skinClass", SkinnableContainerSkin);
        }
    }

}
