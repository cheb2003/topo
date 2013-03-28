package my.ui.topo.data
{
	import mx.collections.ArrayList;
	
	import my.ui.topo.Node;

	public class NodeList extends ArrayList
	{
		public function NodeList()
		{
			super();
		}
		
		public function getNodeById(id:String):Node{
			for (var i:int=0; i<this.length; i++){
				var node:Node = this.getItemAt(i) as Node;
				if (node.id==id)
					return node;
			}
			return null;
		}
	}
}