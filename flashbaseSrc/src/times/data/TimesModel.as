package times.data
{
   import com.pickgliss.loader.LoaderQueue;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   
   public class TimesModel implements Disposeable
   {
      
      public static const SMALL_PIC_WIDTH:uint = 250;
      
      public static const SMALL_PIC_HEIGHT:uint = 140;
       
      
      public var smallPicInfos:Vector.<times.data.TimesPicInfo>;
      
      public var bigPicInfos:Vector.<times.data.TimesPicInfo>;
      
      public var contentInfos:Array;
      
      public var webPath:String;
      
      public var edition:int;
      
      public var editor:String;
      
      public var nextDate:String;
      
      public var isDailyGotten:Boolean;
      
      public var isShowEgg:Boolean;
      
      public var smallPicWidth:int = 250;
      
      public var smallPicHeight:int = 140;
      
      private var _thumbnailQueue:LoaderQueue;
      
      private var _thumbnailLoaders:Array;
      
      public function TimesModel()
      {
         super();
      }
      
      private function init() : void
      {
         this.smallPicInfos = new Vector.<TimesPicInfo>();
         this.bigPicInfos = new Vector.<TimesPicInfo>();
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.smallPicInfos.length)
         {
            this.smallPicInfos[_loc2_] = null;
            _loc2_++;
         }
         this.smallPicInfos = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.bigPicInfos.length)
         {
            this.bigPicInfos[_loc3_] = null;
            _loc3_++;
         }
         this.bigPicInfos = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.contentInfos.length)
         {
            _loc1_ = 0;
            while(_loc1_ < this.contentInfos[_loc4_].length)
            {
               this.contentInfos[_loc4_][_loc1_] = null;
               _loc1_++;
            }
            _loc4_++;
         }
         this.contentInfos = null;
         ObjectUtils.disposeObject(this._thumbnailQueue);
         this._thumbnailQueue = null;
      }
   }
}
