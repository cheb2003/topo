package my.ui.topo.layout
{
	import flash.geom.Point;

	public class BaseLayoutFactory
	{
		public function BaseLayoutFactory()
		{
		}
		
		protected static function checkArray(arr:Array,p:Point):Array{
			var flag:Boolean = true;
			for each (var m:Point in arr){
				if (checkRepeat(p,m,10)){
					flag = false;
					break;
				}
			}
			if (flag)
				arr.push(p);
			return arr;
		}
		
		protected static function  getDistance(p1:Point, p2:Point):Number{
			return Math.sqrt((p2.y-p1.y)*(p2.y-p1.y)+(p2.x-p1.x)*(p2.x-p1.x));
		}
		
		protected static function getRandomNumber(start:int, end:int):int{
			return Math.round(Math.random()*(end-start))+start;
		}
		
		protected static function checkRepeat(p1:Point, p2:Point, radius:int):Boolean{
			return getDistance(p1,p2)<radius;
		}
	}
}