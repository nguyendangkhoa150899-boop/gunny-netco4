package ddt.view.character
{
   import ddt.data.EquipType;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   
   public class ShowCharacterLoader extends BaseCharacterLoader
   {
       
      
      protected var _contentWithoutWeapon:BitmapData;
      
      private var _needMultiFrames:Boolean = false;
      
      public function ShowCharacterLoader(param1:PlayerInfo)
      {
         super(param1);
      }
      
      override protected function initLayers() : void
      {
         var _loc1_:ILayer = null;
         if(_layers != null)
         {
            for each(_loc1_ in _layers)
            {
               _loc1_.dispose();
            }
            _layers = null;
         }
         _layers = new Vector.<ILayer>();
         _recordStyle = _info.Style.split(",");
         _recordColor = _info.Colors.split(",");
         this.loadPart(7);
         this.loadPart(1);
         this.loadPart(0);
         this.loadPart(3);
         this.loadPart(4);
         this.loadPart(2);
         this.loadPart(5);
         this.laodArm();
         this.loadPart(8);
      }
      
      private function loadPart(param1:int) : void
      {
         if(_recordStyle[param1].split("|")[0] > 0)
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[param1].split("|")[0])),_info.Sex,_recordColor[param1],BaseLayer.SHOW,param1 == 2,_info.getHairType()));
         }
      }
      
      private function laodArm() : void
      {
         if(_recordStyle[6].split("|")[0] > 0)
         {
            _layers.push(_layerFactory.createLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[6].split("|")[0])),_info.Sex,_recordColor[6],BaseLayer.SHOW,false,_info.getHairType(),_recordStyle[6].split("|")[1]));
         }
      }
      
      override protected function getIndexByTemplateId(param1:String) : int
      {
         var _loc2_:int = super.getIndexByTemplateId(param1);
         if(_loc2_ == -1)
         {
            if(int(param1.charAt(0)) == EquipType.ARM)
            {
               return 7;
            }
            return -1;
         }
         return _loc2_;
      }
      
      public function set needMultiFrames(param1:Boolean) : void
      {
         this._needMultiFrames = param1;
      }
      
      override protected function drawCharacter() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:ILayer = null;
         var _loc3_:Number = ShowCharacter.BIG_WIDTH;
         var _loc4_:Number = ShowCharacter.BIG_HEIGHT;
         if(this._needMultiFrames)
         {
            _loc3_ *= 2;
         }
         if(Boolean(_content))
         {
            _content.dispose();
         }
         if(Boolean(this._contentWithoutWeapon))
         {
            this._contentWithoutWeapon.dispose();
         }
         _content = new BitmapData(_loc3_,_loc4_,true,0);
         this._contentWithoutWeapon = new BitmapData(_loc3_,_loc4_,true,0);
         var _loc5_:Matrix = new Matrix();
         _loc5_.identity();
         _loc5_.translate(_loc3_ / 2,0);
         var _loc6_:int = _layers.length - 1;
         for(; _loc6_ >= 0; _loc6_--)
         {
            if(_info.getShowSuits())
            {
               if(_loc6_ != 0 && _loc6_ != 8 && _loc6_ != 7)
               {
                  continue;
               }
            }
            else if(_loc6_ == 0)
            {
               continue;
            }
            _loc2_ = _layers[_loc6_];
            if(_loc2_.info.CategoryID != EquipType.ARM && _loc2_.info.CategoryID != EquipType.TEMPWEAPON)
            {
               if(_loc2_.info.CategoryID == EquipType.WING)
               {
                  _wing = _loc2_.getContent() as MovieClip;
               }
               else if(_loc2_.info.CategoryID != EquipType.FACE && _loc2_.info.CategoryID != EquipType.SUITS)
               {
                  this._contentWithoutWeapon.draw(_loc2_.getContent(),null,null,BlendMode.NORMAL);
                  if(this._needMultiFrames)
                  {
                     this._contentWithoutWeapon.draw(_loc2_.getContent(),_loc5_,null,BlendMode.NORMAL);
                  }
               }
               else
               {
                  this._contentWithoutWeapon.draw(_loc2_.getContent(),null,null,BlendMode.NORMAL);
               }
            }
            else if(_info.WeaponID != 0 && _info.WeaponID != -1)
            {
               _loc1_ = _loc2_.getContent();
            }
         }
         _content.draw(this._contentWithoutWeapon);
         if(_loc1_ != null)
         {
            _content.draw(_loc1_);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         _content = null;
         this._contentWithoutWeapon = null;
      }
      
      public function destory() : void
      {
         _content.dispose();
         this._contentWithoutWeapon.dispose();
         this.dispose();
      }
      
      override public function getContent() : Array
      {
         return [_content,this._contentWithoutWeapon,_wing];
      }
   }
}
