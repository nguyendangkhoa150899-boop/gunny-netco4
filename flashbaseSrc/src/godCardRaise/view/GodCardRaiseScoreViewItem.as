package godCardRaise.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import godCardRaise.GodCardRaiseManager;
   import godCardRaise.info.GodCardPointRewardListInfo;
   
   public class GodCardRaiseScoreViewItem extends Sprite implements Disposeable
   {
       
      
      private var _info:GodCardPointRewardListInfo;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _awardCell:BagCell;
      
      private var _getBtn:BaseButton;
      
      private var _getBmp:Bitmap;
      
      private var _clickNum:Number = 0;
      
      public function GodCardRaiseScoreViewItem(param1:GodCardPointRewardListInfo)
      {
         super();
         this._info = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseScoreViewItem.scoreTxt");
         this._scoreTxt.text = "" + this._info.Point;
         addChild(this._scoreTxt);
         this._awardCell = new BagCell(0);
         PositionUtils.setPos(this._awardCell,"godCardRaiseScoreViewItem.cellPos");
         addChild(this._awardCell);
         var _loc1_:InventoryItemInfo = new InventoryItemInfo();
         _loc1_.TemplateID = this._info.ItemID;
         ItemManager.fill(_loc1_);
         _loc1_.IsBinds = this._info.IsBind;
         _loc1_.MaxCount = this._info.Count;
         _loc1_.Count = this._info.Count;
         _loc1_.ValidDate = this._info.Valid;
         this._awardCell.info = _loc1_;
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("godCardRaiseScoreViewItem.getBtn");
         addChild(this._getBtn);
         this._getBmp = ComponentFactory.Instance.creatBitmap("asset.godCardRaiseScoreViewItem.getBmp");
         addChild(this._getBmp);
         this.updateView();
      }
      
      public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Dictionary = GodCardRaiseManager.Instance.model.awardIds;
         if(_loc2_.hasOwnProperty(this._info.ID))
         {
            this._getBtn.visible = false;
            this._getBmp.visible = true;
            this._getBtn.enable = false;
         }
         else
         {
            _loc1_ = GodCardRaiseManager.Instance.model.score;
            if(_loc1_ >= this._info.Point)
            {
               this._getBtn.visible = true;
               this._getBmp.visible = false;
               this._getBtn.enable = true;
            }
            else
            {
               this._getBtn.visible = true;
               this._getBmp.visible = false;
               this._getBtn.enable = false;
            }
         }
      }
      
      private function __getBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:Number = new Date().time;
         if(_loc2_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc2_;
         GameInSocketOut.sendGodCardPointAwardAttribute(this._info.ID);
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener("click",this.__getBtnHandler);
      }
      
      private function removeEvent() : void
      {
         this._getBtn.removeEventListener("click",this.__getBtnHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         this._scoreTxt = null;
         this._awardCell = null;
         this._getBtn = null;
         this._getBmp = null;
         this._clickNum = 0;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
