package ddt.dailyRecord
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DailyRecordControl extends EventDispatcher
   {
      
      public static const RECORDLIST_IS_READY:String = "recordListIsReady";
      
      private static var _instance:ddt.dailyRecord.DailyRecordControl;
       
      
      public var recordList:Vector.<ddt.dailyRecord.DailiyRecordInfo>;
      
      public function DailyRecordControl()
      {
         super();
         this.recordList = new Vector.<DailiyRecordInfo>();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILYRECORD,this.daily);
         ServerManager.Instance.addEventListener(ServerManager.CHANGE_SERVER,this.__changeServerHandler);
      }
      
      public static function get Instance() : ddt.dailyRecord.DailyRecordControl
      {
         if(_instance == null)
         {
            _instance = new ddt.dailyRecord.DailyRecordControl();
         }
         return _instance;
      }
      
      private function __changeServerHandler(param1:Event) : void
      {
         this.recordList = new Vector.<DailiyRecordInfo>();
      }
      
      private function daily(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:ddt.dailyRecord.DailiyRecordInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new ddt.dailyRecord.DailiyRecordInfo();
            _loc2_.type = param1.pkg.readInt();
            _loc2_.value = param1.pkg.readUTF();
            if(this.recordList.length == 0)
            {
               this.recordList.push(_loc2_);
            }
            else if(this.isUpdate(_loc2_.type))
            {
               _loc3_ = 0;
               while(_loc3_ < this.recordList.length)
               {
                  if(this.recordList[_loc3_].type == _loc2_.type)
                  {
                     this.recordList[_loc3_].value = _loc2_.value;
                     break;
                  }
                  if(_loc3_ == this.recordList.length - 1)
                  {
                     this.sortPos(_loc2_);
                     break;
                  }
                  _loc3_++;
               }
            }
            else
            {
               this.sortPos(_loc2_);
            }
            _loc5_++;
         }
         dispatchEvent(new Event(RECORDLIST_IS_READY));
      }
      
      private function sortPos(param1:ddt.dailyRecord.DailiyRecordInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.recordList.length)
         {
            if(_loc2_ == this.recordList.length - 1)
            {
               if(param1.type < this.recordList[_loc2_].type)
               {
                  this.recordList.unshift(param1);
               }
               else
               {
                  this.recordList.push(param1);
               }
               break;
            }
            if(param1.type >= this.recordList[_loc2_].type && param1.type < this.recordList[_loc2_ + 1].type)
            {
               this.recordList.splice(_loc2_ + 1,0,param1);
               break;
            }
            _loc2_++;
         }
      }
      
      private function isUpdate(param1:int) : Boolean
      {
         switch(param1)
         {
            case 10:
            case 16:
            case 17:
            case 18:
            case 19:
            case 11:
            case 12:
            case 13:
            case 15:
            case 14:
            case 20:
               return true;
            default:
               return false;
         }
      }
      
      public function alertDailyFrame() : void
      {
         SocketManager.Instance.out.sendDailyRecord();
         var _loc1_:DailyRecordFrame = ComponentFactory.Instance.creatComponentByStylename("dailyRecordFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}
