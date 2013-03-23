package my.ui.topo.layout.randomlayout
{
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	
	import my.ui.topo.Node;
	import my.ui.topo.layout.BaseLayoutFactory;

	public class RandomFactory extends BaseLayoutFactory
	{
		public function RandomFactory()
		{
		}
		
		public static function getRandomPoint(startX:int,endX:int,startY:int,endY:int):Point {
			return new Point(getRandomNumber(startX, endX),getRandomNumber(startY, endY));
		}
		
		public static function getRandomPointList(num:int,baseNode:Node,distance:Number,offset:uint=0):ArrayList{
			var arr:ArrayList = new ArrayList();
			if (baseNode!=null)
				arr.addItem(new Point(baseNode.x,baseNode.y));
			while (arr.length<num){
				var p:Point = getRandomPoint(0,500,0,500);
				checkRepeatArray(arr,p,distance,offset);
			}
			return arr;
		}
		
		public static function getRandomNumber(start:int, end:int):int{
			return Math.round(Math.random()*(end-start))+start;
		}
		
	}
}