package ddt.manager
{
   public class DataRecordManager
   {
      
      private static var instance:ddt.manager.DataRecordManager;
       
      
      public function DataRecordManager()
      {
         super();
      }
      
      public static function getInstance() : ddt.manager.DataRecordManager
      {
         if(instance == null)
         {
            instance = new ddt.manager.DataRecordManager();
         }
         return instance;
      }
      
      public function recordClick(param1:int) : void
      {
      }
   }
}
