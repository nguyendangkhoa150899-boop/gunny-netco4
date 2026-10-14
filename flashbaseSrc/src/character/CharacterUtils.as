package character
{
   import flash.geom.Point;
   
   public class CharacterUtils
   {
       
      
      public function CharacterUtils()
      {
         super();
      }
      
      public static function creatFrames(param1:String) : Vector.<int>
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = new Vector.<int>();
         var _loc7_:Array = param1.split(",");
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc2_ = String(_loc7_[_loc8_]);
            if(_loc2_.indexOf("-") > -1)
            {
               _loc3_ = int(_loc2_.split("-")[0]);
               _loc4_ = int(_loc2_.split("-")[1]);
               _loc5_ = _loc3_;
               while(_loc5_ <= _loc4_)
               {
                  _loc6_.push(_loc5_);
                  _loc5_++;
               }
            }
            else
            {
               _loc6_.push(int(_loc2_));
            }
            _loc8_++;
         }
         return _loc6_;
      }
      
      public static function creatPoints(param1:String) : Vector.<Point>
      {
         var _loc2_:String = null;
         var _loc3_:Point = null;
         var _loc4_:Vector.<Point> = new Vector.<Point>();
         var _loc5_:Array = param1.split("|");
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc2_ = String(_loc5_[_loc6_]);
            _loc3_ = new Point(Number(_loc2_.split(",")[0]),Number(_loc2_.split(",")[1]));
            _loc4_.push(_loc3_);
            _loc6_++;
         }
         return _loc4_;
      }
   }
}
