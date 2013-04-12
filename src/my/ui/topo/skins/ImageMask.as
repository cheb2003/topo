/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-4-11
 * Time: 下午2:11
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.skins {
import mx.core.UIComponent;

public class ImageMask extends UIComponent{
    public function ImageMask() {
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
        trace("updateDisplayList")
        trace("x:" + x + " y:" + y + " width:" + width)
        graphics.clear()
        graphics.beginFill(0xff0000);
        graphics.drawCircle(x ,y,width/2);
        graphics.endFill();
        //super.updateDisplayList(unscaledWidth, unscaledHeight);
    }
}
}
