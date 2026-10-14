package signActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.CoreManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.HelperUIModuleLoad;
   import hallIcon.HallIconManager;
   import signActivity.model.SignActivityModel;
   import signActivity.view.SignActivityFrame;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class SignActivityMgr extends CoreManager
   {
      
      private static var _instance:SignActivityMgr;
       
      
      private var _frame:SignActivityFrame;
      
      private var _model:SignActivityModel;
      
      private var _isOpen:Boolean = false;
      
      public function SignActivityMgr()
      {
         super();
      }
      
      public static function get instance() : SignActivityMgr
      {
         if(!_instance)
         {
            _instance = new SignActivityMgr();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new SignActivityModel();
      }
      
      public function get model() : SignActivityModel
      {
         return this._model;
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["signActivity"],this.onLoadedNew);
      }
      
      private function onLoadedNew() : void
      {
         var _loc2_:GmActivityInfo = WonderfulActivityManager.Instance.getActivityDataById(SignActivityMgr.instance.model.actId);
         var _loc1_:int = this.findSignActivityType(_loc2_.giftbagArray);
         this._frame = ComponentFactory.Instance.creatCustomObject("SignActivity.SignActivityFrame",[_loc1_]);
         this._frame.titleText = LanguageMgr.GetTranslation("ddt.SignActivity.title");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      private function findSignActivityType(array:Array) : int
      {
         var _loc4_:int = 0;
         var _loc3_:* = null;
         var _loc2_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < array.length)
         {
            _loc3_ = array[_loc4_] as GiftBagInfo;
            if(_loc3_.giftConditionArr[0].conditionIndex == 2)
            {
               _loc2_ = _loc3_.giftConditionArr[0].conditionValue;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("signActivity", true);
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(value:Boolean) : void
      {
         this._isOpen = value;
         this.showIcon();
      }
   }
}
