package socialContact
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.events.Event;
   import socialContact.microcobol.MicrocobolFrame;
   
   public class SocialContactManager
   {
      
      private static var _instance:socialContact.SocialContactManager;
       
      
      private var _view:MicrocobolFrame;
      
      public function SocialContactManager()
      {
         super();
      }
      
      public static function get Instance() : socialContact.SocialContactManager
      {
         if(_instance == null)
         {
            _instance = new socialContact.SocialContactManager();
         }
         return _instance;
      }
      
      public function showView() : void
      {
         this._view = ComponentFactory.Instance.creatComponentByStylename("MicrocobolFrame");
         this._view.show();
         this._view.addEventListener("submit",this._submitExit);
      }
      
      private function _submitExit(param1:Event) : void
      {
      }
   }
}
