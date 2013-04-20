/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-20
 * Time: 下午4:38
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.layout.radial {
import my.ui.topo.Node;
import my.ui.topo.layout.GraphLayout;

public class RadialLayout extends GraphLayout {
    public function RadialLayout() {
        super();
    }

    public override function initPosition():void{
        for(var i:int=0;i<topoGraph.nodeDataProvider.length;i++){
            var node:Node = Node(topoGraph.nodeDataProvider.getItemAt(i));
            topoGraph.addNode(node);
            if (node.isBase)
                node.depth = int.MAX_VALUE;
            //TODO change the initial position
            node.x = 0;
            node.y = 0;
        }
    }

    protected override function layout():void{

    }
}
}
