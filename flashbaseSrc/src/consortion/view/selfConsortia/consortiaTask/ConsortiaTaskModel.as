package consortion.view.selfConsortia.consortiaTask
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   public class ConsortiaTaskModel extends EventDispatcher
   {
      
      public static const RELEASE_TASK:int = 0;
      
      public static const RESET_TASK:int = 1;
      
      public static const SUMBIT_TASK:int = 2;
      
      public static const GET_TASKINFO:int = 3;
      
      public static const UPDATE_TASKINFO:int = 4;
      
      public static const SUCCESS_FAIL:int = 5;
       
      
      public var taskInfo:consortion.view.selfConsortia.consortiaTask.ConsortiaTaskInfo;
      
      public var isHaveTask_noRelease:Boolean = false;
      
      public function ConsortiaTaskModel(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE,this.__releaseTaskCallBack);
      }
      
      private function __releaseTaskCallBack(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:PackageIn = param1.pkg as PackageIn;
         var _loc20_:int = _loc19_.readByte();
         if(_loc20_ == SUMBIT_TASK)
         {
            _loc2_ = _loc19_.readBoolean();
            if(!_loc2_)
            {
               this.taskInfo = null;
            }
         }
         else if(_loc20_ == SUCCESS_FAIL)
         {
            _loc3_ = _loc19_.readBoolean();
            this.taskInfo = null;
         }
         else if(_loc20_ == UPDATE_TASKINFO)
         {
            _loc4_ = _loc19_.readInt();
            _loc5_ = _loc19_.readInt();
            _loc6_ = _loc19_.readInt();
            if(this.taskInfo != null)
            {
               this.taskInfo.updateItemData(_loc4_,_loc5_,_loc6_);
            }
         }
         else if(_loc20_ == RELEASE_TASK || _loc20_ == RESET_TASK)
         {
            _loc7_ = _loc19_.readInt();
            this.taskInfo = new consortion.view.selfConsortia.consortiaTask.ConsortiaTaskInfo();
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc19_.readInt();
               _loc10_ = _loc19_.readUTF();
               this.taskInfo.addItemData(_loc9_,_loc10_);
               _loc8_++;
            }
         }
         else
         {
            _loc11_ = _loc19_.readInt();
            if(_loc11_ > 0)
            {
               this.taskInfo = new consortion.view.selfConsortia.consortiaTask.ConsortiaTaskInfo();
               _loc12_ = 0;
               while(_loc12_ < _loc11_)
               {
                  _loc13_ = _loc19_.readInt();
                  _loc14_ = _loc19_.readInt();
                  _loc15_ = _loc19_.readUTF();
                  _loc16_ = _loc19_.readInt();
                  _loc17_ = _loc19_.readInt();
                  _loc18_ = _loc19_.readInt();
                  this.taskInfo.addItemData(_loc13_,_loc15_,_loc14_,_loc16_,_loc17_,_loc18_);
                  _loc12_++;
               }
               this.taskInfo.sortItem();
               this.taskInfo.exp = _loc19_.readInt();
               this.taskInfo.offer = _loc19_.readInt();
               this.taskInfo.riches = _loc19_.readInt();
               this.taskInfo.buffID = _loc19_.readInt();
               this.taskInfo.beginTime = _loc19_.readDate();
               this.taskInfo.time = _loc19_.readInt();
            }
            else if(_loc11_ == -1)
            {
               this.taskInfo = null;
               this.isHaveTask_noRelease = true;
            }
            else
            {
               this.taskInfo = null;
            }
         }
         var _loc21_:ConsortiaTaskEvent = new ConsortiaTaskEvent(ConsortiaTaskEvent.GETCONSORTIATASKINFO);
         _loc21_.value = _loc20_;
         dispatchEvent(_loc21_);
      }
      
      public function showReleaseFrame() : void
      {
         if(this.taskInfo != null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.released"));
            return;
         }
         if(this.isHaveTask_noRelease)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.havetaskNoRelease"));
         }
         var _loc1_:ConsortiaReleaseTaskFrame = ComponentFactory.Instance.creatComponentByStylename("ConsortiaReleaseTaskFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
