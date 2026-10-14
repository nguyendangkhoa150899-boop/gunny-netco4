package
{
   import AvatarCollection.AvatarCollectionControl;
   import catchbeast.CatchBeastControl;
   import cryptBoss.CryptBossControl;
   import explorerManual.ExplorerManualController;
   
   public class DDT_Core
   {
       
      
      public function DDT_Core()
      {
         super();
      }
      
      public function setup() : void
      {
         CryptBossControl.instance.setup();
         CatchBeastControl.instance.setup();
         AvatarCollectionControl.instance.setup();
         ExplorerManualController.instance.setup();
      }
   }
}
