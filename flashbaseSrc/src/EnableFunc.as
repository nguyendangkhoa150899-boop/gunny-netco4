package
{
   import ddt.manager.PathManager;
   
   public class EnableFunc
   {
       
      
      public function EnableFunc()
      {
         super();
      }
      
      public static function get OpenWonderfulActivity() : Boolean
      {
         return PathManager.ConfigInfo.OPEN_WONDERFUL_ACTIVITY;
      }
   }
}
