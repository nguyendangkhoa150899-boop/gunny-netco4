package times.utils
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   
   public class TimesUtils
   {
      
      private static var _reg:RegExp = /\{(\d+)\}/;
       
      
      public function TimesUtils()
      {
         super();
      }
      
      public static function setPos(param1:*, param2:String) : void
      {
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject(param2);
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
      }
      
      public static function getWords(param1:String, ... rest) : String
      {
         var _loc3_:int = 0;
         var _loc4_:XML = ComponentFactory.Instance.getCustomStyle(param1);
         var _loc5_:String = _loc4_.@value;
         var _loc6_:Object = _reg.exec(_loc5_);
         while(Boolean(_loc6_) && rest.length > 0)
         {
            _loc3_ = int(_loc6_[1]);
            if(_loc3_ >= 0 && _loc3_ < rest.length)
            {
               _loc5_ = _loc5_.replace(_reg,rest[_loc3_]);
            }
            else
            {
               _loc5_ = _loc5_.replace(_reg,"{}");
            }
            _loc6_ = _reg.exec(_loc5_);
         }
         return _loc5_;
      }
      
      public static function createCell(param1:Loader, param2:TimesPicInfo) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         var _loc11_:Shape = null;
         var _loc12_:Shape = null;
         if(Boolean(param1) && Boolean(param1.content as MovieClip))
         {
            _loc4_ = param1.content as MovieClip;
            _loc6_ = _loc4_.numChildren;
            _loc8_ = getDefinitionByName("bagAndInfo.cell.CellFactory");
            _loc9_ = 0;
            while(_loc9_ < _loc6_)
            {
               _loc5_ = _loc4_.getChildAt(_loc9_) as MovieClip;
               if(_loc5_ != null)
               {
                  _loc7_ = _loc5_.name;
                  if(_loc7_.substr(0,4) == "good")
                  {
                     if(!_loc3_)
                     {
                        _loc3_ = [];
                     }
                     _loc11_ = new Shape();
                     _loc11_.graphics.lineStyle(1,16777215,0);
                     _loc11_.graphics.drawRect(0,0,_loc5_.width,_loc5_.height);
                     _loc10_ = _loc8_.instance.createWeeklyItemCell(_loc11_,_loc7_.substr(5));
                     _loc10_.x = _loc5_.x;
                     _loc10_.y = _loc5_.y;
                     _loc10_.alpha = 0;
                     _loc3_.push(_loc10_);
                  }
                  else if(_loc7_.substr(0,8) == "purchase")
                  {
                     TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PUSH_TIP_ITEMS,param2,[_loc5_]));
                     if(!_loc3_)
                     {
                        _loc3_ = [];
                     }
                     _loc12_ = new Shape();
                     _loc12_.graphics.lineStyle(1,16777215,0);
                     _loc12_.graphics.drawRect(0,0,_loc5_.width,_loc5_.height);
                     _loc10_ = _loc8_.instance.createWeeklyItemCell(_loc12_,_loc7_.substr(9));
                     _loc10_.x = _loc5_.x;
                     _loc10_.y = _loc5_.y;
                     _loc10_.alpha = 0;
                     _loc10_.addEventListener(MouseEvent.CLICK,quickBuy);
                     _loc10_.buttonMode = true;
                     _loc3_.push(_loc10_);
                  }
               }
               _loc9_++;
            }
         }
         var _loc13_:int = 0;
         if(_loc4_ && _loc3_ && _loc3_.length > 0)
         {
            while(_loc4_.numChildren == _loc6_ && _loc6_ > _loc13_)
            {
               if(_loc4_.getChildAt(_loc13_).name.substr(0,4) == "good")
               {
                  _loc4_.removeChildAt(_loc13_);
                  _loc6_--;
               }
               else
               {
                  _loc13_++;
               }
            }
         }
         if(Boolean(_loc3_))
         {
            TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PUSH_TIP_CELLS,param2,_loc3_));
         }
         return _loc3_;
      }
      
      private static function quickBuy(param1:MouseEvent) : void
      {
         var _loc2_:TimesPicInfo = new TimesPicInfo();
         _loc2_.templateID = int(param1.currentTarget.info.TemplateID);
         TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PURCHASE,_loc2_));
      }
   }
}
