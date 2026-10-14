package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SceneCharacterSynthesis
   {
       
      
      private var _sceneCharacterSet:ddt.view.sceneCharacter.SceneCharacterSet;
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _callBack:Function;
      
      public function SceneCharacterSynthesis(param1:ddt.view.sceneCharacter.SceneCharacterSet, param2:Function)
      {
         this._frameBitmap = new Vector.<Bitmap>();
         super();
         this._sceneCharacterSet = param1;
         this._callBack = param2;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.characterSynthesis();
      }
      
      private function characterSynthesis() : void
      {
         var _loc1_:SceneCharacterItem = null;
         var _loc2_:SceneCharacterItem = null;
         var _loc3_:BitmapData = null;
         var _loc4_:int = 0;
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:Matrix = new Matrix();
         var _loc11_:Point = new Point(0,0);
         var _loc12_:Rectangle = new Rectangle();
         for each(_loc1_ in this._sceneCharacterSet.dataSet)
         {
            if(_loc1_.isRepeat)
            {
               _loc3_ = new BitmapData(_loc1_.source.width * _loc1_.repeatNumber,_loc1_.source.height,true,0);
               _loc4_ = 0;
               while(_loc4_ < _loc1_.repeatNumber)
               {
                  _loc10_.tx = _loc1_.source.width * _loc4_;
                  _loc3_.draw(_loc1_.source,_loc10_);
                  _loc4_++;
               }
               _loc1_.source.dispose();
               _loc1_.source = null;
               _loc1_.source = new BitmapData(_loc3_.width,_loc3_.height,true,0);
               _loc1_.source.draw(_loc3_);
               _loc3_.dispose();
               _loc3_ = null;
            }
            if(Boolean(_loc1_.points) && _loc1_.points.length > 0)
            {
               _loc5_ = new BitmapData(_loc1_.source.width,_loc1_.source.height,true,0);
               _loc5_.draw(_loc1_.source);
               _loc1_.source.dispose();
               _loc1_.source = null;
               _loc1_.source = new BitmapData(_loc5_.width,_loc5_.height,true,0);
               _loc12_.width = _loc1_.cellWitdh;
               _loc12_.height = _loc1_.cellHeight;
               _loc6_ = 0;
               while(_loc6_ < _loc1_.rowNumber)
               {
                  _loc7_ = _loc1_.isRepeat ? int(_loc1_.repeatNumber) : int(_loc1_.rowCellNumber);
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_)
                  {
                     _loc9_ = _loc1_.points[_loc6_ * _loc7_ + _loc8_];
                     if(Boolean(_loc9_))
                     {
                        _loc11_.x = _loc1_.cellWitdh * _loc8_ + _loc9_.x;
                        _loc11_.y = _loc1_.cellHeight * _loc6_ + _loc9_.y;
                        _loc12_.x = _loc1_.cellWitdh * _loc8_;
                        _loc12_.y = _loc1_.cellHeight * _loc6_;
                        _loc1_.source.copyPixels(_loc5_,_loc12_,_loc11_);
                     }
                     else
                     {
                        _loc11_.x = _loc12_.x = _loc1_.cellWitdh * _loc8_;
                        _loc11_.y = _loc12_.y = _loc1_.cellHeight * _loc6_;
                        _loc1_.source.copyPixels(_loc5_,_loc12_,_loc11_);
                     }
                     _loc8_++;
                  }
                  _loc6_++;
               }
               _loc5_.dispose();
               _loc5_ = null;
            }
         }
         for each(_loc2_ in this._sceneCharacterSet.dataSet)
         {
            this.characterGroupDraw(_loc2_);
         }
         this.characterDraw();
      }
      
      private function characterGroupDraw(param1:SceneCharacterItem) : void
      {
         var _loc2_:SceneCharacterItem = null;
         for each(_loc2_ in this._sceneCharacterSet.dataSet)
         {
            if(param1.groupType == _loc2_.groupType && _loc2_.type != param1.type)
            {
               param1.source.draw(_loc2_.source);
               param1.rowNumber = _loc2_.rowNumber > param1.rowNumber ? int(_loc2_.rowNumber) : int(param1.rowNumber);
               param1.rowCellNumber = _loc2_.rowCellNumber > param1.rowCellNumber ? int(_loc2_.rowCellNumber) : int(param1.rowCellNumber);
               this._sceneCharacterSet.dataSet.splice(this._sceneCharacterSet.dataSet.indexOf(_loc2_),1);
            }
         }
      }
      
      private function characterDraw() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:SceneCharacterItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for each(_loc2_ in this._sceneCharacterSet.dataSet)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.rowNumber)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.rowCellNumber)
               {
                  _loc1_ = new BitmapData(_loc2_.cellWitdh,_loc2_.cellHeight,true,0);
                  _loc1_.copyPixels(_loc2_.source,new Rectangle(_loc4_ * _loc2_.cellWitdh,_loc2_.cellHeight * _loc3_,_loc2_.cellWitdh,_loc2_.cellHeight),new Point(0,0));
                  this._frameBitmap.push(new Bitmap(_loc1_));
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         if(this._callBack != null)
         {
            this._callBack(this._frameBitmap);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._sceneCharacterSet))
         {
            this._sceneCharacterSet.dispose();
         }
         this._sceneCharacterSet = null;
         while(Boolean(this._frameBitmap) && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
         this._callBack = null;
      }
   }
}
