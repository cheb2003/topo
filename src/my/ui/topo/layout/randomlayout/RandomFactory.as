package my.ui.topo.layout.randomlayout
{
	import flash.geom.Point;
	
	import my.ui.topo.layout.BaseLayoutFactory;

	public class RandomFactory extends BaseLayoutFactory
	{
		public function RandomFactory()
		{
		}
		
		public static function getRandomPoint(startX:int,endX:int,startY:int,endY:int):Point {
			return new Point(getRandomNumber(startX, endX),getRandomNumber(startY, endY));
		}
		
		public static function getRandomPointList(num:int,basePoint:Point):Array{
			var arr:Array = new Array();
			while (arr.length<num){
				var p:Point = getRandomPoint(0,500,0,500);
				checkArray(arr,p);
			}
			return arr;
		}
		
		public static function getRandomNumber(start:int, end:int):int{
			return Math.round(Math.random()*(end-start))+start;
		}
		
	}
}