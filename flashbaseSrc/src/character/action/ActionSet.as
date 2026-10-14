package character.action
{
   import flash.events.EventDispatcher;
   
   public class ActionSet extends EventDispatcher
   {
       
      
      private var _actions:Array;
      
      private var _currentAction:character.action.BaseAction;
      
      public function ActionSet(param1:XML = null)
      {
         super();
         this._actions = [];
         if(Boolean(param1))
         {
            this.parseFromXml(param1);
         }
      }
      
      public function addAction(param1:character.action.BaseAction) : void
      {
         if(Boolean(param1))
         {
            this._actions.push(param1);
         }
      }
      
      public function getAction(param1:String) : character.action.BaseAction
      {
         var _loc2_:character.action.BaseAction = null;
         for each(_loc2_ in this._actions)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get next() : character.action.BaseAction
      {
         var _loc1_:character.action.BaseAction = null;
         for each(_loc1_ in this._actions)
         {
            if(_loc1_.name == this._currentAction.name)
            {
               return _loc1_;
            }
         }
         return this._currentAction;
      }
      
      public function get currentAction() : character.action.BaseAction
      {
         if(Boolean(this._currentAction))
         {
            return this._currentAction;
         }
         if(this._actions.length > 0)
         {
            this._currentAction = this._actions[0];
         }
         return this._currentAction;
      }
      
      public function get stringActions() : Array
      {
         var _loc1_:character.action.BaseAction = null;
         var _loc2_:Array = [];
         for each(_loc1_ in this._actions)
         {
            _loc2_.push(_loc1_.name);
         }
         return _loc2_;
      }
      
      public function get actions() : Array
      {
         return this._actions;
      }
      
      public function removeAction(param1:String) : void
      {
         var _loc2_:character.action.BaseAction = null;
         for each(_loc2_ in this._actions)
         {
            if(_loc2_.name == param1)
            {
               this._actions.splice(this._actions.indexOf(_loc2_),1);
               _loc2_.dispose();
            }
         }
      }
      
      private function parseFromXml(param1:XML) : void
      {
      }
      
      public function toXml() : XML
      {
         var _loc1_:character.action.BaseAction = null;
         var _loc2_:XML = <actionSet></actionSet>;
         var _loc3_:int = 0;
         while(_loc3_ < this._actions.length)
         {
            _loc1_ = this._actions[_loc3_];
            _loc2_.appendChild(_loc1_.toXml());
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:character.action.BaseAction = null;
         for each(_loc1_ in this._actions)
         {
            _loc1_.dispose();
         }
      }
   }
}
