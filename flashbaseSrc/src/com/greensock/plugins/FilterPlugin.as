package com.greensock.plugins
{
   import com.greensock.core.PropTween;
   import flash.filters.BitmapFilter;
   
   public class FilterPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 2.03;
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _type:Class;
      
      protected var _filter:BitmapFilter;
      
      protected var _index:int;
      
      protected var _remove:Boolean;
      
      public function FilterPlugin()
      {
         super();
      }
      
      protected function initFilter(param1:Object, param2:BitmapFilter, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:HexColorsPlugin = null;
         var _loc7_:Array = this._target.filters;
         var _loc8_:Object = param1 is BitmapFilter ? {} : param1;
         this._index = -1;
         if(_loc8_.index != null)
         {
            this._index = _loc8_.index;
         }
         else
         {
            _loc5_ = int(_loc7_.length);
            while(Boolean(_loc5_--))
            {
               if(_loc7_[_loc5_] is this._type)
               {
                  this._index = _loc5_;
                  break;
               }
            }
         }
         if(this._index == -1 || _loc7_[this._index] == null || _loc8_.addFilter == true)
         {
            this._index = _loc8_.index != null ? int(_loc8_.index) : int(_loc7_.length);
            _loc7_[this._index] = param2;
            this._target.filters = _loc7_;
         }
         this._filter = _loc7_[this._index];
         if(_loc8_.remove == true)
         {
            this._remove = true;
            this.onComplete = this.onCompleteTween;
         }
         _loc5_ = int(param3.length);
         while(Boolean(_loc5_--))
         {
            _loc4_ = String(param3[_loc5_]);
            if(_loc4_ in param1 && this._filter[_loc4_] != param1[_loc4_])
            {
               if(_loc4_ == "color" || _loc4_ == "highlightColor" || _loc4_ == "shadowColor")
               {
                  _loc6_ = new HexColorsPlugin();
                  _loc6_.initColor(this._filter,_loc4_,this._filter[_loc4_],param1[_loc4_]);
                  _tweens[_tweens.length] = new PropTween(_loc6_,"changeFactor",0,1,_loc4_,false);
               }
               else if(_loc4_ == "quality" || _loc4_ == "inner" || _loc4_ == "knockout" || _loc4_ == "hideObject")
               {
                  this._filter[_loc4_] = param1[_loc4_];
               }
               else
               {
                  addTween(this._filter,_loc4_,this._filter[_loc4_],param1[_loc4_],_loc4_);
               }
            }
         }
      }
      
      public function onCompleteTween() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(this._remove)
         {
            _loc1_ = this._target.filters;
            if(!(_loc1_[this._index] is this._type))
            {
               _loc2_ = int(_loc1_.length);
               while(Boolean(_loc2_--))
               {
                  if(_loc1_[_loc2_] is this._type)
                  {
                     _loc1_.splice(_loc2_,1);
                     break;
                  }
               }
            }
            else
            {
               _loc1_.splice(this._index,1);
            }
            this._target.filters = _loc1_;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:PropTween = null;
         var _loc3_:int = int(_tweens.length);
         var _loc4_:Array = this._target.filters;
         while(Boolean(_loc3_--))
         {
            _loc2_ = _tweens[_loc3_];
            _loc2_.target[_loc2_.property] = _loc2_.start + _loc2_.change * param1;
         }
         if(!(_loc4_[this._index] is this._type))
         {
            _loc3_ = int(this._index = _loc4_.length);
            while(Boolean(_loc3_--))
            {
               if(_loc4_[_loc3_] is this._type)
               {
                  this._index = _loc3_;
                  break;
               }
            }
         }
         _loc4_[this._index] = this._filter;
         this._target.filters = _loc4_;
      }
   }
}
