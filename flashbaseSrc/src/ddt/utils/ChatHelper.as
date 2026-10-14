package ddt.utils
{
   import ddt.view.chat.chat_system;
   import flash.utils.ByteArray;
   
   public class ChatHelper
   {
       
      
      public function ChatHelper()
      {
         super();
      }
      
      chat_system static function readGoodsLinks(param1:ByteArray, param2:Boolean = false, param3:int = 0) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Array = [];
         var _loc6_:uint = param1.readUnsignedByte();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = new Object();
            _loc4_.index = param1.readInt();
            _loc4_.TemplateID = param1.readInt();
            _loc4_.ItemID = param1.readInt();
            if(param2)
            {
               _loc4_.key = param1.readUTF();
            }
            _loc4_.type = param3;
            _loc5_.push(_loc4_);
            _loc7_++;
         }
         return _loc5_;
      }
   }
}
