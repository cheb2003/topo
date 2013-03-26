package my.ui.topo
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	[Bindable]
	public class LinkLine extends UIComponent{
		private var _xFrom:Number;
		private var _xTo:Number;
		private var _yFrom:Number;
		private var _yTo:Number;
		//间接关系线条颜色
		private var _lineColor:uint=0x000000;
		/**直接关系渐变线条起止端点颜色*/
		private var _drlStartColor:uint=0xff0000;
		private var _drlEndColor:uint=0x0000ff;
		
		/**是否是直接关系*/
		private var _isDirectRelation:Boolean;
		
		public function LinkLine()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandle);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,complateHandle);
			this.addEventListener(MouseEvent.CLICK,mouseClickHandle);
		}
		private function mouseClickHandle(evt:MouseEvent):void
		{
			Alert.show("mouse clicked!");
		}
		private function complateHandle(evt:FlexEvent):void{
			
			if(isDirectRelation)
				drawDirectRelation();
			else
				drawIndirectRelation();
		}
		
		//绘制间接关系
		public function drawIndirectRelation():void{
			this.graphics.clear();
			this.graphics.lineStyle(2,lineColor);
			this.graphics.moveTo(xFrom,yFrom);
			this.graphics.lineTo(xTo,yTo);
		}
		
		//绘制直接关系
		public function drawDirectRelation():void {
			this.graphics.clear();
			this.graphics.lineGradientStyle(GradientType.LINEAR,[drlStartColor, drlEndColor], [1, 1], [0, 255]);
			this.graphics.moveTo(xFrom,yFrom);
			this.graphics.lineTo(xTo,yTo);
		}
		
		private function mouseOverHandle(evt:MouseEvent):void
		{
			this.lineColor = 0xFF0000;
			if(isDirectRelation)
				drawDirectRelation();
			else
				drawIndirectRelation();
		}
		
		public function removeLine():void{
			this.graphics.clear();
		}
		public function set xFrom(x:Number):void{
			if (x!=this._xFrom)
				invalidateDisplayList();
			this._xFrom = x;
		}
		public function set xTo(x:Number):void{
			if (x!=this._xTo)
				invalidateDisplayList();
			this._xTo = x;
		}
		public function set yFrom(y:Number):void{
			if (y!=this._yFrom)
				invalidateDisplayList();
			this._yFrom = y;
		}
		public function set yTo(y:Number):void{
			if (y!=this._yTo)
				invalidateDisplayList();
			this._yTo = y;
		}
		public function get xFrom():Number{
			return this._xFrom;
		}
		public function get xTo():Number{
			return this._xTo;
		}
		public function get yFrom():Number{
			return this._yFrom;
		}
		public function get yTo():Number{
			return this._yTo;
		}
		public function set lineColor(color:uint):void{
			_lineColor=color;
		}
		public function get lineColor():uint{
			return _lineColor;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if(isDirectRelation)
				drawDirectRelation();
			else
				drawIndirectRelation();
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}

		public function get isDirectRelation():Boolean
		{
			return _isDirectRelation;
		}

		public function set isDirectRelation(value:Boolean):void
		{
			_isDirectRelation = value;
		}

		public function get drlStartColor():uint
		{
			return _drlStartColor;
		}

		public function set drlStartColor(value:uint):void
		{
			_drlStartColor = value;
		}

		public function get drlEndColor():uint
		{
			return _drlEndColor;
		}

		public function set drlEndColor(value:uint):void
		{
			_drlEndColor = value;
		}


	}
}