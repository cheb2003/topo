package my.ui.topo.layout.basic
{
	import my.ui.topo.Link;
	import my.ui.topo.layout.GraphLayout;
	import my.ui.topo.skins.DefaultLinkSkin;
	
	/**
	 * 直线布局算法
	 */ 
	public class StraightLayout extends GraphLayout
	{
		public function StraightLayout()
		{
			super();
		}
		
		protected override function layout():void{
			for(var i:int=0;i<topoGraph.linkDataProvider.length;i++){
				var link:Link = Link(topoGraph.linkDataProvider.getItemAt(i));	
				link.setStyle("skinClass", DefaultLinkSkin);
				link.invalidateSkinState();
			}
		}
	}
}