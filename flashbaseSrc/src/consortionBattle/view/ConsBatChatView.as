package consortionBattle.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.event.ConsBatEvent;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ConsBatChatView extends Sprite implements Disposeable
   {
       
      
      private var _cellList:Array;
      
      private var _dataList:Array;
      
      public function ConsBatChatView()
      {
         this._dataList = [];
         super();
         this.y = 116;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:ConsBatChatViewCell = null;
         this._cellList = [];
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = new ConsBatChatViewCell();
            _loc1_.index = _loc2_;
            _loc1_.addEventListener(ConsBatChatViewCell.GUARD_COMPLETE,this.guardCompleteHandler,false,0,true);
            _loc1_.addEventListener(ConsBatChatViewCell.DISAPPEAR_COMPLETE,this.disappearCompleteHandler,false,0,true);
            addChild(_loc1_);
            this._cellList.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function guardCompleteHandler(param1:Event) : void
      {
         if(!this._dataList || this._dataList.length <= 0)
         {
            return;
         }
         var _loc2_:ConsBatChatViewCell = param1.target as ConsBatChatViewCell;
         this.changeCellIndex(_loc2_);
         _loc2_.setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
      }
      
      private function disappearCompleteHandler(param1:Event) : void
      {
         var _loc2_:ConsBatChatViewCell = param1.target as ConsBatChatViewCell;
         this.changeCellIndex(_loc2_);
         if(Boolean(this._dataList) && this._dataList.length > 0)
         {
            _loc2_.setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
         }
      }
      
      private function changeCellIndex(param1:ConsBatChatViewCell) : void
      {
         if(param1.index == 0)
         {
            (this._cellList[1] as ConsBatChatViewCell).index = 0;
            (this._cellList[2] as ConsBatChatViewCell).index = 1;
         }
         else if(param1.index == 1)
         {
            (this._cellList[2] as ConsBatChatViewCell).index = 1;
         }
         param1.index = 2;
         this._cellList.sortOn("index",Array.NUMERIC);
      }
      
      private function getTxtStr(param1:Object) : String
      {
         var _loc2_:String = null;
         if(param1.type == 1)
         {
            if(param1.winningStreak == 3)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.threeWinningStreakTxt",param1.winner);
            }
            else if(param1.winningStreak == 6)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.sixWinningStreakTxt",param1.winner);
            }
            else if(param1.winningStreak >= 10)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.tenWinningStreakTxt",param1.winner);
            }
         }
         else
         {
            _loc2_ = LanguageMgr.GetTranslation("ddt.consortiaBattle.chatPrompt.terminatorTxt",param1.winner,param1.loser,param1.winningStreak);
         }
         return _loc2_;
      }
      
      private function initEvent() : void
      {
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.BROADCAST,this.getMessageHandler);
      }
      
      private function getMessageHandler(param1:ConsBatEvent) : void
      {
         var _loc2_:PackageIn = param1.data as PackageIn;
         var _loc3_:Object = {};
         _loc3_.type = _loc2_.readByte();
         if(_loc3_.type == 1)
         {
            _loc3_.winningStreak = _loc2_.readInt();
            _loc3_.winner = _loc2_.readUTF();
         }
         else
         {
            _loc3_.winningStreak = _loc2_.readInt();
            _loc3_.loser = _loc2_.readUTF();
            _loc3_.winner = _loc2_.readUTF();
         }
         this._dataList.push(_loc3_);
         this.setCellTxt();
      }
      
      private function setCellTxt() : void
      {
         var _loc1_:int = int(this._cellList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(!(this._cellList[_loc2_] as ConsBatChatViewCell).isActive)
            {
               this._cellList[_loc2_].setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
               break;
            }
            _loc2_++;
         }
         if(_loc2_ >= _loc1_)
         {
            if(!(this._cellList[0] as ConsBatChatViewCell).isGuard)
            {
               this._cellList[0].setText(this.getTxtStr(this._dataList.splice(0,1)[0]));
               this.changeCellIndex(this._cellList[0] as ConsBatChatViewCell);
            }
         }
      }
      
      public function dispose() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.BROADCAST,this.getMessageHandler);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this._cellList[_loc1_].removeEventListener(ConsBatChatViewCell.GUARD_COMPLETE,this.guardCompleteHandler);
            this._cellList[_loc1_].removeEventListener(ConsBatChatViewCell.DISAPPEAR_COMPLETE,this.disappearCompleteHandler);
            _loc1_++;
         }
         ObjectUtils.disposeAllChildren(this);
         this._cellList = null;
         this._dataList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
