package cryptBoss.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import cryptBoss.CryptBossControl;
   import cryptBoss.data.CryptBossItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CryptBossSetFrame extends Frame
   {
       
      
      private var _data:CryptBossItemInfo;
      
      private var _bossIcon:Bitmap;
      
      private var _itemBg:Bitmap;
      
      private var _levelBg:Bitmap;
      
      private var _fightBtn:SimpleBitmapButton;
      
      private var _levelComboBox:ComboBox;
      
      private var _levelArr:Array;
      
      private var _cellVec:Vector.<BaseCell>;
      
      private var _list:SimpleTileList;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _level:int;
      
      private var _clickTime:Number = 0;
      
      public function CryptBossSetFrame(param1:CryptBossItemInfo)
      {
         super();
         this._data = param1;
         this._levelArr = LanguageMgr.GetTranslation("cryptBoss.setFrame.levelTxt").split(",");
         this._cellVec = new Vector.<BaseCell>();
         this._level = this._data.star == 5 ? this._data.star : this._data.star + 1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("cryptBoss.setFrame.titleTxt");
         this._bossIcon = ComponentFactory.Instance.creat("asset.cryptBoss.boss" + this._data.id);
         PositionUtils.setPos(this._bossIcon,"cryptBoss.setFrame.bossPos");
         addToContent(this._bossIcon);
         this._itemBg = ComponentFactory.Instance.creat("asset.cryptBoss.itemBg");
         addToContent(this._itemBg);
         this._levelBg = ComponentFactory.Instance.creat("asset.cryptBoss.levelSelect");
         addToContent(this._levelBg);
         this._levelComboBox = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.levelChooseComboBox");
         addToContent(this._levelComboBox);
         this._fightBtn = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.fightBtn");
         addToContent(this._fightBtn);
         this._fightBtn.enable = this._data.state == 1;
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.setFrame.dropListPanel");
         this._scrollPanel.vScrollProxy = 1;
         this._scrollPanel.hScrollProxy = 2;
         addToContent(this._scrollPanel);
         this._list = new SimpleTileList(5);
         this._list.hSpace = 4;
         this._list.vSpace = 5;
         this.updateLevelComboBox();
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var _loc6_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         while(this._cellVec.length > 0)
         {
            (_loc1_ = this._cellVec.shift()).dispose();
         }
         var _loc4_:Array = CryptBossControl.instance.getTemplateIdArr(50200 + this._data.id,this._level);
         var _loc5_:Rectangle = ComponentFactory.Instance.creatCustomObject("cryptBoss.setFrame.cellRect");
         for each(_loc6_ in _loc4_)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(_loc6_);
            (_loc3_ = new BaseCell(ComponentFactory.Instance.creatBitmap("cryptBoss.dropCellBgAsset"),_loc2_)).setContentSize(_loc5_.width,_loc5_.height);
            _loc3_.PicPos = new Point(_loc5_.x,_loc5_.y);
            this._list.addChild(_loc3_);
            this._cellVec.push(_loc3_);
         }
         this._scrollPanel.setView(this._list);
         this._scrollPanel.invalidateViewport();
      }
      
      private function updateLevelComboBox() : void
      {
         var _loc1_:int = 0;
         this._levelComboBox.beginChanges();
         this._levelComboBox.selctedPropName = "text";
         var _loc2_:VectorListModel = this._levelComboBox.listPanel.vectorListModel;
         _loc2_.clear();
         _loc1_ = 0;
         while(_loc1_ < this._data.star + 1 && _loc1_ < this._levelArr.length)
         {
            _loc2_.append(this._levelArr[_loc1_]);
            _loc1_++;
         }
         this._levelComboBox.listPanel.list.updateListView();
         this._levelComboBox.commitChanges();
         this._levelComboBox.textField.text = this._levelArr[this._level - 1];
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._level == param1.index + 1)
         {
            return;
         }
         this._level = param1.index + 1;
         this.updateItems();
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         this._levelComboBox.listPanel.list.addEventListener("listItemClick",this.__itemClick);
         this._levelComboBox.button.addEventListener("click",this.__buttonClick);
         this._fightBtn.addEventListener("click",this.__fightHandler);
      }
      
      protected function __fightHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 45)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",45));
            return;
         }
         if(new Date().time - this._clickTime > 1000)
         {
            this._clickTime = new Date().time;
            SocketManager.Instance.out.sendCryptBossFight(this._data.id,this._level);
         }
      }
      
      private function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
         this._levelComboBox.listPanel.list.removeEventListener("listItemClick",this.__itemClick);
         this._levelComboBox.button.removeEventListener("click",this.__buttonClick);
         this._fightBtn.removeEventListener("click",this.__fightHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bossIcon = null;
         this._itemBg = null;
         this._levelBg = null;
         this._fightBtn = null;
         this._levelComboBox = null;
         this._list = null;
         this._scrollPanel = null;
         this._cellVec = null;
      }
   }
}
