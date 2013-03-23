package my.ui.topo.layout
{
	import flash.geom.Point;
	
	import mx.charts.HitData;
	import mx.collections.ArrayList;

	public class BaseLayoutFactory
	{
		public function BaseLayoutFactory()
		{
		}
		
		protected static function checkRepeatArray(arr:ArrayList,p:Point, distance:Number,offset:uint=0):ArrayList{
			var flag:Boolean = true;
			for (var i:int=0; i<arr.length; i++)
			{
				var m:Point = arr.getItemAt(i) as Point;
				if (checkRepeat(p,m,distance,offset)){
					flag = false;
					break;
				}
			}
			if (flag)
				arr.addItem(p);
			return arr;
		}
		
		public static function  getDistance(p1:Point, p2:Point):Number{
			return Math.sqrt((p2.y-p1.y)*(p2.y-p1.y)+(p2.x-p1.x)*(p2.x-p1.x));
		}
		
		protected static function getRandomNumber(start:int, end:int):int{
			return Math.round(Math.random()*(end-start))+start;
		}
		
		private static function checkRepeat(p1:Point, p2:Point, distance:Number, offset:uint=0):Boolean{
			
			return getDistance(p1,p2)<distance+offset;
		}
	}
}