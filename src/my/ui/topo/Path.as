/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-12
 * Time: 下午11:29
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo {
import mx.collections.ArrayCollection;

/**
 * 路径类，用于合作路径图模型解析
 */
public class Path {
        /**
         * 路径节点集合
         */
        private var nodes:ArrayCollection = new ArrayCollection();

        public function Path() {
        }

        public function addNode(node:Node):void{
            nodes.addItem(node);
        }

        public function getNodes():ArrayCollection{
            return nodes;
        }

        public function getLastNode():Node{
            return Node(nodes.getItemAt(nodes.length - 1))
        }

        public function get length():int{
            return nodes.length
        }

}
}
