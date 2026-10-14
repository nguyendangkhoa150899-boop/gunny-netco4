package consortionBattle.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.event.ConsBatEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class ConsBatScoreView extends Sprite implements Disposeable
   {
       
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _playerBtn:SelectedButton;
      
      private var _consortiaBtn:SelectedButton;
      
      private var _playerBg:Bitmap;
      
      private var _consortiaBg:Bitmap;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:ListPanel;
      
      private var _selfScoreTxt:FilterFrameText;
      
      private var _consortiaScoreList:Array;
      
      private var _playerScoreList:Array;
      
      private var _timer:Timer;
      
      public function ConsBatScoreView()
      {
         super();
         this.x = 803;
         this.y = 183;
         this.initView();
         this.initEvent();
         this._timer = new Timer(5000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         this._btnGroup.selectIndex = 0;
      }
      
      private function initView() : void
      {
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.moveOutBtn");
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.moveInBtn");
         this.setInOutVisible(true);
         this._playerBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.playerBtn");
         this._consortiaBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.consortiaBtn");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._consortiaBtn);
         this._btnGroup.addSelectItem(this._playerBtn);
         this._playerBg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.scoreView.player.bg");
         this._consortiaBg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.scoreView.consortia.bg");
         this._selfScoreTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.selfTxt");
         this._selfScoreTxt.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.scoreView.selfScoreTxt") + ConsortiaBattleManager.instance.score;
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.list");
         addChild(this._moveOutBtn);
         addChild(this._moveInBtn);
         addChild(this._playerBtn);
         addChild(this._consortiaBtn);
         addChild(this._playerBg);
         addChild(this._consortiaBg);
         addChild(this._selfScoreTxt);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._moveOutBtn.addEventListener(MouseEvent.CLICK,this.outHandler,false,0,true);
         this._moveInBtn.addEventListener(MouseEvent.CLICK,this.inHandler,false,0,true);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._playerBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._consortiaBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.UPDATE_SCORE,this.updateScore);
      }
      
      private function updateScore(param1:ConsBatEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:PackageIn = param1.data as PackageIn;
         var _loc10_:int = _loc9_.readByte();
         if(_loc10_ == 1)
         {
            this._consortiaScoreList = [];
            _loc2_ = _loc9_.readInt();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = {};
               _loc5_.name = _loc9_.readUTF();
               _loc5_.rank = _loc9_.readInt();
               _loc5_.score = _loc9_.readInt();
               this._consortiaScoreList.push(_loc5_);
               _loc3_++;
            }
            this._consortiaScoreList.sortOn("score",Array.NUMERIC | Array.DESCENDING);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this._consortiaScoreList[_loc4_].rank = _loc4_ + 1;
               _loc4_++;
            }
         }
         else
         {
            this._playerScoreList = [];
            _loc6_ = _loc9_.readInt();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = {};
               _loc8_.name = _loc9_.readUTF();
               _loc8_.rank = _loc9_.readInt();
               _loc8_.score = _loc9_.readInt();
               this._playerScoreList.push(_loc8_);
               _loc7_++;
            }
            this._playerScoreList.sortOn("rank",Array.NUMERIC);
         }
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._consortiaScoreList);
               this._list.list.updateListView();
               break;
            case 1:
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._playerScoreList);
               this._list.list.updateListView();
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._playerBg.visible = false;
               this._consortiaBg.visible = true;
               this._list.y = 13;
               this._selfScoreTxt.visible = false;
               this._consortiaBtn.x = 8;
               this._consortiaBtn.y = -32;
               this._playerBtn.x = 93;
               this._playerBtn.y = -26;
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._consortiaScoreList);
               this._list.list.updateListView();
               this._timer.reset();
               this._timer.start();
               SocketManager.Instance.out.sendConsBatUpdateScore(1);
               break;
            case 1:
               this._playerBg.visible = true;
               this._consortiaBg.visible = false;
               this._list.y = 37;
               this._selfScoreTxt.visible = true;
               this._consortiaBtn.x = 6;
               this._consortiaBtn.y = -26;
               this._playerBtn.x = 85;
               this._playerBtn.y = -31;
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._playerScoreList);
               this._list.list.updateListView();
               this._timer.reset();
               this._timer.start();
               SocketManager.Instance.out.sendConsBatUpdateScore(2);
         }
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         if(this._btnGroup.selectIndex == 0)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = 2;
         }
         SocketManager.Instance.out.sendConsBatUpdateScore(_loc2_);
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(false);
         TweenLite.to(this,0.5,{"x":999});
      }
      
      private function setInOutVisible(param1:Boolean) : void
      {
         this._moveOutBtn.visible = param1;
         this._moveInBtn.visible = !param1;
      }
      
      private function inHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(true);
         TweenLite.to(this,0.5,{"x":803});
      }
      
      private function removeEvent() : void
      {
         this._moveOutBtn.removeEventListener(MouseEvent.CLICK,this.outHandler);
         this._moveInBtn.removeEventListener(MouseEvent.CLICK,this.inHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._playerBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._consortiaBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.UPDATE_SCORE,this.updateScore);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._moveOutBtn = null;
         this._moveInBtn = null;
         this._playerBtn = null;
         this._consortiaBtn = null;
         this._playerBg = null;
         this._consortiaBg = null;
         this._selfScoreTxt = null;
         this._list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
