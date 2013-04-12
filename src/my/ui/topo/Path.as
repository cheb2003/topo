/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-12
 * Time: 下午11:29
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {
import mx.collections.ArrayCollection;

public class Path {
        private var nodes:ArrayCollection = new ArrayCollection();

        public function Path() {
        }

        public function addNode(node:Node):void{
            nodes.addItem(node);
        }

        public function getLastNode():Node{
            return Node(nodes.getItemAt(nodes.length - 1))
        }

        public function get length():int{
            return nodes.length
        }
    }
}
