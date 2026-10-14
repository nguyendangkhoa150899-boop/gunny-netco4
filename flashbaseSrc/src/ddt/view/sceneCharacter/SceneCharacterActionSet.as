package ddt.view.sceneCharacter
{
   public class SceneCharacterActionSet
   {
       
      
      private var _dataSet:Vector.<ddt.view.sceneCharacter.SceneCharacterActionItem>;
      
      public function SceneCharacterActionSet()
      {
         super();
         this._dataSet = new Vector.<SceneCharacterActionItem>();
      }
      
      public function push(param1:ddt.view.sceneCharacter.SceneCharacterActionItem) : void
      {
         this._dataSet.push(param1);
      }
      
      public function get length() : uint
      {
         return this._dataSet.length;
      }
      
      public function get dataSet() : Vector.<ddt.view.sceneCharacter.SceneCharacterActionItem>
      {
         return this._dataSet;
      }
      
      public function getItem(param1:String) : ddt.view.sceneCharacter.SceneCharacterActionItem
      {
         var _loc2_:int = 0;
         if(Boolean(this._dataSet) && this._dataSet.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._dataSet.length)
            {
               if(this._dataSet[_loc2_].type == param1)
               {
                  return this._dataSet[_loc2_];
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function dispose() : void
      {
         while(Boolean(this._dataSet) && this._dataSet.length > 0)
         {
            this._dataSet[0].dispose();
            this._dataSet.shift();
         }
         this._dataSet = null;
      }
   }
}
