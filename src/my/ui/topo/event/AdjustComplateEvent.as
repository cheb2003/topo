package my.ui.topo.event
{
	import flash.events.Event;

	public class AdjustComplateEvent extends Event
	{
		public static var NODE_ADJUST_COMPLATE:String = "node_adjust_complate";
		public function AdjustComplateEvent(str:String)
		{
			super(str);
		}
	}
}