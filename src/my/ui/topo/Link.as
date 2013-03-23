package my.ui.topo
{
	public class Link extends Renderer
	{
		/**开始节点*/
		public var startNode:Node;
		/**结束节点*/
		public var endNode:Node;
		/**开始端点*/
		public var startPort:Port;
		/**结束端点*/
		public var endPort:Port;
		
		public function Link()
		{
			super();
		}
	}
}