package ddt.view.caddyII.reader
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.tips.CardBoxTipPanel;
   import ddt.view.tips.GoodTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class ReadAwardsView extends Sprite implements Disposeable, CaddyUpdate
   {
       
      
      private var _bg1:Scale9CornerImage;
      
      protected var _bg2:ScaleBitmapImage;
      
      private var _node:Bitmap;
      
      protected var _list:VBox;
      
      protected var _panel:ScrollPanel;
      
      private var _goodTip:GoodTip;
      
      private var _cardTip:CardBoxTipPanel;
      
      protected var _goodTipPos:Point;
      
      private var _tipStageClickCount:int;
      
      private var _isMySelf:Boolean;
      
      private var tempArr:Vector.<ddt.view.caddyII.reader.AwardsInfo>;
      
      public function ReadAwardsView()
      {
         super();
         this.initView();
         this.initEvents();
         this.requestAwards();
      }
      
      protected function initView() : void
      {
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("caddy.readAwardsBGI");
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("caddy.readAwardsBGII");
         this._node = ComponentFactory.Instance.creatBitmap("asset.caddy.AwardsNode");
         this._list = ComponentFactory.Instance.creatComponentByStylename("caddy.readVBox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("caddy.ReaderScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._bg1);
         addChild(this._bg2);
         addChild(this._panel);
         addChild(this._node);
         this._goodTipPos = new Point();
         this._panel.invalidateViewport(true);
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_AWARDS,this._getAwards);
         CaddyModel.instance.addEventListener(CaddyModel.AWARDS_CHANGE,this._awardsChange);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CADDY_GET_AWARDS,this._getAwards);
         CaddyModel.instance.removeEventListener(CaddyModel.AWARDS_CHANGE,this._awardsChange);
      }
      
      private function requestAwards() : void
      {
         SocketManager.Instance.out.sendRequestAwards(CaddyModel.instance.type + 2);
      }
      
      private function _getAwards(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:ddt.view.caddyII.reader.AwardsInfo = null;
         var _loc3_:PackageIn = param1.pkg;
         this._isMySelf = _loc3_.readBoolean();
         var _loc4_:int = _loc3_.readInt();
         this.tempArr = new Vector.<AwardsInfo>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new ddt.view.caddyII.reader.AwardsInfo();
            _loc2_.name = _loc3_.readUTF();
            _loc2_.TemplateId = _loc3_.readInt();
            _loc2_.zoneID = _loc3_.readInt();
            _loc2_.isLong = _loc3_.readBoolean();
            if(_loc2_.isLong)
            {
               _loc2_.zone = _loc3_.readUTF();
            }
            this.tempArr.push(_loc2_);
            _loc5_++;
         }
         if(this._isMySelf)
         {
            CaddyModel.instance.clearAwardsList();
         }
         CaddyModel.instance.addAwardsInfoByArr(this.tempArr);
      }
      
      private function removeListChildEvent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._list.numChildren)
         {
            _loc1_++;
         }
      }
      
      private function _awardsChange(param1:Event) : void
      {
         this.removeListChildEvent();
         this._list.disposeAllChildren();
         var _loc2_:int = 0;
         while(_loc2_ < CaddyModel.instance.awardsList.length)
         {
            this.addItem(CaddyModel.instance.awardsList[_loc2_]);
            _loc2_++;
         }
         this._panel.invalidateViewport(true);
         this._panel.vScrollbar.scrollValue = 0;
      }
      
      private function _showLinkGoodsInfo(param1:CaddyEvent) : void
      {
         this._goodTipPos.x = param1.point.x;
         this._goodTipPos.y = param1.point.y;
         this.showLinkGoodsInfo(param1.itemTemplateInfo);
      }
      
      private function showLinkGoodsInfo(param1:ItemTemplateInfo, param2:uint = 0) : void
      {
         if(param1.CategoryID == EquipType.CARDBOX)
         {
            if(this._cardTip == null)
            {
               this._cardTip = new CardBoxTipPanel();
            }
            this._cardTip.tipData = param1;
            this.setTipPos(this._cardTip);
         }
         else
         {
            if(!this._goodTip)
            {
               this._goodTip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTip");
            }
            this._goodTip.showTip(param1);
            this.setTipPos(this._goodTip);
         }
         this._tipStageClickCount = param2;
      }
      
      private function setTipPos(param1:BaseTip) : void
      {
         param1.x = this._goodTipPos.x - param1.width;
         param1.y = this._goodTipPos.y - param1.height - 10;
         if(param1.y < 0)
         {
            param1.y = 10;
         }
         StageReferance.stage.addChild(param1);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClickHandler);
      }
      
      private function __stageClickHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(this._tipStageClickCount > 0)
         {
            if(Boolean(this._goodTip))
            {
               this._goodTip.parent.removeChild(this._goodTip);
            }
            if(Boolean(this._cardTip))
            {
               this._cardTip.parent.removeChild(this._cardTip);
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
      
      public function addItem(param1:ddt.view.caddyII.reader.AwardsInfo) : void
      {
         var _loc2_:AwardsItem = new AwardsItem();
         _loc2_.info = param1;
         _loc2_.addEventListener(AwardsItem.GOODSCLICK,this._showLinkGoodsInfo);
         this._list.addChild(_loc2_);
      }
      
      public function update() : void
      {
         if(!this._isMySelf)
         {
            CaddyModel.instance.addAwardsInfoByArr(this.tempArr);
            this._isMySelf = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeListChildEvent();
         this.removeEvents();
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
         }
         this._bg2 = null;
         if(Boolean(this._node))
         {
            ObjectUtils.disposeObject(this._node);
         }
         this._node = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         this._goodTipPos = null;
         this.tempArr = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
