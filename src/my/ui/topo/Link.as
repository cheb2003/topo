package my.ui.topo
{
	import my.ui.topo.skins.DefaultLinkSkin;

	[Bindable]
	[SkinState("normal")]
	[SkinState("selected")]
	[SkinState("mouseOver")]
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
		/**是否是直接关系*/
		private var _isDirectRelation:Boolean;
		
		private var _isMouseOver:Boolean;
		private var _shapeType:String;
				
		public function Link()
		{
			super();
			setStyle("skinClass", DefaultLinkSkin);
			this.depth = - Math.random();
		}
		
		override protected function getCurrentSkinState():String {
			if(_isMouseOver){
				return "mouseOver";
			} else {
				return "normal";
			}
		}
		
		/**显示悬停标记*/
		public function showDecoration():void{
			_isMouseOver = true;
			invalidateSkinState();
		}
		
		/**隐藏悬停标记*/
		public function hideDecoration():void{
			_isMouseOver = false;
			invalidateSkinState();
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

		/**是否是直接关系*/
		public function get isDirectRelation():Boolean
		{
			return _isDirectRelation;
		}

		/**
		 * @private
		 */
		public function set isDirectRelation(value:Boolean):void
		{
			_isDirectRelation = value;
		}

	}
}