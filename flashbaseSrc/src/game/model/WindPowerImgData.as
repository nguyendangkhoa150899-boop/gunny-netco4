package game.model
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   
   public class WindPowerImgData extends EventDispatcher
   {
       
      
      private var _imgBitmapVec:Vector.<BitmapData>;
      
      public function WindPowerImgData()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BitmapData = null;
         this._imgBitmapVec = new Vector.<BitmapData>();
         while(_loc1_ < 11)
         {
            _loc2_ = new BitmapData(1,1);
            this._imgBitmapVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function refeshData(param1:ByteArray, param2:int) : void
      {
         var imgLoad:Loader = null;
         var _imgLoadOk:Function = null;
         var bmpID:int = 0;
         imgLoad = null;
         _imgLoadOk = null;
         var bmpBytData:ByteArray = param1;
         bmpID = param2;
         _imgLoadOk = function(param1:Event):void
         {
            BitmapData(_imgBitmapVec[bmpID]).dispose();
            _imgBitmapVec[bmpID] = Bitmap(imgLoad.contentLoaderInfo.content).bitmapData;
            imgLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE,_imgLoadOk);
            imgLoad.unload();
            imgLoad = null;
         };
         imgLoad = new Loader();
         imgLoad.contentLoaderInfo.addEventListener(Event.COMPLETE,_imgLoadOk);
         imgLoad.loadBytes(bmpBytData);
      }
      
      public function getImgBmp(param1:Array) : BitmapData
      {
         var _loc2_:int = 0;
         var _loc3_:BitmapData = new BitmapData(this._imgBitmapVec[param1[1]].width + this._imgBitmapVec[param1[2]].width + this._imgBitmapVec[param1[3]].width,this._imgBitmapVec[0].height);
         var _loc4_:int = 1;
         while(_loc4_ <= 3)
         {
            _loc2_ = 0;
            switch(_loc4_)
            {
               case 2:
                  _loc2_ = this._imgBitmapVec[param1[1]].width;
                  break;
               case 3:
                  _loc2_ = this._imgBitmapVec[param1[1]].width + this._imgBitmapVec[param1[2]].width;
                  break;
            }
            _loc3_.copyPixels(this._imgBitmapVec[param1[_loc4_]],this._imgBitmapVec[param1[_loc4_]].rect,new Point(_loc2_,0));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getImgBmpById(param1:int) : BitmapData
      {
         return this._imgBitmapVec[param1];
      }
   }
}
