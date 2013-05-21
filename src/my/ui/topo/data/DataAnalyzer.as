package my.ui.topo.data
{
	import com.adobe.serialization.json.JSON;

    import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
    import mx.collections.Sort;
    import mx.collections.SortField;
import mx.controls.Alert;

import my.ui.topo.Link;
	import my.ui.topo.Node;
    import my.ui.topo.Path;

	/**
	 * 用于解析数据
	 * 
	 */
public class DataAnalyzer
	{
        //标示基础节点对象，用于计算连线是否是直接/间接关系
        private static var baseNode:Node;
        /**标记referNode，用于Co-author Path图*/
        private static var referNode:Node;

		/**
		 * 默认构造函数
		 * 
		 */
		public function DataAnalyzer()
		{
		}
		
		/**
		 * 解析Node对象，返回集合
		 * 
		 */
		public static function getNodeList(str:String):ArrayCollection{
			var arr:Array = JSON.decode(str) as Array;
			var result:ArrayList = new ArrayList();
			for (var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				var node:Node = new Node();
				node.labelName = obj.labelName;
				node.info = obj.info;
				node.id = obj.id;
                node.rid = obj.rid;
				if (obj.isBase=="true" || obj.isBase=="1"){
					node.isBase = true;
                    baseNode = node;
                }
                if (obj.isRefer=="true" || obj.isRefer=="1"){
                    node.isRefer = true;
                    referNode = node;
                }else{
					node.isRefer = false;
				}
				if (obj.imageUrl!=null && obj.imageUrl.toString().length>0)
					node.imageSource = obj.imageUrl;
				if (obj.shadowColor!=null && obj.shadowColor.toString()!="")
					node.shadowColor = obj.shadowColor;
				else{
					if (node.isBase)
						node.shadowColor = 0xFF0000;
					else
						node.shadowColor = 0x3333FF;
				}
				node.isClick = obj.isClick;
				result.addItem(node);
			}
			return new ArrayCollection(result.toArray());
		}
		
		/**
		 * 解析Link对象，返回集合
		 * 
		 */
		public static function getLinkList(str:String, nodeList:Array):ArrayCollection{
			var arr:Array = JSON.decode(str) as Array;
			var result:ArrayList = new ArrayList();
			for (var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				var link:Link = new Link();
				link.startNode = getNodeById(nodeList,obj.startNode);
				link.endNode = getNodeById(nodeList,obj.endNode);
                link.startNode.getOutgoingLinks().push(link);
                link.endNode.getIncomingLinks().push(link);
				if (obj.linkName==null || obj.linkName.toString().length<1)
					link.linkName = getLineName(link.startNode.labelName, link.endNode.labelName);
				link.label = obj.label;
				link.linkInfo = obj.linkInfo;
                if(link.startNode == baseNode || link.endNode == baseNode){
                    link.isDirectRelation = true;
                }else{
                    link.baseNode = baseNode;
                }
                if(link.startNode == referNode || link.endNode == referNode){
                    link.isDirectRelation = true;
                }else{
                    link.referNode = referNode;
                }
				result.addItem(link);
			}
			return new ArrayCollection(result.toArray());
		}

		/**
		 * 解析节点间path，用于图2调用
		 * 
		 */
        public static function analysePath(nodes:ArrayCollection,links:ArrayCollection):ArrayCollection{
            var pathCollection:ArrayCollection = new ArrayCollection();
            var path:Path
            var baseNode:Node
            for each (var node:Node in nodes){
                if(node.isBase) {
                    baseNode = node
                    break
                }
            }
            for each(var link:Link in links) {
                if(link.startNode == baseNode) {
                    path = new Path()
                    path.addNode(link.endNode)
                    linkPath(path,links)
                    pathCollection.addItem(path)
                }
            }
            if(pathCollection.length < 6) {
                return pathCollection;
            }
            var sort:Sort=new Sort();
            //按照ID升序排序
            sort.fields=[new SortField("length")];
            pathCollection.sort = sort
            pathCollection.refresh();
            var arr:ArrayCollection = new ArrayCollection()
            var i:int = 0
            while(i < 5) {
                arr.addItem(pathCollection.getItemAt(i));
                i++
            }
            return arr;
        }

		/**
		 * 解析LinkPath，用于图2调用
		 * 
		 */
        private static function linkPath(path:Path, links:ArrayCollection):void {
            var node:Node = path.getLastNode();
            for each(var link:Link in links) {
                if(link.startNode == node) {
                    if(link.endNode.isRefer == true) {
                        return
                    } else {
                        path.addNode(link.endNode)
                        linkPath(path,links)
                    }
                }
            }
        }
		
		/**
		 * 通过ID获取Node对象
		 * 
		 */
		private static function getNodeById(nodeList:Array, id:String):Node{
			for (var i:int=0; i<nodeList.length; i++){
				var node:Node = nodeList[i] as Node;
				if (node.id==id)
					return node;
			}
			return null;
		}
		/**
		 * 构造LineName
		 * 
		 */
		private static function getLineName(startName:String, endName:String):String{
			return startName+"-"+endName;
		}
	}
}