package my.ui.topo
{
import flash.events.Event;
import flash.events.MouseEvent;
	
	import my.ui.topo.skins.DefaultLinkTipSkin;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[Bindable]
	[SkinState("normal")]
	[SkinState("mouseOver")]
	public class LinkTip extends SkinnableComponent
	{
		public var linkLine:LinkLine;
		private var _mouseOver:Boolean;
        public var linkName:String = "";
        public var linkInfo:String = "";

		
		public function LinkTip()
		{
			super();
			setStyle("skinClass", DefaultLinkTipSkin);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            visible = false
            depth = int.MAX_VALUE
            includeInLayout = false
		}
		
		protected override function getCurrentSkinState():String{
			if(this.mouseOver)
				return "mouseOver";
			else
				return "normal";
		}
		
		public function mouseOverHandler(evt:MouseEvent):void{
			this.mouseOver = true;
			this.linkLine.outFlag = false;
		}
		
		public function mouseOutHandler(evt:MouseEvent):void{
			this.mouseOver = false;
			this.linkLine.outFlag = true;
		}

		public function get mouseOver():Boolean
		{
			return _mouseOver;
		}

		public function set mouseOver(value:Boolean):void
		{
			if(value!=this._mouseOver)
				invalidateSkinState();
			_mouseOver = value;
		}

        public function yChanged(event:Event):void {

            y = event.target.y - 55
        }

        public function xChanged(event:Event):void {
            x = event.target.x - 30
        }
    }
}