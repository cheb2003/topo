package my.ui.topo.data
{
	import com.adobe.serialization.json.JSON;
	
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
		private var jsonStr:String;  
		private var jsonObj:Object;           
		
		private var jsonObj2:Object;  
		private var jsonStr2:String;  
		
		internal function init():void{  
			jsonStr =  '{"name":"zhanzhihu","age":22,"gender":"male"}';               
			jsonObj = new Object();  
			jsonObj = JSON.decode(jsonStr);  
			trace(jsonObj.name);  
			
			jsonObj2 = new Object();  
			jsonObj2.firstName = "bill";  
			jsonObj2.lastName  = "Gate";      
			jsonObj2.com       = "Microsoft";  
			jsonStr2 = JSON.encode( jsonObj2 );  
			trace( jsonStr2 );       
		}
		
		public static function getNodeList():String{
			return "";
		}
		
		public static function analayzerData(str:String):Object{
			var arr:Array = JSON.decode(str) as Array;
			var nodeList:NodeList = new NodeList();
			var linkDataList:LinkDataList = new LinkDataList();
			var linkList:ArrayList = new ArrayList();
			
			for (var i:int=0; i<arr.length; i++){
				var obj:Object = arr[i];
				obj.toString().length
				var node:Node = new Node();
				node.labelName = obj.name;
				node.id = obj.id;
				if (obj.isBase=="true")
					node.isBase = true;
				else
					node.isBase = false;
				nodeList.addItem(node);
				if (obj.relatedNodeIds==null || obj.relatedNodeIds.toString().length<1)
					continue;
				var s:String = obj.relatedNodeIds as String;
				var ta:Array = s.split(",");
				for (var j:int=0; j<ta.length; j++){
					var id:String = ta[j] as String;
					var ld:LinkData = new LinkData();
					ld.startNodeId = obj.id;
					ld.endNodeId = id;
					linkDataList.addLink(ld);
				}
			}
			
			for (var k:int=0; k<linkDataList.length; k++){
				var td:LinkData = linkDataList.getItemAt(k) as LinkData;
				var link:Link = new Link();
				link.startNode = nodeList.getNodeById(td.startNodeId);
				link.endNode = nodeList.getNodeById(td.endNodeId);
				link.linkName = getLineName(link.startNode.labelName, link.endNode.labelName);
				linkList.addItem(link);
			}
			
			var result:Object = new Object();
			result.nodeList = new ArrayCollection(nodeList.toArray());
			result.linkList = new ArrayCollection(linkList.toArray());
			return result;
		}
		
		private static function getLineName(startName:String, endName:String):String{
			return startName+"-"+endName;
		}
	}
}