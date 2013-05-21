package my.ui.topo.event
{
	import flash.events.Event;

    /**
     * 节点构造完毕事件
     */
	public class AdjustComplateEvent extends Event
	{
		public static var NODE_ADJUST_COMPLATE:String = "node_adjust_complate";
		public function AdjustComplateEvent(str:String)
		{
			super(str);
		}
	}
}