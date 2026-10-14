package worldboss.player
{
   import flash.events.EventDispatcher;
   
   public class CharacterBodyManager extends EventDispatcher
   {
      
      private static var _instance:worldboss.player.CharacterBodyManager;
       
      
      private var _sceneBoyCharacterLoaderBody:worldboss.player.SceneCharacterLoaderBody;
      
      private var _sceneGirlCharaterLoaderBody:worldboss.player.SceneCharacterLoaderBody;
      
      private var _sceneCharacterLoaderPath:String;
      
      private var _isLoaderBoyBodySucess:Boolean = false;
      
      private var _isLoaderGirlBodySucess:Boolean = false;
      
      public function CharacterBodyManager()
      {
         super();
      }
   }
}
