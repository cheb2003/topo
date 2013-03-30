package my.ui.topo
{
	import flash.events.MouseEvent;
	
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
		
		private var _label:String = "8";
		
		private var _mouseOverFlag:Boolean = false;
		
		public function LinkDecoration()
		{
			super();
			setStyle("skinClass", DefaultLinkDecorationSkin);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
		}
		
		private function mouseOverHandler(evt:MouseEvent):void{
			this.mouseOverFlag = true;
		}
		
		private function mouseOutHandler(evt:MouseEvent):void{
			this.mouseOverFlag = false;
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