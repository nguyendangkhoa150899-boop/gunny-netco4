package farm.control
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.view.compose.model.ComposeHouseModel;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import pet.date.PetTemplateInfo;
   
   public class FarmComposeHouseController extends EventDispatcher
   {
      
      private static var _instance:farm.control.FarmComposeHouseController;
       
      
      public var composeHouseModel:ComposeHouseModel;
      
      public function FarmComposeHouseController(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function instance() : farm.control.FarmComposeHouseController
      {
         if(!_instance)
         {
            _instance = new farm.control.FarmComposeHouseController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.composeHouseModel = new ComposeHouseModel();
      }
      
      public function getResultPages(param1:int = 10) : int
      {
         var _loc2_:Vector.<InventoryItemInfo> = this.getAllItems();
         var _loc3_:int = Math.ceil(_loc2_.length / param1);
         return int(_loc3_ == 0 ? int(1) : int(_loc3_));
      }
      
      public function getAllItems() : Vector.<InventoryItemInfo>
      {
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         for each(_loc1_ in this.composeHouseModel.items)
         {
            _loc2_.push(_loc1_);
         }
         return _loc2_;
      }
      
      public function getItemsByPage(param1:int, param2:int = 10) : Vector.<InventoryItemInfo>
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc7_:Vector.<InventoryItemInfo> = this.getAllItems();
         var _loc8_:int = Math.ceil(_loc7_.length / param2);
         if(param1 > 0 && param1 <= _loc8_)
         {
            _loc3_ = 0 + param2 * (param1 - 1);
            _loc4_ = Math.min(_loc7_.length - _loc3_,param2);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_.push(_loc7_[_loc3_ + _loc5_]);
               _loc5_++;
            }
         }
         return _loc6_;
      }
      
      public function setupFoodComposeList(param1:FoodComposeListAnalyzer) : void
      {
         this.composeHouseModel.foodComposeList = param1.list;
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"),"",false,false,false,0,null,"farmSimpleAlert");
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function getComposeDetailByID(param1:int) : Vector.<FoodComposeListTemplateInfo>
      {
         return this.composeHouseModel.foodComposeList[param1];
      }
      
      public function getNextUpdatePetTimes() : String
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Number = 24 - _loc1_.getHours();
         var _loc3_:Number = 0;
         if(_loc1_.getMinutes() > 0)
         {
            _loc2_--;
            _loc3_ = 60 - _loc1_.getMinutes();
         }
         return String(_loc2_) + LanguageMgr.GetTranslation("hour") + String(_loc3_) + LanguageMgr.GetTranslation("minute") + LanguageMgr.GetTranslation("ddt.farms.refreshPetsLastTimes");
      }
      
      public function isFourStarPet(param1:Array) : Boolean
      {
         var _loc2_:PetTemplateInfo = null;
         var _loc3_:Boolean = false;
         for each(_loc2_ in param1)
         {
            if(_loc2_.StarLevel == 4)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function refreshVolume() : String
      {
         return String(PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(PetconfigAnalyzer.PetCofnig.FreeRefereshID));
      }
   }
}
