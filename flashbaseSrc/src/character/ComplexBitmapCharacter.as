package character
{
   import character.action.ActionSet;
   import character.action.BaseAction;
   import character.action.ComplexBitmapAction;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   public class ComplexBitmapCharacter extends ComplexItem implements ICharacter
   {
       
      
      protected var _assets:Dictionary;
      
      protected var _actionSet:ActionSet;
      
      protected var _currentAction:ComplexBitmapAction;
      
      protected var _label:String = "";
      
      protected var _autoStop:Boolean;
      
      protected var _bitmapRendItems:Vector.<FrameByFrameItem>;
      
      private var _registerPoint:Point;
      
      private var _rect:Rectangle;
      
      protected var _soundEnabled:Boolean = false;
      
      public function ComplexBitmapCharacter(param1:Dictionary, param2:XML = null, param3:String = "", param4:Number = 0, param5:Number = 0, param6:String = "original", param7:Boolean = false)
      {
         this._registerPoint = new Point(0,0);
         this._bitmapRendItems = new Vector.<FrameByFrameItem>();
         this._assets = param1;
         this._actionSet = new ActionSet();
         if(Boolean(param2))
         {
            param4 = int(param2.@width);
            param5 = int(param2.@height);
         }
         this._autoStop = param7;
         super(param4,param5,param6,"auto",true);
         _type = CharacterType.COMPLEX_BITMAP_TYPE;
         if(Boolean(param2))
         {
            this.description = param2;
         }
         this._label = param3;
      }
      
      public function get soundEnabled() : Boolean
      {
         return this._soundEnabled;
      }
      
      private function set _164832462soundEnabled(param1:Boolean) : void
      {
         if(this._soundEnabled == param1)
         {
            return;
         }
         this._soundEnabled = param1;
      }
      
      public function set description(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:XMLList = null;
         var _loc6_:Vector.<FrameByFrameItem> = null;
         var _loc7_:int = 0;
         var _loc8_:ComplexBitmapAction = null;
         var _loc9_:XML = null;
         var _loc10_:BitmapRendItem = null;
         this._actionSet = new ActionSet();
         var _loc11_:XMLList = param1..action;
         this._label = param1.@label;
         if(param1.hasOwnProperty("@registerX"))
         {
            this._registerPoint.x = param1.@registerX;
         }
         if(param1.hasOwnProperty("@registerY"))
         {
            this._registerPoint.y = param1.@registerY;
         }
         if(param1.hasOwnProperty("@rect"))
         {
            _loc3_ = String(param1.@rect);
            this._rect = new Rectangle();
            _loc4_ = _loc3_.split("|");
            this._rect.x = _loc4_[0];
            this._rect.y = _loc4_[1];
            this._rect.width = _loc4_[2];
            this._rect.height = _loc4_[3];
         }
         for each(_loc2_ in _loc11_)
         {
            _loc5_ = _loc2_.asset;
            _loc6_ = new Vector.<FrameByFrameItem>();
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length())
            {
               _loc9_ = _loc5_[_loc7_];
               _loc10_ = _loc9_.@frames == "" ? new FrameByFrameItem(_loc9_.@width,_loc9_.@height,this._assets[String(_loc9_.@resource)]) : new CrossFrameItem(_loc9_.@width,_loc9_.@height,this._assets[String(_loc9_.@resource)],CharacterUtils.creatFrames(_loc9_.@frames));
               FrameByFrameItem(_loc10_).sourceName = String(_loc9_.@resource);
               _loc10_.name = _loc9_.@name;
               if(_loc9_.hasOwnProperty("@x"))
               {
                  _loc10_.x = _loc9_.@x;
               }
               if(_loc9_.hasOwnProperty("@y"))
               {
                  _loc10_.y = _loc9_.@y;
               }
               if(_loc9_.hasOwnProperty("@points"))
               {
                  FrameByFrameItem(_loc10_).moveInfo = CharacterUtils.creatPoints(_loc9_.@points);
               }
               _loc6_.push(_loc10_);
               this._bitmapRendItems.push(_loc10_);
               _loc7_++;
            }
            _loc8_ = new ComplexBitmapAction(_loc6_,_loc2_.@name,_loc2_.@next,int(_loc2_.@priority));
            _loc8_.sound = _loc2_.@sound;
            _loc8_.endStop = String(_loc2_.@endStop) == "true";
            _loc8_.sound = String(_loc2_.@sound);
            this._actionSet.addAction(_loc8_);
         }
         if(this._actionSet.actions.length > 0)
         {
            this.currentAction = this._actionSet.currentAction as ComplexBitmapAction;
         }
      }
      
      public function getActionFrames(param1:String) : int
      {
         var _loc2_:BaseAction = this._actionSet.getAction(param1);
         if(Boolean(_loc2_))
         {
            return _loc2_.len;
         }
         return 0;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      private function set _102727412label(param1:String) : void
      {
         this._label = param1;
      }
      
      public function hasAction(param1:String) : Boolean
      {
         return this._actionSet.getAction(param1) != null;
      }
      
      private function set _1408207997assets(param1:Dictionary) : void
      {
         this._assets = param1;
      }
      
      public function get assets() : Dictionary
      {
         return this._assets;
      }
      
      public function get actions() : Array
      {
         return this._actionSet.actions;
      }
      
      public function addAction(param1:BaseAction) : void
      {
         if(param1 is ComplexBitmapAction)
         {
            this._actionSet.addAction(param1);
            if(this._currentAction == null)
            {
               this.currentAction = param1 as ComplexBitmapAction;
            }
            dispatchEvent(new CharacterEvent(CharacterEvent.ADD_ACTION,param1));
            return;
         }
         throw new Error("ComplexBitmapCharacter\'s action must be ComplexBitmapAction");
      }
      
      public function doAction(param1:String) : void
      {
         var _loc2_:FrameByFrameItem = null;
         play();
         var _loc3_:ComplexBitmapAction = this._actionSet.getAction(param1) as ComplexBitmapAction;
         if(Boolean(_loc3_))
         {
            if(this._currentAction == null)
            {
               this.currentAction = _loc3_;
            }
            else if(_loc3_.priority >= this._currentAction.priority)
            {
               for each(_loc2_ in this._currentAction.assets)
               {
                  _loc2_.stop();
                  removeItem(_loc2_);
               }
               this._currentAction.reset();
               this.currentAction = _loc3_;
            }
         }
      }
      
      protected function set currentAction(param1:ComplexBitmapAction) : void
      {
         var _loc2_:FrameByFrameItem = null;
         param1.reset();
         this._currentAction = param1;
         this._autoStop = this._currentAction.endStop;
         for each(_loc2_ in this._currentAction.assets)
         {
            _loc2_.reset();
            _loc2_.play();
            addItem(_loc2_);
         }
         if(this._currentAction.sound != "" && this._soundEnabled)
         {
            CharacterSoundManager.instance.play(this._currentAction.sound);
         }
      }
      
      override protected function update() : void
      {
         super.update();
         if(this._currentAction == null)
         {
            return;
         }
         this._currentAction.update();
         if(this._currentAction.isEnd)
         {
            if(this._autoStop)
            {
               stop();
            }
            else
            {
               this.doAction(this._currentAction.nextAction);
            }
         }
      }
      
      public function get registerPoint() : Point
      {
         return this._registerPoint;
      }
      
      public function get rect() : Rectangle
      {
         if(this._rect == null)
         {
            this._rect = new Rectangle(0,0,_itemWidth,_itemHeight);
         }
         return this._rect;
      }
      
      override public function toXml() : XML
      {
         var _loc1_:XML = <character></character>;
         _loc1_.@type = _type;
         _loc1_.@width = _itemWidth;
         _loc1_.@height = _itemHeight;
         _loc1_.@label = this._label;
         _loc1_.@registerX = this._registerPoint.x;
         _loc1_.@registerY = this._registerPoint.y;
         _loc1_.@rect = [this.rect.x,this.rect.y,this.rect.width,this.rect.height].join("|");
         _loc1_.appendChild(this._actionSet.toXml());
         return _loc1_;
      }
      
      public function removeAction(param1:String) : void
      {
         var _loc2_:FrameByFrameItem = null;
         var _loc3_:BaseAction = this._actionSet.getAction(param1);
         if(Boolean(_loc3_) && this._currentAction == _loc3_)
         {
            for each(_loc2_ in this._currentAction.assets)
            {
               _loc2_.stop();
               removeItem(_loc2_);
            }
            this._currentAction = null;
         }
         this._actionSet.removeAction(param1);
         dispatchEvent(new CharacterEvent(CharacterEvent.REMOVE_ACTION));
      }
      
      override public function dispose() : void
      {
         var _loc1_:FrameByFrameItem = null;
         super.dispose();
         for each(_loc1_ in this._bitmapRendItems)
         {
            _loc1_.dispose();
         }
         this._bitmapRendItems = null;
         this._assets = null;
         this._actionSet.dispose();
         this._actionSet = null;
         this._currentAction = null;
      }
      
      [Bindable(event="propertyChange")]
      public function set assets(param1:Dictionary) : void
      {
         var _loc2_:Object = this.assets;
         if(_loc2_ !== param1)
         {
            this._1408207997assets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"assets",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set soundEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.soundEnabled;
         if(_loc2_ !== param1)
         {
            this._164832462soundEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"soundEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this.label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
            }
         }
      }
   }
}
