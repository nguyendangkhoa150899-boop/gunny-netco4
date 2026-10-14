package godCardRaise.view
{
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import godCardRaise.GodCardRaiseManager;
   
   public class GodCardRaiseDivineCardsLoader extends EventDispatcher implements Disposeable
   {
       
      
      private var _displayCards:Dictionary;
      
      private var _loaderCount:int;
      
      private var _backFun:Function;
      
      private var _loaderDic:Dictionary;
      
      public function GodCardRaiseDivineCardsLoader()
      {
         this._displayCards = new Dictionary();
         this._loaderDic = new Dictionary();
         super();
      }
      
      public function loadCards(param1:Array, param2:Function = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         this._backFun = param2;
         this._loaderCount = param1.length;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(this._displayCards.hasOwnProperty(param1[_loc3_]))
            {
               this._loaderCount -= 1;
            }
            else
            {
               _loc4_ = GodCardRaiseManager.Instance.godCardListInfoList[param1[_loc3_]];
               _loc5_ = LoadResourceManager.Instance.createLoader(PathManager.solveGodCardRaisePath(_loc4_.Pic),0);
               _loc5_.addEventListener("complete",this.__picComplete);
               LoadResourceManager.Instance.startLoad(_loc5_);
               this._loaderDic[_loc5_] = param1[_loc3_];
            }
            _loc3_++;
         }
         if(this._loaderCount <= 0)
         {
            if(this._backFun != null)
            {
               this._backFun();
            }
            dispatchEvent(new Event("complete"));
         }
      }
      
      private function __picComplete(param1:LoaderEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__picComplete);
         if(param1.loader.isSuccess)
         {
            _loc2_ = param1.loader.content as Bitmap;
            _loc3_ = int(this._loaderDic[param1.loader]);
            this._displayCards[_loc3_] = _loc2_;
         }
         this._loaderCount -= 1;
         if(this._loaderCount - 1 <= 0)
         {
            if(this._backFun != null)
            {
               this._backFun();
            }
            dispatchEvent(new Event("complete"));
         }
      }
      
      public function get displayCards() : Dictionary
      {
         return this._displayCards;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(Boolean(this._displayCards))
         {
            _loc1_ = 0;
            _loc2_ = this._displayCards;
            for each(_loc3_ in this._displayCards)
            {
               ObjectUtils.disposeObject(_loc3_);
            }
         }
         this._displayCards = null;
         this._loaderCount = 0;
         this._backFun = null;
         this._loaderDic = null;
      }
   }
}
