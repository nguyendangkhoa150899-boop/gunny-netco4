package ddt.view.sceneCharacter
{
   import flash.geom.Point;
   
   public class SceneCharacterDirection
   {
      
      public static const RT:ddt.view.sceneCharacter.SceneCharacterDirection = new ddt.view.sceneCharacter.SceneCharacterDirection("RT",false);
      
      public static const LT:ddt.view.sceneCharacter.SceneCharacterDirection = new ddt.view.sceneCharacter.SceneCharacterDirection("LT",true);
      
      public static const RB:ddt.view.sceneCharacter.SceneCharacterDirection = new ddt.view.sceneCharacter.SceneCharacterDirection("RB",true);
      
      public static const LB:ddt.view.sceneCharacter.SceneCharacterDirection = new ddt.view.sceneCharacter.SceneCharacterDirection("LB",false);
       
      
      private var _isMirror:Boolean;
      
      private var _type:String;
      
      public function SceneCharacterDirection(param1:String, param2:Boolean)
      {
         super();
         this._type = param1;
         this._isMirror = param2;
      }
      
      public static function getDirection(param1:Point, param2:Point) : ddt.view.sceneCharacter.SceneCharacterDirection
      {
         var _loc3_:Number = getDegrees(param1,param2);
         if(_loc3_ >= 0 && _loc3_ < 90)
         {
            return ddt.view.sceneCharacter.SceneCharacterDirection.RT;
         }
         if(_loc3_ >= 90 && _loc3_ < 180)
         {
            return ddt.view.sceneCharacter.SceneCharacterDirection.LT;
         }
         if(_loc3_ >= 180 && _loc3_ < 270)
         {
            return ddt.view.sceneCharacter.SceneCharacterDirection.LB;
         }
         if(_loc3_ >= 270 && _loc3_ < 360)
         {
            return ddt.view.sceneCharacter.SceneCharacterDirection.RB;
         }
         return ddt.view.sceneCharacter.SceneCharacterDirection.RB;
      }
      
      private static function getDegrees(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = Math.atan2(param1.y - param2.y,param2.x - param1.x) * 180 / Math.PI;
         if(_loc3_ < 0)
         {
            _loc3_ += 360;
         }
         return _loc3_;
      }
      
      public function get isMirror() : Boolean
      {
         return this._isMirror;
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}
