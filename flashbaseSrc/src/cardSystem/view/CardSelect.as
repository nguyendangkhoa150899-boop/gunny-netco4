package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.view.cardCollect.CardSelectItem;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.chat.ChatBasePanel;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class CardSelect extends ChatBasePanel implements Disposeable
   {
       
      
      private var _list:VBox;
      
      private var _bg:ScaleBitmapImage;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<CardSelectItem>;
      
      private var _cardIdVec:Vector.<int>;
      
      public function CardSelect()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._itemList = new Vector.<CardSelectItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.CardListBg");
         this._list = new VBox();
         this._panel = ComponentFactory.Instance.creatComponentByStylename("CardBagView.cardselect");
         this._panel.setView(this._list);
         addChild(this._bg);
         addChild(this._panel);
         this.setList();
      }
      
      private function setList() : void
      {
         var _loc1_:CardSelectItem = null;
         var _loc2_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = new CardSelectItem();
            _loc1_.info = _loc2_[_loc3_];
            _loc1_.addEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            this._itemList.push(_loc1_);
            this._list.addChild(_loc1_);
            _loc3_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function __itemClick(param1:CardEvent) : void
      {
         var _loc2_:SetsInfo = null;
         SoundManager.instance.play("008");
         var _loc3_:int = int(param1.data.id);
         var _loc4_:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for each(_loc2_ in _loc4_)
         {
            if(int(_loc2_.ID) == _loc3_)
            {
               this._cardIdVec = _loc2_.cardIdVec;
               break;
            }
         }
         if(this._cardIdVec != null)
         {
            this.moveAllCard();
         }
      }
      
      private function moveAllCard() : void
      {
         var _loc1_:DictionaryData = null;
         var _loc2_:CardInfo = null;
         var _loc3_:CardInfo = null;
         var _loc4_:int = 0;
         var _loc5_:CardInfo = null;
         var _loc6_:Vector.<CardInfo> = new Vector.<CardInfo>();
         var _loc7_:int = 0;
         while(_loc7_ < this._cardIdVec.length)
         {
            _loc1_ = PlayerManager.Instance.Self.cardBagDic;
            _loc2_ = null;
            for each(_loc3_ in _loc1_)
            {
               if(_loc3_.TemplateID == this._cardIdVec[_loc7_])
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
            if(_loc2_ != null)
            {
               if(_loc2_.templateInfo.Property8 == "1")
               {
                  _loc6_.unshift(_loc2_);
               }
               else
               {
                  _loc6_.push(_loc2_);
               }
            }
            _loc7_++;
         }
         if(_loc6_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.noHaveCard"));
            return;
         }
         if(_loc6_[0].templateInfo.Property8 != "1")
         {
            _loc6_.unshift(_loc6_[0]);
         }
         var _loc8_:Array = this.sortPlaceSelf();
         var _loc9_:Vector.<CardInfo> = this.findCardsOutSelf(_loc6_);
         _loc7_ = 0;
         while(_loc7_ < 5 && _loc7_ < _loc6_.length && _loc9_.length > 0)
         {
            _loc4_ = int(_loc8_[_loc7_]);
            if(this.findCardInSelf(_loc4_,_loc6_))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HaveCard"));
            }
            else
            {
               _loc5_ = _loc9_.shift();
               SocketManager.Instance.out.sendMoveCards(_loc5_.Place,_loc4_);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.card.HaveCard"));
            }
            _loc7_++;
         }
      }
      
      private function sortPlaceSelf() : Array
      {
         var _loc1_:CardInfo = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         if(PlayerManager.Instance.Self.cardEquipDic.length == 0)
         {
            return [0,1,2];
         }
         for each(_loc1_ in PlayerManager.Instance.Self.cardEquipDic)
         {
            if(_loc1_.Count < 0 || _loc1_.templateInfo.Property8 == "1")
            {
               _loc2_.push(_loc1_.Place);
            }
            else
            {
               _loc3_.push(_loc1_.Place);
            }
         }
         return _loc2_.concat(_loc3_);
      }
      
      private function findCardInSelf(param1:int, param2:Vector.<CardInfo>) : Boolean
      {
         var _loc3_:CardInfo = null;
         var _loc4_:CardInfo = null;
         for each(_loc3_ in PlayerManager.Instance.Self.cardEquipDic)
         {
            if(_loc3_.Count > -1 && _loc3_.Place == param1)
            {
               for each(_loc4_ in param2)
               {
                  if(_loc3_.TemplateID == _loc4_.TemplateID)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      private function findCardsOutSelf(param1:Vector.<CardInfo>) : Vector.<CardInfo>
      {
         var _loc2_:CardInfo = null;
         var _loc3_:Vector.<CardInfo> = new Vector.<CardInfo>();
         for each(_loc2_ in param1)
         {
            if(!this.findInfoBytemplateID(_loc2_.TemplateID,PlayerManager.Instance.Self.cardEquipDic))
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      private function findInfoBytemplateID(param1:int, param2:Object) : Boolean
      {
         var _loc3_:CardInfo = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.Count > -1 && _loc3_.TemplateID == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function __hideThis(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(DisplayUtils.isTargetOrContain(_loc2_,this._panel.vScrollbar))
         {
            return;
         }
         SoundManager.instance.play("008");
         setVisible = false;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         while(_loc1_ < this._itemList.length)
         {
            this._itemList[_loc1_].removeEventListener(CardEvent.SELECT_CARDS,this.__itemClick);
            ObjectUtils.disposeObject(this._itemList[_loc1_]);
            this._itemList[_loc1_] = null;
            _loc1_++;
         }
         this._itemList = null;
      }
   }
}
