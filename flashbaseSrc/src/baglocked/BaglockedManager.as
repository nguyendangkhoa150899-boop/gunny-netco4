package baglocked
{
   public class BaglockedManager
   {
      
      private static var _instance:baglocked.BaglockedManager;
       
      
      public var isBagLocked:Boolean = false;
      
      private var bagLockedController:baglocked.BagLockedController;
      
      public function BaglockedManager()
      {
         super();
      }
      
      public static function get Instance() : baglocked.BaglockedManager
      {
         if(_instance == null)
         {
            _instance = new baglocked.BaglockedManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(this.bagLockedController == null)
         {
            this.bagLockedController = new baglocked.BagLockedController();
         }
         this.bagLockedController.openBagLockedGetFrame();
      }
   }
}
