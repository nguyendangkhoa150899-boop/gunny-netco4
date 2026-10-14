package quest
{
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TaskManager;
   
   public class QuestBubbleMode
   {
       
      
      private var _questInfoCompleteArr:Array;
      
      private var _questInfoArr:Array;
      
      private var _questInfoTxtArr:Array;
      
      private var _isShowIn:Boolean;
      
      public function QuestBubbleMode()
      {
         super();
      }
      
      public function get questsInfo() : Array
      {
         var _loc1_:Array = [];
         this._questInfoCompleteArr = [];
         this._questInfoArr = [];
         _loc1_ = TaskManager.getAvailableQuests().list;
         return this._reseachComplete(_loc1_);
      }
      
      private function _addInfoToArr(param1:QuestInfo) : void
      {
         if(param1.canViewWithProgress && this._questInfoArr.length < 5 && (!this._isShowIn || this._isShowIn && param1.isCompleted))
         {
            this._questInfoArr.push(param1);
         }
      }
      
      private function _reseachComplete(param1:Array) : Array
      {
         this._reseachInfoForId(param1);
         return this._setTxtInArr();
      }
      
      private function _setTxtInArr() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = new Array();
         var _loc9_:int = 0;
         for(; _loc9_ < this._questInfoArr.length; _loc9_++)
         {
            if(QuestInfo(this._questInfoArr[_loc9_]).Type == 3)
            {
               if(QuestInfo(this._questInfoArr[_loc9_]).id >= 2000 && QuestInfo(this._questInfoArr[_loc9_]).id <= 2018)
               {
                  continue;
               }
            }
            _loc1_ = 0;
            _loc2_ = Number(QuestInfo(this._questInfoArr[_loc9_]).progress[0]);
            _loc3_ = Number(QuestInfo(this._questInfoArr[_loc9_])._conditions[0].target);
            _loc4_ = 1;
            while(Boolean(QuestInfo(this._questInfoArr[_loc9_])._conditions[_loc4_]))
            {
               _loc6_ = int(QuestInfo(this._questInfoArr[_loc9_]).progress[_loc4_]);
               _loc7_ = int(QuestInfo(this._questInfoArr[_loc9_])._conditions[_loc4_].target);
               if(_loc6_ != 0)
               {
                  if(_loc6_ / _loc7_ < _loc2_ / _loc3_ || _loc2_ == 0)
                  {
                     _loc2_ = _loc6_;
                     _loc3_ = _loc7_;
                     _loc1_ = _loc4_;
                  }
               }
               _loc4_++;
            }
            _loc5_ = new Object();
            switch(QuestInfo(this._questInfoArr[_loc9_]).Type)
            {
               case 0:
                  _loc5_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.TankLink");
                  break;
               case 1:
                  _loc5_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.BranchLine");
                  break;
               case 2:
                  _loc5_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Daily");
                  break;
               case 3:
                  _loc5_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.Act");
                  break;
               case 4:
                  _loc5_.txtI = LanguageMgr.GetTranslation("tank.view.quest.bubble.VIP");
            }
            if(QuestInfo(this._questInfoArr[_loc9_]).isCompleted)
            {
               _loc5_.txtI = "<font COLOR=\'#8be961\'>" + _loc5_.txtI + "</font>";
               _loc5_.txtII = "<font COLOR=\'#8be961\'>" + this._analysisStrIII(QuestInfo(this._questInfoArr[_loc9_])) + "</font>";
               _loc5_.txtIII = "<font COLOR=\'#8be961\'>" + this._analysisStrIV(QuestInfo(this._questInfoArr[_loc9_])) + "</font>";
            }
            else
            {
               _loc5_.txtII = this._analysisStrII(QuestInfo(this._questInfoArr[_loc9_])._conditions[_loc1_].description);
               _loc5_.txtIII = QuestInfo(this._questInfoArr[_loc9_]).conditionStatus[_loc1_];
            }
            _loc8_.push(_loc5_);
         }
         return _loc8_;
      }
      
      private function _analysisStrII(param1:String) : String
      {
         var _loc2_:String = null;
         if(param1.length <= 6)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = param1.substr(0,6);
            _loc2_ += "...";
         }
         return _loc2_;
      }
      
      private function _analysisStrIII(param1:QuestInfo) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1._conditions.length)
         {
            if(param1.progress[_loc3_] <= 0)
            {
               return String(param1._conditions[_loc3_].description);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function _analysisStrIV(param1:QuestInfo) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1._conditions.length)
         {
            if(param1.progress[_loc3_] <= 0)
            {
               return String(param1.conditionStatus[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function _reseachInfoForId(param1:Array) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:IndexObj = null;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = QuestInfo(param1[_loc5_]).questProgressNum;
            _loc3_ = new IndexObj(_loc5_,_loc2_);
            _loc4_.push(_loc3_);
            _loc5_++;
         }
         _loc4_.sortOn("progressNum",Array.NUMERIC);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            this._questInfoCompleteArr.push(QuestInfo(param1[_loc4_[_loc5_].id]));
            _loc5_++;
         }
         var _loc6_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < this._questInfoCompleteArr.length)
         {
            if(this._questInfoCompleteArr[_loc5_].questProgressNum != this._questInfoCompleteArr[_loc6_].questProgressNum)
            {
               this._checkInfoArr(4,_loc6_,_loc5_);
               this._checkInfoArr(3,_loc6_,_loc5_);
               this._checkInfoArr(2,_loc6_,_loc5_);
               this._checkInfoArr(0,_loc6_,_loc5_);
               this._checkInfoArr(1,_loc6_,_loc5_);
               _loc6_ = _loc5_;
            }
            _loc5_++;
         }
         this._checkInfoArr(4,_loc6_,this._questInfoCompleteArr.length);
         this._checkInfoArr(3,_loc6_,this._questInfoCompleteArr.length);
         this._checkInfoArr(2,_loc6_,this._questInfoCompleteArr.length);
         this._checkInfoArr(0,_loc6_,this._questInfoCompleteArr.length);
         this._checkInfoArr(1,_loc6_,this._questInfoCompleteArr.length);
      }
      
      private function _checkInfoArr(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = param2;
         while(_loc4_ < param3)
         {
            if(QuestInfo(this._questInfoCompleteArr[_loc4_]).Type == param1)
            {
               this._addInfoToArr(this._questInfoCompleteArr[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      public function getQuestInfoById(param1:int) : QuestInfo
      {
         return this._questInfoArr[param1];
      }
   }
}

class IndexObj
{
    
   
   public var id:int;
   
   public var progressNum:Number;
   
   public function IndexObj(param1:int, param2:Number)
   {
      super();
      this.id = param1;
      this.progressNum = param2;
   }
}
