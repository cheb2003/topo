package my.ui.topo.data
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.sampler.getLexicalScopes;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import my.ui.topo.Link;
	import my.ui.topo.LinkLine;
	import my.ui.topo.Node;

	public class DataAnalyzer
	{
		public function DataAnalyzer()
		{
		}
		
		public static function getNodeList(str:String):ArrayCollection{
			var arr:Array = JSON.decode(str) as Array;
			var result:ArrayList = new ArrayList();
			for (var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				var node:Node = new Node();
				node.labelName = obj.labelName;
				node.info = obj.info;
				node.id = obj.id;
				if (obj.isBase=="true" || obj.isBase=="1")
					node.isBase = true;
				else
					node.isBase = false;
				if (obj.imageUrl!=null && obj.imageUrl.toString().length>0)
					node.imageSource = obj.imageUrl;
				node.isClick = obj.isClick;
				result.addItem(node);
			}
			return new ArrayCollection(result.toArray());
		}
		
		public static function getLinkList(str:String, nodeList:Array):ArrayCollection{
			var arr:Array = JSON.decode(str) as Array;
			var result:ArrayList = new ArrayList();
			for (var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				var link:Link = new Link();
				link.startNode = getNodeById(nodeList,obj.startNode);
				link.endNode = getNodeById(nodeList,obj.endNode);
<<<<<<< HEAD
				if (obj.linkName==null || obj.linkName.toString().length<1)
					link.linkName = getLineName(link.startNode.labelName, link.endNode.labelName);
				link.label = obj.label;
				link.linkInfo = obj.linkInfo;
=======
				link.linkName = getLineName(link.startNode.labelName, link.endNode.labelName);
                link.linkInfo = obj.linkInfo;
>>>>>>> f7f048e562c7b219ccabdef57ac6ee43297f3b05
				result.addItem(link);
			}
			return new ArrayCollection(result.toArray());
		}
		
		private static function getNodeById(nodeList:Array, id:String):Node{
			for (var i:int=0; i<nodeList.length; i++){
				var node:Node = nodeList[i] as Node;
				if (node.id==id)
					return node;
			}
			return null;
		}
		
		private static function getLineName(startName:String, endName:String):String{
			return startName+"-"+endName;
		}
	}
}