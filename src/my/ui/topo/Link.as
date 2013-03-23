package my.ui.topo
{
	public class Link extends Renderer
	{
		/**开始节点*/
		private var _startNode:Node;
		/**结束节点*/
		private var _endNode:Node;
		/**开始端点*/
		private var _startPort:Port;
		/**结束端点*/
		private var _endPort:Port;
		
		private var _shapeType:String;
		
		public function Link()
		{
			super();
		}

		public function get startNode():Node
		{
			return _startNode;
		}

		public function set startNode(value:Node):void
		{
			_startNode = value;
		}

		public function get endNode():Node
		{
			return _endNode;
		}

		public function set endNode(value:Node):void
		{
			_endNode = value;
		}

		
		public function get startPort():Port
		{
			return _startPort;
		}

		public function set startPort(value:Port):void
		{
			_startPort = value;
		}
		
		public function get endPort():Port
		{
			return _endPort;
		}

		public function set endPort(value:Port):void
		{
			_endPort = value;
		}

	}
}