package godCardRaise
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.AssetModuleLoader;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import godCardRaise.analyzer.GodCardListAnalyzer;
   import godCardRaise.analyzer.GodCardListGroupAnalyzer;
   import godCardRaise.analyzer.GodCardPointRewardListAnalyzer;
   import godCardRaise.info.GodCardListGroupInfo;
   import godCardRaise.info.GodCardListInfo;
   import godCardRaise.info.GodCardPointRewardListInfo;
   import godCardRaise.model.GodCardRaiseModel;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class GodCardRaiseManager extends EventDispatcher
   {
      
      public static const SHOW_VIEW:String = "godCardRaise_show_view";
      
      public static const OPEN_CARD:String = "openCard";
      
      public static const OPERATE_CARD:String = "operateCard";
      
      public static const EXCHANGE:String = "exchange";
      
      public static const AWARD_INFO:String = "awardInfo";
      
      public static const CLOSE_VIEW:String = "closeView";
      
      private static var _instance:godCardRaise.GodCardRaiseManager;
       
      
      private var _isOpen:Boolean = false;
      
      private var _icon:BaseButton;
      
      private var _dateEnd:Date;
      
      private var _model:GodCardRaiseModel;
      
      private var _godCardListInfoList:Dictionary;
      
      private var _godCardListGroupInfoList:Array;
      
      private var _godCardPointRewardListList:Vector.<GodCardPointRewardListInfo>;
      
      public var notShowAlertAgain:Boolean;
      
      public var buyIsBind:Boolean = true;
      
      private var _doubleTime:Date;
      
      private var _state:int = 0;
      
      private var _smallView:Sprite;
      
      private var _godCardRaiseMainView:Frame;
      
      public function GodCardRaiseManager(param1:IEventDispatcher = null)
      {
         this._dateEnd = new Date();
         super(param1);
      }
      
      public static function get Instance() : godCardRaise.GodCardRaiseManager
      {
         if(_instance == null)
         {
            _instance = new godCardRaise.GodCardRaiseManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new GodCardRaiseModel();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(PkgEvent.format(329),this.EventInit);
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function EventInit(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case 20:
               this.onInit(param1);
               break;
            case 21:
               this.onOpenCard(param1);
               break;
            case 22:
               this.onOperateCard(param1);
               break;
            case 23:
               this.onExchange(param1);
               break;
            case 25:
               this.onAwardInfo(param1);
               break;
            case 32:
               this.onIsOpen(param1);
         }
      }
      
      public function set state(param1:int) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
            if(this._state == 0)
            {
               if(Boolean(this._godCardRaiseMainView))
               {
                  LayerManager.Instance.addToLayer(this._godCardRaiseMainView,3,true,1);
               }
               if(Boolean(this._smallView) && Boolean(this._smallView.parent))
               {
                  this._smallView.parent.removeChild(this._smallView);
               }
            }
            else
            {
               if(Boolean(this._godCardRaiseMainView) && Boolean(this._godCardRaiseMainView.parent))
               {
                  this._godCardRaiseMainView.parent.removeChild(this._godCardRaiseMainView);
               }
               if(!this._smallView)
               {
                  this._smallView = ClassUtils.CreatInstance("godCardRaise.view.GodCardRaiseSmallView") as Sprite;
                  this._smallView.x = 696;
                  this._smallView.y = 324;
               }
               LayerManager.Instance.addToLayer(this._smallView,3);
            }
         }
      }
      
      private function test() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         this._model.cards[1] = 100;
         this._model.chipCount = 500;
         this._godCardListInfoList = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = new GodCardListInfo();
            _loc2_.ID = _loc1_ + 1;
            _loc2_.Name = "卡牌模板" + _loc3_;
            _loc2_.Pic = (_loc1_ % 2 == 0 ? 1 : 2) + "";
            _loc2_.Composition = 100;
            _loc2_.Decompose = 5;
            _loc2_.Level = 0;
            this._godCardListInfoList[_loc2_.ID] = _loc2_;
            _loc1_++;
         }
         this._godCardListGroupInfoList = [];
         _loc3_ = 0;
         while(_loc3_ < 20)
         {
            _loc4_ = new GodCardListGroupInfo();
            _loc4_.GroupID = _loc3_ + 1;
            _loc4_.GroupName = "测试卡组" + _loc3_;
            _loc4_.ExchangeTimes = 2;
            _loc5_ = [];
            _loc6_ = _loc3_ % 2 == 0 ? int(1) : int(2);
            if(_loc3_ % 2 == 0)
            {
               _loc5_.push({
                  "cardId":_loc6_,
                  "cardCount":5
               });
            }
            else if(_loc3_ % 3 == 0)
            {
               _loc5_.push({
                  "cardId":_loc6_,
                  "cardCount":7
               });
               _loc5_.push({
                  "cardId":_loc6_,
                  "cardCount":9
               });
            }
            else
            {
               _loc5_.push({
                  "cardId":_loc6_,
                  "cardCount":3
               });
               _loc5_.push({
                  "cardId":_loc6_,
                  "cardCount":3
               });
               _loc5_.push({
                  "cardId":_loc6_,
                  "cardCount":3
               });
            }
            _loc4_.Cards = _loc5_;
            _loc4_.GiftID = 1120 + _loc3_;
            this._godCardListGroupInfoList.push(_loc4_);
            _loc3_++;
         }
         this._godCardPointRewardListList = new Vector.<GodCardPointRewardListInfo>();
         _loc7_ = 0;
         while(_loc7_ < 10)
         {
            _loc8_ = new GodCardPointRewardListInfo();
            _loc8_.ID = _loc7_;
            _loc8_.ItemID = 1120 + _loc3_;
            _loc8_.Count = 2;
            _loc8_.Point = 100 * (_loc3_ + 1);
            _loc8_.Valid = 7;
            this._godCardPointRewardListList.push(_loc8_);
            _loc7_++;
         }
         this._model.awardIds[1] = 1;
      }
      
      protected function onIsOpen(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         this._dateEnd = _loc2_.readDate();
         this._isOpen = _loc3_;
         if(this._isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("godCardRaise.beginTips"));
         }
         else
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("godCardRaise.endTips"));
         }
         this.checkIcon();
         if(!this._isOpen)
         {
            dispatchEvent(new CEvent("closeView"));
         }
      }
      
      private function onInit(param1:PkgEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:PackageIn = param1.pkg;
         var _loc10_:Dictionary = new Dictionary();
         var _loc11_:int = _loc9_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc11_)
         {
            _loc3_ = _loc9_.readInt();
            _loc4_ = _loc9_.readInt();
            _loc10_[_loc3_] = _loc4_;
            _loc2_++;
         }
         this._model.cards = _loc10_;
         this._model.score = _loc9_.readInt();
         this._model.chipCount = _loc9_.readInt();
         this._model.freeCount = _loc9_.readInt();
         var _loc12_:int = _loc9_.readInt();
         _loc5_ = 0;
         while(_loc5_ < _loc12_)
         {
            this._model.awardIds[_loc9_.readInt()] = 1;
            _loc5_++;
         }
         var _loc13_:int = _loc9_.readInt();
         _loc6_ = 0;
         while(_loc6_ < _loc13_)
         {
            _loc7_ = _loc9_.readInt();
            _loc8_ = _loc9_.readInt();
            this._model.groups[_loc7_] = _loc8_;
            _loc6_++;
         }
         this._doubleTime = param1.pkg.readDate();
         dispatchEvent(new CEvent("godCardRaise_show_view"));
      }
      
      private function showView() : void
      {
         this.disposeView();
         this._godCardRaiseMainView = ComponentFactory.Instance.creatComponentByStylename("godCardRaise.frame");
         LayerManager.Instance.addToLayer(this._godCardRaiseMainView,3,true,1);
      }
      
      public function disposeView() : void
      {
         this._state = 0;
         if(Boolean(this._godCardRaiseMainView))
         {
            ObjectUtils.disposeObject(this._godCardRaiseMainView);
            this._godCardRaiseMainView = null;
         }
         if(Boolean(this._smallView))
         {
            ObjectUtils.disposeObject(this._smallView);
            this._smallView = null;
         }
      }
      
      private function onOpenCard(param1:PkgEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PackageIn = param1.pkg;
         var _loc6_:Array = [];
         var _loc7_:int = _loc5_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = _loc5_.readInt();
            _loc6_.push(_loc3_);
            _loc4_ = int(this._model.cards[_loc3_]);
            this._model.cards[_loc3_] = _loc4_ + 1;
            _loc2_++;
         }
         this._model.score = _loc5_.readInt();
         this._model.freeCount = _loc5_.readInt();
         dispatchEvent(new CEvent("openCard",_loc6_));
      }
      
      private function onOperateCard(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         this._model.cards[_loc3_] = _loc4_;
         this._model.chipCount = _loc5_;
         dispatchEvent(new CEvent("operateCard"));
      }
      
      private function onExchange(param1:PkgEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PackageIn = param1.pkg;
         var _loc6_:int = _loc5_.readInt();
         var _loc7_:int = _loc5_.readInt();
         GodCardRaiseManager.Instance.model.groups[_loc6_] = _loc7_;
         var _loc8_:int = _loc5_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc8_)
         {
            _loc3_ = _loc5_.readInt();
            _loc4_ = _loc5_.readInt();
            this._model.cards[_loc3_] = _loc4_;
            _loc2_++;
         }
         dispatchEvent(new CEvent("exchange"));
      }
      
      private function onPointAwardAttribute(param1:PkgEvent) : void
      {
      }
      
      public function getMyCardCount(param1:int = 0) : int
      {
         if(this._model.cards[param1] != null)
         {
            return this._model.cards[param1];
         }
         return 0;
      }
      
      private function onAwardInfo(param1:PkgEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this._model.awardIds[_loc3_.readInt()] = 1;
            _loc2_++;
         }
         dispatchEvent(new CEvent("awardInfo"));
      }
      
      public function loadGodCardListTemplate(param1:GodCardListAnalyzer) : void
      {
         this._godCardListInfoList = param1.list;
      }
      
      public function loadGodCardListGroup(param1:GodCardListGroupAnalyzer) : void
      {
         this._godCardListGroupInfoList = param1.list;
      }
      
      public function loadGodCardPointRewardList(param1:GodCardPointRewardListAnalyzer) : void
      {
         this._godCardPointRewardListList = param1.list;
      }
      
      public function get godCardListInfoList() : Dictionary
      {
         return this._godCardListInfoList;
      }
      
      public function getGodCardListInfoListByLevel(param1:int) : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = [];
         var _loc4_:* = this._godCardListInfoList;
         for each(_loc2_ in this._godCardListInfoList)
         {
            if(param1 == _loc2_.Level)
            {
               _loc3_.push(_loc2_);
            }
         }
         _loc3_.sortOn("ID",16);
         return _loc3_;
      }
      
      public function get godCardListGroupInfoList() : Array
      {
         return this._godCardListGroupInfoList;
      }
      
      public function getGodCardListGroupInfo(param1:int) : GodCardListGroupInfo
      {
         var _loc2_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:* = this._godCardListGroupInfoList;
         for each(_loc2_ in this._godCardListGroupInfoList)
         {
            if(_loc2_.GroupID == param1)
            {
               _loc3_ = _loc2_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function get godCardPointRewardList() : Vector.<GodCardPointRewardListInfo>
      {
         return this._godCardPointRewardListList;
      }
      
      public function calculateExchangeCount(param1:GodCardListGroupInfo) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = int(param1.Cards.length);
         var _loc8_:Dictionary = this.model.cards;
         _loc2_ = 0;
         while(_loc2_ < param1.Cards.length)
         {
            _loc3_ = param1.Cards[_loc2_];
            _loc4_ = int(_loc3_["cardId"]);
            _loc5_ = int(_loc3_["cardCount"]);
            _loc6_ = int(_loc8_[_loc4_]);
            if(_loc6_ < _loc5_)
            {
               _loc7_--;
            }
            _loc2_++;
         }
         return _loc7_;
      }
      
      public function checkIcon() : void
      {
         if(this._isOpen)
         {
            this.showIcon();
         }
         else
         {
            this.hideIcon();
         }
      }
      
      private function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("godCard",true);
      }
      
      private function hideIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("godCard",false);
      }
      
      public function show() : void
      {
         AssetModuleLoader.addRequestLoader(LoaderCreate.Instance.creatGodCardListTemplate());
         AssetModuleLoader.addModelLoader("godCardRaise",6);
         AssetModuleLoader.startCodeLoader(this.loadShowFrameData);
      }
      
      private function loadShowFrameData() : void
      {
         GameInSocketOut.sendGodCardInfoAttribute();
      }
      
      public function get dataEnd() : Date
      {
         return this._dateEnd;
      }
      
      public function get model() : GodCardRaiseModel
      {
         return this._model;
      }
      
      public function get doubleTime() : Number
      {
         return this._doubleTime.time - TimeManager.Instance.NowTime();
      }
   }
}
