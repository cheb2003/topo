package my.ui.topo
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import my.ui.topo.skins.DefaultLinkDecorationSkin;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * 连线悬停小圆标记类
	 */ 
	[Bindable]
	[SkinState("normal")]
	[SkinState("mouseOver")]
	public class LinkDecoration extends SkinnableComponent
	{
		/**半径*/
		private var _radius:Number = 10;
		
		private var _label:String = "1";
        public var linkName:String = "";
        public var linkInfo:String = "";
		
		private var _mouseOverFlag:Boolean = false;
		public var linkLine:LinkLine;
        public var linkTip:LinkTip
		public function LinkDecoration()
		{
			super();
			setStyle("skinClass", DefaultLinkDecorationSkin);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function mouseOverHandler(evt:MouseEvent):void{
            linkTip.visible = true
            linkTip.includeInLayout = true
			this.mouseOverFlag = true;
			linkLine.outFlag = false;
		}
		
		private function mouseOutHandler(evt:MouseEvent):void{

			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			this.linkLine.resetState1(linkTip);
		}
		
		private function timerHandler(evt:TimerEvent):void{
			if(linkLine.outFlag) {
                this.mouseOverFlag = false;
                linkTip.visible = false
                linkTip.includeInLayout = false
            }

		}
		
		protected override function getCurrentSkinState():String{
			if(mouseOverFlag)
				return "mouseOver";
			else
				return "normal";
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		public function get mouseOverFlag():Boolean
		{
			return _mouseOverFlag;
		}

		public function set mouseOverFlag(value:Boolean):void
		{
			if(value != this._mouseOverFlag)
				invalidateSkinState();
			this._mouseOverFlag = value;
		}


	}
}