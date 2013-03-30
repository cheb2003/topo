package my.ui.topo
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
		private var _lineColor:uint=0x15719F;
		/**直接关系渐变线条起止端点颜色*/
		private var _drlStartColor:uint=0xf3955;
		private var _drlEndColor:uint=0x97BED4;
		/**线条粗细*/
		private var _overThick:uint = 2;
		
		/**是否是直接关系*/
		private var _isDirectRelation:Boolean;
		/**线条悬停标记，用以控制是否真正改变悬停效果*/
		private var _outFlag:Boolean;
		public var link:Link;
		
		public function LinkLine()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandle);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandle);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,complateHandle);
			this.addEventListener(MouseEvent.CLICK,mouseClickHandle);
		}
		private function mouseClickHandle(evt:MouseEvent):void
		{
			Alert.show("mouse clicked!");
		}
		private function complateHandle(evt:FlexEvent):void{
			this.overThick = 2;
		}
		
		//绘制间接关系
		public function drawIndirectRelation():void{
			this.graphics.clear();
			this.graphics.lineStyle(this.overThick,lineColor);
			this.graphics.moveTo(xFrom,yFrom);
			this.graphics.lineTo(xTo,yTo);
		}
		
		//绘制直接关系
		public function drawDirectRelation():void {
			this.graphics.clear();
			this.graphics.lineStyle(this.overThick);
			this.graphics.lineGradientStyle(GradientType.LINEAR,[drlStartColor, drlEndColor], [1, 1], [78, 255]);
			this.graphics.moveTo(xFrom,yFrom);
			this.graphics.lineTo(xTo,yTo);
		}
		
		private function mouseOverHandle(evt:MouseEvent):void
		{
			this.overThick = 4;
			this.outFlag = false;
			link.showDecoration();
			invalidateDisplayList();
		}
		
		private function mouseOutHandle(evt:MouseEvent):void{
			resetState();
		}
		
		public function resetState():void{
			var timer:Timer = new Timer(1000,1);
			this.overThick = 2;
			this.outFlag = true;
			timer.addEventListener(TimerEvent.TIMER, outTimerHandler);
			timer.start();
		}
		
		private function outTimerHandler(evt:TimerEvent):void{
			if(this.outFlag){
				link.hideDecoration();
				this.outFlag = false;
				invalidateDisplayList();
			}
		}
		
		private function refreshLine():void{
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
			if(this._lineColor != color)
				invalidateProperties();
			this._lineColor = color;
		}
		public function get lineColor():uint{
			return _lineColor;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			refreshLine();
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

		public function get overThick():uint
		{
			return _overThick;
		}

		public function set overThick(value:uint):void
		{
			if(this._overThick!=value)
				invalidateProperties();
			this._overThick = value;
		}

		public function get outFlag():Boolean
		{
			return _outFlag;
		}

		public function set outFlag(value:Boolean):void
		{
			_outFlag = value;
		}


	}
}