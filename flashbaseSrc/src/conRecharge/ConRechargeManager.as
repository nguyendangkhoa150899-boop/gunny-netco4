package conRecharge
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import conRecharge.view.ConRechargeFrame;
   
   public class ConRechargeManager
   {
      
      private static var _instance:conRecharge.ConRechargeManager;
       
      
      public var isOpen:Boolean;
      
      private var _frame:ConRechargeFrame;
      
      private var _giftbagArray:Array;
      
      public var dayGiftbagArray:Array;
      
      public var longGiftbagArray:Array;
      
      public var beginTime:String;
      
      public var endTime:String;
      
      public var actId:String;
      
      public function ConRechargeManager()
      {
         super();
      }
      
      public static function get instance() : conRecharge.ConRechargeManager
      {
         if(!_instance)
         {
            _instance = new conRecharge.ConRechargeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.onLoaded();
      }
      
      private function onLoaded() : void
      {
         this._frame = ComponentFactory.Instance.creatCustomObject("conRecharge.ConRechargeFrame");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      public function set giftbagArray(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         this._giftbagArray = param1;
         this.dayGiftbagArray = [];
         this.longGiftbagArray = [];
         _loc3_ = 0;
         while(_loc3_ < this._giftbagArray.length)
         {
            _loc4_ = this._giftbagArray[_loc3_];
            if(_loc4_.giftConditionArr[0].conditionIndex == 1)
            {
               this.dayGiftbagArray.push(_loc4_);
            }
            else
            {
               _loc2_ = [];
               _loc5_ = 0;
               if(_loc5_ >= this.longGiftbagArray.length)
               {
                  _loc2_.push(_loc4_);
                  this.longGiftbagArray.push(_loc2_);
               }
            }
            _loc3_++;
         }
      }
   }
}
