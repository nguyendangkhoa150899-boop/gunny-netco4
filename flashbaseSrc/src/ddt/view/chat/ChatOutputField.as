package ddt.view.chat
{
   import AvatarCollection.AvatarCollectionManager;
   import bagAndInfo.BagAndInfoManager;
   import cardSystem.data.CardInfo;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.EffortManager;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.utils.Helpers;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.CardsTipPanel;
   import ddt.view.tips.GoodTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.getTimer;
   import im.IMController;
   import im.IMView;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class ChatOutputField extends Sprite
   {
      
      public static const GAME_STYLE:String = "GAME_STYLE";
      
      public static const GAME_WIDTH:int = 288;
      
      public static const GAME_HEIGHT:int = 106;
      
      public static const NORMAL_WIDTH:int = 420;
      
      public static const NORMAL_HEIGHT:int = 128;
      
      public static const NORMAL_STYLE:String = "NORMAL_STYLE";
      
      private static var _style:String = "";
       
      
      private var _contentField:TextField;
      
      private var _nameTip:ddt.view.chat.ChatNamePanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardboxTip:CardBoxTipPanel;
      
      private var _cardTipPnl:CardsTipPanel;
      
      private var _goodTipPos:Sprite;
      
      private var _srcollRect:Rectangle;
      
      private var _tipStageClickCount:int = 0;
      
      private var isStyleChange:Boolean = false;
      
      private var t_text:String;
      
      private var _functionEnabled:Boolean;
      
      private var _lastClickTime:Number;
      
      public function ChatOutputField()
      {
         this._goodTipPos = new Sprite();
         super();
         this.chat_system::style = NORMAL_STYLE;
      }
      
      public function set functionEnabled(param1:Boolean) : void
      {
         this._functionEnabled = param1;
      }
      
      public function set contentWidth(param1:Number) : void
      {
         this._contentField.width = param1;
         this.updateScrollRect(param1,NORMAL_HEIGHT);
      }
      
      public function set contentHeight(param1:Number) : void
      {
         this._contentField.height = param1;
         this.updateScrollRect(NORMAL_WIDTH,param1);
      }
      
      public function isBottom() : Boolean
      {
         return this._contentField.scrollV == this._contentField.maxScrollV;
      }
      
      public function get scrollOffset() : int
      {
         return this._contentField.maxScrollV - this._contentField.scrollV;
      }
      
      public function set scrollOffset(param1:int) : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV - param1;
         this.onScrollChanged();
      }
      
      public function setChats(param1:Array) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_].htmlMessage;
            _loc3_++;
         }
         this._contentField.htmlText = _loc2_;
      }
      
      public function toBottom() : void
      {
         Helpers.delayCall(this.__delayCall);
         this._contentField.scrollV = int.MAX_VALUE;
         this.onScrollChanged();
      }
      
      chat_system function get goodTipPos() : Point
      {
         return new Point(this._goodTipPos.x,this._goodTipPos.y);
      }
      
      chat_system function showLinkGoodsInfo(param1:ItemTemplateInfo, param2:uint = 0, param3:CardInfo = null) : void
      {
         if(param1.CategoryID == EquipType.CARDBOX)
         {
            if(this._cardboxTip == null)
            {
               this._cardboxTip = new CardBoxTipPanel();
            }
            this._cardboxTip.tipData = param1;
            this.setTipPos(this._cardboxTip);
            StageReferance.stage.addChild(this._cardboxTip);
         }
         else if(param1.CategoryID == EquipType.CARDEQUIP)
         {
            if(!this._cardTipPnl)
            {
               this._cardTipPnl = new CardsTipPanel();
            }
            this._cardTipPnl.tipData = param3;
            this.setTipPos(this._cardTipPnl);
            StageReferance.stage.addChild(this._cardTipPnl);
         }
         else
         {
            if(this._goodTip == null)
            {
               this._goodTip = new GoodTip();
            }
            this._goodTip.showTip(param1);
            this.setTipPos(this._goodTip);
            StageReferance.stage.addChild(this._goodTip);
         }
         if(Boolean(this._nameTip) && Boolean(this._nameTip.parent))
         {
            this._nameTip.parent.removeChild(this._nameTip);
         }
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
         this._tipStageClickCount = param2;
      }
      
      private function setTipPos(param1:Object) : void
      {
         param1.x = this._goodTipPos.x;
         param1.y = this._goodTipPos.y - param1.height - 10;
         if(param1.y < 0)
         {
            param1.y = 10;
         }
      }
      
      chat_system function set style(param1:String) : void
      {
         if(_style != param1)
         {
            _style = param1;
            this.disposeView();
            this.initView();
            this.initEvent();
            switch(param1)
            {
               case NORMAL_STYLE:
                  this._contentField.styleSheet = ChatFormats.styleSheet;
                  this._contentField.width = NORMAL_WIDTH;
                  this._contentField.height = NORMAL_HEIGHT;
                  break;
               case GAME_STYLE:
                  this._contentField.styleSheet = ChatFormats.gameStyleSheet;
                  this._contentField.width = GAME_WIDTH;
                  this._contentField.height = GAME_HEIGHT;
            }
            this._contentField.htmlText = this.t_text || "";
         }
      }
      
      private function __delayCall() : void
      {
         this._contentField.scrollV = this._contentField.maxScrollV;
         this.onScrollChanged();
         removeEventListener(Event.ENTER_FRAME,this.__delayCall);
      }
      
      private function __onScrollChanged(param1:Event) : void
      {
         this.onScrollChanged();
      }
      
      private function __onTextClicked(param1:TextEvent) : void
      {
         var _loc20_:Object = null;
         var _loc2_:Point = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:RegExp = null;
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:Rectangle = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Point = null;
         var _loc15_:int = 0;
         var _loc16_:Point = null;
         var _loc17_:ItemTemplateInfo = null;
         var _loc18_:ItemTemplateInfo = null;
         var _loc19_:CardInfo = null;
         SoundManager.instance.play("008");
         this.__stageClickHandler();
         _loc20_ = {};
         var _loc21_:Array = param1.text.split("|");
         var _loc22_:int = 0;
         while(_loc22_ < _loc21_.length)
         {
            if(Boolean(_loc21_[_loc22_].indexOf(":")))
            {
               _loc3_ = _loc21_[_loc22_].split(":");
               _loc20_[_loc3_[0]] = _loc3_[1];
            }
            _loc22_++;
         }
         if(int(_loc20_.clicktype) == ChatFormats.CLICK_CHANNEL)
         {
            ChatManager.Instance.inputChannel = int(_loc20_.channel);
            ChatManager.Instance.output.functionEnabled = true;
         }
         else if(int(_loc20_.clicktype) == ChatFormats.CLICK_USERNAME)
         {
            _loc4_ = PlayerManager.Instance.Self.ZoneID;
            _loc5_ = int(_loc20_.zoneID);
            if(_loc5_ > 0 && _loc5_ != _loc4_)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.PrivateChatToUnable"));
               return;
            }
            if(IMView.IS_SHOW_SUB)
            {
               dispatchEvent(new ChatEvent(ChatEvent.NICKNAME_CLICK_TO_OUTSIDE,_loc20_.tagname));
            }
            if(IMController.Instance.isFriend(String(_loc20_.tagname)))
            {
               IMEManager.enable();
               ChatManager.Instance.output.functionEnabled = true;
               ChatManager.Instance.privateChatTo(_loc20_.tagname);
            }
            else
            {
               if(this._nameTip == null)
               {
                  this._nameTip = ComponentFactory.Instance.creatCustomObject("chat.NamePanel");
               }
               _loc6_ = String(_loc20_.tagname);
               _loc7_ = _loc6_.indexOf("$");
               if(_loc7_ > -1)
               {
                  _loc6_ = _loc6_.substr(0,_loc7_);
               }
               _loc8_ = new RegExp(_loc6_,"g");
               _loc9_ = this._contentField.text;
               _loc10_ = _loc8_.exec(_loc9_);
               while(_loc10_ != null)
               {
                  _loc12_ = int(_loc10_.index);
                  _loc13_ = _loc12_ + String(_loc20_.tagname).length;
                  _loc14_ = this._contentField.globalToLocal(new Point(StageReferance.stage.mouseX,StageReferance.stage.mouseY));
                  _loc15_ = this._contentField.getCharIndexAtPoint(_loc14_.x,_loc14_.y);
                  if(_loc15_ >= _loc12_ && _loc15_ <= _loc13_)
                  {
                     this._contentField.setSelection(_loc12_,_loc13_);
                     _loc11_ = this._contentField.getCharBoundaries(_loc13_);
                     _loc16_ = this._contentField.localToGlobal(new Point(_loc11_.x,_loc11_.y));
                     this._nameTip.x = _loc16_.x + _loc11_.width;
                     this._nameTip.y = _loc16_.y - this._nameTip.getHeight - (this._contentField.scrollV - 1) * 18;
                     break;
                  }
                  _loc10_ = _loc8_.exec(_loc9_);
               }
               this._nameTip.playerName = String(_loc20_.tagname);
               if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
               {
                  this._goodTip.parent.removeChild(this._goodTip);
               }
               if(Boolean(this._cardTipPnl) && Boolean(this._cardTipPnl.parent))
               {
                  this._cardTipPnl.parent.removeChild(this._cardTipPnl);
               }
               this._nameTip.setVisible = true;
               ChatManager.Instance.privateChatTo(_loc20_.tagname);
            }
         }
         else if(int(_loc20_.clicktype) == ChatFormats.CLICK_GOODS)
         {
            _loc2_ = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = _loc2_.x;
            this._goodTipPos.y = _loc2_.y;
            _loc17_ = ItemManager.Instance.getTemplateById(_loc20_.templeteIDorItemID);
            _loc17_.BindType = _loc20_.isBind == "true" ? int(0) : int(1);
            this.chat_system::showLinkGoodsInfo(_loc17_);
         }
         else if(int(_loc20_.clicktype) == ChatFormats.CLICK_INVENTORY_GOODS)
         {
            _loc4_ = PlayerManager.Instance.Self.ZoneID;
            _loc5_ = int(_loc20_.zoneID);
            if(_loc5_ > 0 && _loc5_ != _loc4_)
            {
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("core.crossZone.ViewGoodInfoUnable"));
               return;
            }
            _loc2_ = this._contentField.localToGlobal(new Point(this._contentField.mouseX,this._contentField.mouseY));
            this._goodTipPos.x = _loc2_.x;
            this._goodTipPos.y = _loc2_.y;
            if(_loc20_.key != "null")
            {
               if(_loc20_.type == String(20) || _loc20_.type == String(18))
               {
                  _loc19_ = ChatManager.Instance.model.getLinkCardInfo(_loc20_.key);
               }
               else
               {
                  _loc18_ = ChatManager.Instance.model.getLink(_loc20_.key);
               }
            }
            else
            {
               _loc18_ = ChatManager.Instance.model.getLink(_loc20_.templeteIDorItemID);
            }
            if(Boolean(_loc18_) || Boolean(_loc19_))
            {
               if(Boolean(_loc18_))
               {
                  this.chat_system::showLinkGoodsInfo(_loc18_);
               }
               if(Boolean(_loc19_))
               {
                  this.chat_system::showLinkGoodsInfo(_loc19_.templateInfo,0,_loc19_);
               }
            }
            else if(_loc20_.key != "null")
            {
               if(_loc20_.type == String(20) || _loc20_.type == String(18))
               {
                  SocketManager.Instance.out.sendGetLinkGoodsInfo(4,String(_loc20_.key));
               }
               else
               {
                  SocketManager.Instance.out.sendGetLinkGoodsInfo(3,String(_loc20_.key));
               }
            }
            else
            {
               SocketManager.Instance.out.sendGetLinkGoodsInfo(2,String(_loc20_.templeteIDorItemID));
            }
         }
         else if(int(_loc20_.clicktype) == ChatFormats.CLICK_DIFF_ZONE)
         {
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.view.chatFormat.cross"));
         }
         else if(int(_loc20_.clicktype) == ChatFormats.CLICK_EFFORT)
         {
            if(!EffortManager.Instance.getMainFrameVisible())
            {
               EffortManager.Instance.isSelf = true;
               EffortManager.Instance.switchVisible();
            }
         }
         else if(int(_loc20_.clicktype) == 108)
         {
            if(StateManager.currentStateType != "main")
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.pay.tipTxt"));
               return;
            }
            AvatarCollectionManager.instance.isSkipFromHall = true;
            BagAndInfoManager.Instance.showBagAndInfo(5);
         }
         else if(int(_loc20_.clicktype) > ChatFormats.CLICK_ACT_TIP)
         {
            if(getTimer() - this._lastClickTime < 2000)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.npc.clickTip"));
               return;
            }
            this._lastClickTime = getTimer();
            if(StateManager.currentStateType != "main")
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wonderfulActivity.getRewardTip"));
               return;
            }
            WonderfulActivityManager.Instance.clickWonderfulActView = true;
            WonderfulActivityManager.Instance.isSkipFromHall = true;
            WonderfulActivityManager.Instance.skipType = _loc20_.rewardType;
            SocketManager.Instance.out.requestWonderfulActInit(1);
         }
      }
      
      private function __stageClickHandler(param1:MouseEvent = null) : void
      {
         if(Boolean(param1))
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         }
         if(this._tipStageClickCount > 0)
         {
            if(Boolean(this._goodTip) && Boolean(this._goodTip.parent))
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            if(Boolean(this._cardTipPnl) && Boolean(this._cardTipPnl.parent))
            {
               this._cardTipPnl.parent.removeChild(this._cardTipPnl);
            }
            if(Boolean(this._cardboxTip) && Boolean(this._cardboxTip.parent))
            {
               this._cardboxTip.parent.removeChild(this._cardboxTip);
            }
            if(Boolean(StageReferance.stage))
            {
               StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClickHandler);
            }
         }
         else
         {
            ++this._tipStageClickCount;
         }
      }
      
      private function disposeView() : void
      {
         if(Boolean(this._contentField))
         {
            this.t_text = this._contentField.htmlText;
            removeChild(this._contentField);
         }
      }
      
      private function initEvent() : void
      {
         this._contentField.addEventListener(Event.SCROLL,this.__onScrollChanged);
         this._contentField.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      private function initView() : void
      {
         this._contentField = new TextField();
         this._contentField.multiline = true;
         this._contentField.wordWrap = true;
         this._contentField.filters = [new GlowFilter(0,1,4,4,8)];
         this._contentField.mouseWheelEnabled = false;
         Helpers.setTextfieldFormat(this._contentField,{"size":12});
         this.updateScrollRect(NORMAL_WIDTH,NORMAL_HEIGHT);
         addChild(this._contentField);
      }
      
      private function onScrollChanged() : void
      {
         dispatchEvent(new ChatEvent(ChatEvent.SCROLL_CHANG));
      }
      
      private function updateScrollRect(param1:Number, param2:Number) : void
      {
         this._srcollRect = new Rectangle(0,0,param1,param2);
         this._contentField.scrollRect = this._srcollRect;
      }
   }
}
