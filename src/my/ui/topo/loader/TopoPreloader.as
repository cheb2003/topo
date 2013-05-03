/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 13-5-3
 * Time: 下午3:34
 * To change this template use File | Settings | File Templates.
 */
package my.ui.topo.loader {
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.utils.getTimer;

import mx.events.RSLEvent;

import mx.preloaders.SparkDownloadProgressBar;

import spark.components.Label;

public class TopoPreloader extends SparkDownloadProgressBar {

        public function TopoPreloader() {
            super();
        }

        private var _displayStartCount:uint = 0;
        private var _initProgressCount:uint = 0;
        private var _downloadComplete:Boolean = false;
        private var _showingDisplay:Boolean = false;
        private var _startTime:int;
        private var rslBaseText:String = "Loading app: ";
        private var numberRslTotal:Number = 1;
        private var numberRslCurrent:Number = 1;
        private var loadingTxt:Label;
        private var loadingTip:String = "Loading application ... ";

        override protected function initCompleteHandler(event:Event):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        override protected function createChildren():void
        {
            if (!loadingTxt) {
                loadingTxt = new Label();
                loadingTxt.text = loadingTip;

                var startX:Number = Math.round((stageWidth - loadingTxt.width) / 2);
                var startY:Number = Math.round((stageHeight - loadingTxt.height) / 2);

                loadingTxt.x = startX;
                loadingTxt.y = startY;
                addChild(loadingTxt);
            }
        }

        override protected function progressHandler(evt:ProgressEvent):void {
            if (loadingTxt) {
                var progressApp:Number = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
                loadingTxt.text = loadingTip + progressApp;
            }else{
                show();
            }
        }

        override protected function rslProgressHandler(evt:RSLEvent):void {
            if (evt.rslIndex && evt.rslTotal) {
                numberRslTotal = evt.rslTotal;
                numberRslCurrent = evt.rslIndex;
                var progressRsl:Number = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
                loadingTxt.text = loadingTip + (Math.round( (numberRslCurrent-1)*100/numberRslTotal + progressRsl/numberRslTotal));
            }
        }

        override protected function setInitProgress(completed:Number, total:Number):void {
            if (loadingTxt) {
                //set the initialization progress : red square fades out
                loadingTxt.text = loadingTip + (Math.round((completed/total)*100));

                //set loading text
                if (completed > total) {
                    setPreloaderLoadingText("ready for action");
                } else {
                    setPreloaderLoadingText("initializing " + completed + " of " + total);
                }
            }
        }

        override protected function initProgressHandler(event:Event):void {
            var elapsedTime:int = getTimer() - _startTime;
            _initProgressCount++;

            if (!_showingDisplay &&	showDisplayForInit(elapsedTime, _initProgressCount)) {
                _displayStartCount = _initProgressCount;
                show();
                // If we are showing the progress for the first time here, we need to call setDownloadProgress() once to set the progress bar background.
                setDownloadProgress(100, 100);
            }

            if (_showingDisplay) {
                // if show() did not actually show because of SWFObject bug then we may need to set the download bar background here
                if (!_downloadComplete) {
                    setDownloadProgress(100, 100);
                }
                setInitProgress(_initProgressCount, initProgressTotal);
            }
        }

        private function show():void
        {
            // swfobject reports 0 sometimes at startup
            // if we get zero, wait and try on next attempt
            if (stageWidth == 0 && stageHeight == 0)
            {
                try
                {
                    stageWidth = stage.stageWidth;
                    stageHeight = stage.stageHeight
                }
                catch (e:Error)
                {
                    stageWidth = loaderInfo.width;
                    stageHeight = loaderInfo.height;
                }
                if (stageWidth == 0 && stageHeight == 0)
                    return;
            }

            _showingDisplay = true;
            createChildren();
        }

        private function setPreloaderLoadingText(value:String):void {
            loadingTxt.text = value;
        }

    }
}
