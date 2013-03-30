package my.ui.topo
{
	import my.ui.topo.skins.DefaultLinkTipSkin;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[Bindable]
	[SkinState("normal")]
	[SkinState("mouseOver")]
	public class LinkTip extends SkinnableComponent
	{
		public function LinkTip()
		{
			super();
			setStyle("skinClass", DefaultLinkTipSkin);
		}
	}
}