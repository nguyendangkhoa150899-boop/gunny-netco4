package road.game.resource
{
   import flash.events.Event;
   
   public class ActionMovieEvent extends Event
   {
      
      public static const ACTION_START:String = "actionStart";
      
      public static const ACTION_END:String = "actionEnd";
       
      
      private var _source:road.game.resource.ActionMovie;
      
      private var _data:Object;
      
      public function ActionMovieEvent(param1:String, param2:Object = null)
      {
         super(param1);
         if(Boolean(param2))
         {
            this._data = param2;
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get source() : road.game.resource.ActionMovie
      {
         return super.target as ActionMovie;
      }
   }
}
