package my.ui.topo.layout.randomlayout
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayList;
	
	import my.ui.topo.Node;
	import my.ui.topo.layout.BaseLayoutFactory;
	
	public class RandomFactory extends BaseLayoutFactory
	{
		public function RandomFactory()
		{
		}
		
		public static function getRandomPoint(rect:Rectangle):Point {
			return new Point(getRandomNumber(rect.topLeft.x, rect.bottomRight.x),getRandomNumber(rect.topLeft.y, rect.bottomRight.y));
		}
		
		public static function getRandomPointList(num:int,distance:Number,rect:Rectangle,offset:uint=0):ArrayList{
			var arr:ArrayList = new ArrayList();
			while (arr.length<num){
				var p:Point = getRandomPoint(rect);
				checkRepeatArray(arr,p,distance,offset);
			}
			return arr;
		}
		
		public static function getRandomNumber(start:int, end:int):int{
			return Math.round(Math.random()*(end-start))+start;
		}
		
	}
}