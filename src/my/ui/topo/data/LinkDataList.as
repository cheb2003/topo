package my.ui.topo.data
{
	import mx.collections.ArrayList;

	public class LinkDataList extends ArrayList
	{
		public function LinkDataList()
		{
			super();
		}
		
		public function addLink(link:LinkData):void{
			var flag:Boolean = false;
			for (var i:int=0; i<this.length; i++)
			{
				var l:LinkData = this.getItemAt(i) as LinkData;
				if (link.isEqual(l)){
					flag = true;
				}
			}
			if (!flag)
				this.addItem(link);
		}
	}
}