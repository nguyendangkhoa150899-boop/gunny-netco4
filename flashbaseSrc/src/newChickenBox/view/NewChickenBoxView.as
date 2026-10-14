package newChickenBox.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   import newChickenBox.model.NewChickenBoxModel;
   
   public class NewChickenBoxView extends Sprite implements Disposeable
   {
      
      private static const NUM:int = 18;
       
      
      private var _model:NewChickenBoxModel;
      
      private var eyeItem:newChickenBox.view.NewChickenBoxItem;
      
      private var frame:BaseAlerFrame;
      
      private var moveBackArr:Array;
      
      public function NewChickenBoxView()
      {
         super();
         this._model = NewChickenBoxModel.instance;
         this.init();
      }
      
      private function init() : void
      {
         this.moveBackArr = new Array();
         if(this._model.isShowAll)
         {
            this.getAllItem();
         }
         else
         {
            this.updataAllItem();
         }
      }
      
      public function getAllItem() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:NewChickenBoxGoodsTempInfo = null;
         var _loc5_:Sprite = null;
         var _loc6_:NewChickenBoxCell = null;
         var _loc7_:MovieClip = null;
         var _loc8_:newChickenBox.view.NewChickenBoxItem = null;
         var _loc9_:int = Math.random() * 18;
         var _loc10_:int = this.getNum(_loc9_);
         var _loc11_:int = 0;
         while(_loc11_ < NUM)
         {
            _loc1_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            _loc2_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            _loc3_ = "newChickenBox.itemPos" + _loc11_;
            _loc4_ = this._model.templateIDList[_loc11_];
            _loc5_ = new Sprite();
            _loc5_.graphics.beginFill(16777215,0);
            _loc5_.graphics.drawRect(0,0,39,39);
            _loc5_.graphics.endFill();
            _loc6_ = new NewChickenBoxCell(_loc5_,_loc4_.info);
            if(_loc11_ == _loc9_ || _loc11_ == _loc10_)
            {
               _loc7_ = _loc2_;
               this.moveBackArr.push(_loc11_);
            }
            else
            {
               _loc7_ = _loc1_;
            }
            _loc8_ = new newChickenBox.view.NewChickenBoxItem(_loc6_,_loc7_);
            _loc8_.info = _loc4_;
            _loc8_.updateCount();
            _loc8_.addEventListener(MouseEvent.CLICK,this.tackoverCard);
            _loc8_.position = _loc11_;
            PositionUtils.setPos(_loc8_,_loc3_);
            if(this._model.itemList.length == 18)
            {
               this._model.itemList[_loc11_].dispose();
               this._model.itemList[_loc11_] = null;
               this._model.itemList[_loc11_] = _loc8_;
            }
            else
            {
               this._model.itemList.push(_loc8_);
            }
            addChild(_loc8_);
            _loc11_++;
         }
      }
      
      private function openAlertFrame(param1:newChickenBox.view.NewChickenBoxItem) : BaseAlerFrame
      {
         var _loc2_:String = LanguageMgr.GetTranslation("newChickenBox.EagleEye.msg",this._model.canEagleEyeCounts - this._model.countEye,this._model.eagleEyePrice[this._model.countEye]);
         var _loc3_:SelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.selectBnt2");
         _loc3_.text = LanguageMgr.GetTranslation("newChickenBox.noAlert");
         _loc3_.addEventListener(MouseEvent.CLICK,this.noAlertEable);
         if(Boolean(this.frame))
         {
            ObjectUtils.disposeObject(this.frame);
         }
         this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("newChickenBox.newChickenTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2);
         this.frame.addChild(_loc3_);
         this.frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this.eyeItem = param1;
         return this.frame;
      }
      
      private function noAlertEable(param1:MouseEvent) : void
      {
         var _loc2_:SelectedCheckButton = param1.currentTarget as SelectedCheckButton;
         if(_loc2_.selected)
         {
            this._model.alertEye = false;
         }
         else
         {
            this._model.alertEye = true;
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendChickenBoxUseEagleEye(this.eyeItem);
         }
      }
      
      public function getItemEvent(param1:newChickenBox.view.NewChickenBoxItem) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.tackoverCard);
      }
      
      public function removeItemEvent(param1:newChickenBox.view.NewChickenBoxItem) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.tackoverCard);
         param1.dispose();
      }
      
      public function tackoverCard(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:newChickenBox.view.NewChickenBoxItem = param1.currentTarget as NewChickenBoxItem;
         var _loc4_:NewChickenBoxGoodsTempInfo = _loc3_.info;
         if(this._model.canclickEnable && _loc4_.IsSelected == false)
         {
            if(this._model.clickEagleEye)
            {
               _loc2_ = int(this._model.eagleEyePrice[this._model.countEye]);
               if(PlayerManager.Instance.Self.Money < _loc2_)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               if(_loc4_.IsSeeded)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.useEyeEnable"));
                  return;
               }
               if(this._model.alertEye)
               {
                  if(this._model.countEye < this._model.canEagleEyeCounts)
                  {
                     this._model.dispatchEvent(new Event("mouseShapoff"));
                     this.openAlertFrame(_loc3_);
                  }
                  else
                  {
                     SocketManager.Instance.out.sendChickenBoxUseEagleEye(_loc3_);
                  }
               }
               else
               {
                  SocketManager.Instance.out.sendChickenBoxUseEagleEye(_loc3_);
               }
            }
            else
            {
               _loc2_ = int(this._model.openCardPrice[this._model.countTime]);
               if(PlayerManager.Instance.Self.Money < _loc2_)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               SocketManager.Instance.out.sendChickenBoxTakeOverCard(_loc3_);
            }
            this._model.clickEagleEye = false;
         }
      }
      
      private function getNum(param1:int) : int
      {
         var _loc2_:int = Math.random() * 18;
         if(_loc2_ == param1)
         {
            this.getNum(param1);
         }
         return _loc2_;
      }
      
      public function updataAllItem() : void
      {
         var _loc1_:String = null;
         var _loc2_:NewChickenBoxGoodsTempInfo = null;
         var _loc3_:Sprite = null;
         var _loc4_:NewChickenBoxCell = null;
         var _loc5_:MovieClip = null;
         var _loc6_:newChickenBox.view.NewChickenBoxItem = null;
         var _loc7_:int = Math.random() * 18;
         var _loc8_:int = this.getNum(_loc7_);
         var _loc9_:int = 0;
         while(_loc9_ < this._model.templateIDList.length)
         {
            _loc1_ = "newChickenBox.itemPos" + _loc9_;
            _loc2_ = this._model.templateIDList[_loc9_];
            _loc3_ = new Sprite();
            _loc3_.graphics.beginFill(16777215,0);
            _loc3_.graphics.drawRect(0,0,39,39);
            _loc3_.graphics.endFill();
            _loc4_ = new NewChickenBoxCell(_loc3_,_loc2_.info);
            if((_loc9_ == _loc7_ || _loc9_ == _loc8_) && _loc2_.IsSelected)
            {
               _loc5_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenMove") as MovieClip;
            }
            else if(_loc2_.IsSelected)
            {
               _loc5_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenStand") as MovieClip;
            }
            else if(_loc2_.IsSeeded)
            {
               _loc5_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
               _loc4_.visible = true;
               _loc4_.alpha = 0.5;
            }
            else
            {
               _loc5_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenBack") as MovieClip;
               _loc4_.visible = false;
            }
            _loc6_ = new newChickenBox.view.NewChickenBoxItem(_loc4_,_loc5_);
            _loc6_.info = _loc2_;
            _loc6_.updateCount();
            _loc6_.countTextShowIf();
            _loc6_.addEventListener(MouseEvent.CLICK,this.tackoverCard);
            _loc6_.position = _loc9_;
            PositionUtils.setPos(_loc6_,_loc1_);
            if(this._model.itemList.length == 18)
            {
               this._model.itemList[_loc9_].dispose();
               this._model.itemList[_loc9_] = null;
               this._model.itemList[_loc9_] = _loc6_;
            }
            else
            {
               this._model.itemList.push(_loc6_);
            }
            addChild(_loc6_);
            _loc9_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:newChickenBox.view.NewChickenBoxItem = null;
         if(Boolean(this.frame))
         {
            this.frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.frame.dispose();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._model.templateIDList.length)
         {
            _loc1_ = this._model.itemList[_loc2_] as NewChickenBoxItem;
            _loc1_.dispose();
            _loc1_ = null;
            _loc2_++;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}
