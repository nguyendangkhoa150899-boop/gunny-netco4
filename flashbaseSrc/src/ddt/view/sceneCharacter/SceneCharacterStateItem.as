package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   
   public class SceneCharacterStateItem
   {
       
      
      private var _type:String;
      
      private var _sceneCharacterSet:ddt.view.sceneCharacter.SceneCharacterSet;
      
      private var _sceneCharacterActionSet:ddt.view.sceneCharacter.SceneCharacterActionSet;
      
      private var _sceneCharacterSynthesis:ddt.view.sceneCharacter.SceneCharacterSynthesis;
      
      private var _sceneCharacterBase:ddt.view.sceneCharacter.SceneCharacterBase;
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _sceneCharacterActionItem:ddt.view.sceneCharacter.SceneCharacterActionItem;
      
      private var _sceneCharacterDirection:ddt.view.sceneCharacter.SceneCharacterDirection;
      
      public function SceneCharacterStateItem(param1:String, param2:ddt.view.sceneCharacter.SceneCharacterSet, param3:ddt.view.sceneCharacter.SceneCharacterActionSet)
      {
         super();
         this._type = param1;
         this._sceneCharacterSet = param2;
         this._sceneCharacterActionSet = param3;
      }
      
      public function update() : void
      {
         if(!this._sceneCharacterSet || !this._sceneCharacterActionSet)
         {
            return;
         }
         if(Boolean(this._sceneCharacterSynthesis))
         {
            this._sceneCharacterSynthesis.dispose();
         }
         this._sceneCharacterSynthesis = null;
         this._sceneCharacterSynthesis = new ddt.view.sceneCharacter.SceneCharacterSynthesis(this._sceneCharacterSet,this.sceneCharacterSynthesisCallBack);
      }
      
      private function sceneCharacterSynthesisCallBack(param1:Vector.<Bitmap>) : void
      {
         this._frameBitmap = param1;
         if(Boolean(this._sceneCharacterBase))
         {
            this._sceneCharacterBase.dispose();
         }
         this._sceneCharacterBase = null;
         this._sceneCharacterBase = new ddt.view.sceneCharacter.SceneCharacterBase(this._frameBitmap);
         this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem = this._sceneCharacterActionSet.dataSet[0];
      }
      
      public function set setSceneCharacterActionType(param1:String) : void
      {
         var _loc2_:ddt.view.sceneCharacter.SceneCharacterActionItem = this._sceneCharacterActionSet.getItem(param1);
         if(Boolean(_loc2_))
         {
            this._sceneCharacterActionItem = _loc2_;
         }
         this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem;
      }
      
      public function get setSceneCharacterActionType() : String
      {
         return this._sceneCharacterActionItem.type;
      }
      
      public function set sceneCharacterDirection(param1:ddt.view.sceneCharacter.SceneCharacterDirection) : void
      {
         if(this._sceneCharacterDirection == param1)
         {
            return;
         }
         this._sceneCharacterDirection = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get sceneCharacterSet() : ddt.view.sceneCharacter.SceneCharacterSet
      {
         return this._sceneCharacterSet;
      }
      
      public function set sceneCharacterSet(param1:ddt.view.sceneCharacter.SceneCharacterSet) : void
      {
         this._sceneCharacterSet = param1;
      }
      
      public function get sceneCharacterBase() : ddt.view.sceneCharacter.SceneCharacterBase
      {
         return this._sceneCharacterBase;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._sceneCharacterSet))
         {
            this._sceneCharacterSet.dispose();
         }
         this._sceneCharacterSet = null;
         if(Boolean(this._sceneCharacterActionSet))
         {
            this._sceneCharacterActionSet.dispose();
         }
         this._sceneCharacterActionSet = null;
         if(Boolean(this._sceneCharacterSynthesis))
         {
            this._sceneCharacterSynthesis.dispose();
         }
         this._sceneCharacterSynthesis = null;
         if(Boolean(this._sceneCharacterBase))
         {
            this._sceneCharacterBase.dispose();
         }
         this._sceneCharacterBase = null;
         if(Boolean(this._sceneCharacterActionItem))
         {
            this._sceneCharacterActionItem.dispose();
         }
         this._sceneCharacterActionItem = null;
         this._sceneCharacterDirection = null;
         while(Boolean(this._frameBitmap) && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
      }
   }
}
