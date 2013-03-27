package my.ui.topo.data
{
	public class LinkData extends Object
	{
		public var startNodeId:String;
		public var endNodeId:String;
		public var linkName:String;
		public function LinkData()
		{
		}
		
		public function isEqual(link:LinkData):Boolean{
			if (link.startNodeId == this.startNodeId || link.startNodeId == this.endNodeId){
				if (link.endNodeId == this.startNodeId || link.endNodeId == this.endNodeId)
					return true;
			}
			return false;
		}
	}
}