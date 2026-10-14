package ddt.manager
{
   public class PayManager
   {
      
      private static var _ins:ddt.manager.PayManager;
       
      
      public function PayManager()
      {
         super();
      }
      
      public static function Instance() : ddt.manager.PayManager
      {
         return _ins = _ins || new ddt.manager.PayManager();
      }
   }
}
