package newTitle
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import newTitle.analyzer.NewTitleDataAnalyz;
   import newTitle.model.NewTitleModel;
   import road7th.comm.PackageIn;
   
   public class NewTitleManager extends EventDispatcher
   {
      
      public static var FIRST_TITLEID:int = 602;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private static var _instance:newTitle.NewTitleManager;
       
      
      public var ShowTitle:Boolean = true;
      
      private var _titleInfo:Dictionary;
      
      private var _titleArray:Array;
      
      public function NewTitleManager(param1:IEventDispatcher = null)
      {
         super();
      }
      
      public static function get instance() : newTitle.NewTitleManager
      {
         if(!_instance)
         {
            _instance = new newTitle.NewTitleManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NewTitle,this.__onGetHideTitleFlag);
      }
      
      protected function __onGetHideTitleFlag(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         NewTitleManager.instance.ShowTitle = !_loc2_.readBoolean();
      }
      
      public function newTitleDataSetup(param1:NewTitleDataAnalyz) : void
      {
         var _loc2_:* = undefined;
         this._titleInfo = param1.list;
         this._titleArray = [];
         var _loc3_:int = 0;
         var _loc4_:* = this._titleInfo;
         for(_loc2_ in this._titleInfo)
         {
            this._titleArray.push(this._titleInfo[_loc2_]);
         }
         this._titleArray.sortOn("Order",16);
      }
      
      public function getTitleByName(param1:String) : NewTitleModel
      {
         var _loc2_:int = 0;
         var _loc3_:NewTitleModel = null;
         _loc2_ = 0;
         while(_loc2_ < this._titleArray.length)
         {
            if(this._titleArray[_loc2_].Name == param1)
            {
               _loc3_ = this._titleArray[_loc2_];
               break;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function getTitleInfoByID(param1:int) : NewTitleModel
      {
         return this._titleInfo[param1];
      }
      
      public function get titleInfo() : Dictionary
      {
         return this._titleInfo;
      }
      
      public function get titleArray() : Array
      {
         return this._titleArray;
      }
   }
}
