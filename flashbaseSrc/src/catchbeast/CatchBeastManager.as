package catchbeast
{
   import com.pickgliss.ui.image.MovieImage;
   import ddt.CoreManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class CatchBeastManager extends CoreManager
   {
      
      public static const CATCHBEAST_OPENVIEW:String = "catchBeastOpenView";
      
      private static var _instance:catchbeast.CatchBeastManager;
       
      
      public var RoomType:int = 0;
      
      private var _isBegin:Boolean;
      
      private var _hallView:HallStateView;
      
      private var _catchBeastIcon:MovieImage;
      
      public function CatchBeastManager()
      {
         super();
      }
      
      public static function get instance() : catchbeast.CatchBeastManager
      {
         if(!_instance)
         {
            _instance = new catchbeast.CatchBeastManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener("catchbeast_begin",this.__addCatchBeastBtn);
      }
      
      protected function __addCatchBeastBtn(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         var _loc4_:CrazyTankSocketEvent = null;
         switch(int(_loc3_) - 32)
         {
            case 0:
               this.openOrclose(_loc2_);
               break;
            case 1:
               _loc4_ = new CrazyTankSocketEvent("catchbeast_viewinfo",_loc2_);
               break;
            case 2:
               _loc4_ = new CrazyTankSocketEvent("catchbeast_challenge",_loc2_);
               break;
            case 3:
               _loc4_ = new CrazyTankSocketEvent("catchbeast_buybuff",_loc2_);
               break;
            case 4:
               _loc4_ = new CrazyTankSocketEvent("catchbeast_getaward",_loc2_);
         }
         if(Boolean(_loc4_))
         {
            dispatchEvent(_loc4_);
         }
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         this._isBegin = param1.readBoolean();
         if(this._isBegin)
         {
            this.createCatchBeastBtn();
         }
         else
         {
            this.deleteCatchBeastBtn();
         }
      }
      
      private function createCatchBeastBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler("catchBeast",true);
      }
      
      public function deleteCatchBeastBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler("catchBeast",false);
      }
      
      override protected function start() : void
      {
         dispatchEvent(new Event("catchBeastOpenView"));
      }
      
      public function get catchBeastIcon() : MovieImage
      {
         return this._catchBeastIcon;
      }
      
      public function get isBegin() : Boolean
      {
         return this._isBegin;
      }
      
      public function set isBegin(param1:Boolean) : void
      {
         this._isBegin = param1;
      }
   }
}
