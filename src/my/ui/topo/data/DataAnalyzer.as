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
//		private var jsonStr:String;  
//		private var jsonObj:Object;           
//		
//		private var jsonObj2:Object;  
//		private var jsonStr2:String;  
//		
//		public static function loadData(id:String):void{
//			var v:URLVariables = new URLVariables("nodeId="+id);  
//			var r:URLRequest = new URLRequest();  
//			r.url = "";  
//			r.method = URLRequestMethod.GET;  
//			r.data = v;  
//			
//			var l:URLLoader = new URLLoader();  
//			l.load(r);  
//			l.addEventListener(Event.COMPLETE,txtCompleteHandler);
////			return null;
//		}
//		
//		private static function txtCompleteHandler(evt:Event):Object
//		{
//			var l:URLLoader = evt.target as URLLoader;  
//			var data:Object = l.data;
//			var obj:Object = new Object();
//			obj.nodeList = getNodeList(data.nodeList.toString());
//			obj.linkList = getLinkList(data.linkList.toString(), obj.nodeList);
//			return obj;
//		}
		
		public static function getNodeList(str:String):ArrayCollection{
			var arr:Array = JSON.decode(str) as Array;
			var result:ArrayList = new ArrayList();
			for (var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				var node:Node = new Node();
				node.labelName = obj.name;
				node.info = obj.info;
				node.id = obj.id;
				if (obj.isBase=="true")
					node.isBase = true;
				else
					node.isBase = false;
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
				link.linkName = getLineName(link.startNode.labelName, link.endNode.labelName);
                link.linkInfo = obj.linkInfo;
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
		
//		public static function analayzerData(str:String):Object{
//			var arr:Array = JSON.decode(str) as Array;
//			var nodeList:NodeList = new NodeList();
//			var linkDataList:LinkDataList = new LinkDataList();
//			var linkList:ArrayList = new ArrayList();
//			
//			for (var i:int=0; i<arr.length; i++){
//				var obj:Object = arr[i];
//				obj.toString().length
//				var node:Node = new Node();
//				node.labelName = obj.name;
//				node.info = obj.info;
//				node.id = obj.id;
//				if (obj.isBase=="true")
//					node.isBase = true;
//				else
//					node.isBase = false;
//				nodeList.addItem(node);
//				if (obj.relatedNodeIds==null || obj.relatedNodeIds.toString().length<1)
//					continue;
//				var s:String = obj.relatedNodeIds as String;
//				var ta:Array = s.split(",");
//				for (var j:int=0; j<ta.length; j++){
//					var id:String = ta[j] as String;
//					var ld:LinkData = new LinkData();
//					ld.startNodeId = obj.id;
//					ld.endNodeId = id;
//					linkDataList.addLink(ld);
//				}
//			}
//			
//			for (var k:int=0; k<linkDataList.length; k++){
//				var td:LinkData = linkDataList.getItemAt(k) as LinkData;
//				var link:Link = new Link();
//				link.startNode = nodeList.getNodeById(td.startNodeId);
//				link.endNode = nodeList.getNodeById(td.endNodeId);
//				link.linkName = getLineName(link.startNode.labelName, link.endNode.labelName);
//				linkList.addItem(link);
//			}
//			
//			var result:Object = new Object();
//			result.nodeList = new ArrayCollection(nodeList.toArray());
//			result.linkList = new ArrayCollection(linkList.toArray());
//			return result;
//		}
		
		private static function getLineName(startName:String, endName:String):String{
			return startName+"-"+endName;
		}
	}
}