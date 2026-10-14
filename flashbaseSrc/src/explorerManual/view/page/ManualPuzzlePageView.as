package explorerManual.view.page
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ManualPuzzlePageView extends Sprite implements Disposeable
   {
       
      
      private var _debrisInfo:Array;
      
      private var _count:int;
      
      private var _totalWidth:int = 328;
      
      private var _totalHeight:int = 384;
      
      private var _rows:int;
      
      private var _cols:int;
      
      private var _itemW:int;
      
      private var _itemH:int;
      
      private var _allDebris:Array;
      
      private var _allDebrisState:Array;
      
      private var _isCanClick:Boolean = false;
      
      private var _isPuzzleSucceed:Boolean = false;
      
      public function ManualPuzzlePageView()
      {
         super();
      }
      
      public function get isPuzzleSucceed() : Boolean
      {
         return this._isPuzzleSucceed;
      }
      
      public function set isPuzzleSucceed(param1:Boolean) : void
      {
         this._isPuzzleSucceed = param1;
         this.dispatchEvent(new CEvent("PuzzleSucceed",this._isPuzzleSucceed));
      }
      
      public function set isCanClick(param1:Boolean) : void
      {
         this._isCanClick = param1;
      }
      
      public function get isCanClick() : Boolean
      {
         return this._isCanClick;
      }
      
      public function set debrisInfo(param1:Array) : void
      {
         this._debrisInfo = param1;
         this.isCanClick = this._count <= this._debrisInfo.length;
         this.initPuzzleItem();
      }
      
      public function set totalDebrisCount(param1:int) : void
      {
         this._count = param1;
      }
      
      public function correctionPuzzle() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = int(this._debrisInfo.length);
         var _loc8_:Array = [];
         if(this._isCanClick)
         {
            _loc4_ = 0;
            while(_loc4_ < this._debrisInfo.length)
            {
               _loc8_.push(this._debrisInfo[_loc4_].Sort);
               _loc4_++;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               if(_loc8_[_loc5_] != _loc5_ + 1)
               {
                  _loc6_ = _loc5_;
                  while(_loc6_ < _loc7_)
                  {
                     if(_loc8_[_loc6_] == _loc5_ + 1)
                     {
                        _loc2_ = int(_loc8_[_loc6_]);
                        _loc8_[_loc6_] = _loc8_[_loc5_];
                        _loc8_[_loc5_] = _loc2_;
                        _loc3_++;
                        break;
                     }
                     _loc6_++;
                  }
               }
               _loc5_++;
            }
            if(_loc3_ % 2 > 0)
            {
               _loc1_ = this._debrisInfo[_loc7_ - 1];
               this._debrisInfo[_loc7_ - 1] = this._debrisInfo[_loc7_ - 2];
               this._debrisInfo[_loc7_ - 2] = _loc1_;
            }
         }
      }
      
      private function initPuzzleItem() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._rows = Math.sqrt(this._count + 1);
         this._cols = this._rows;
         this._allDebrisState = new Array(this._rows);
         this._allDebris = [];
         this._itemW = this._totalWidth / this._rows;
         this._itemH = this._totalHeight / this._cols;
         this.correctionPuzzle();
         _loc3_ = 0;
         while(_loc3_ < this._rows)
         {
            this._allDebrisState[_loc3_] = new Array(this._cols);
            _loc4_ = 0;
            while(_loc4_ < this._cols)
            {
               if((_loc2_ = _loc3_ * this._cols + _loc4_) < this._debrisInfo.length)
               {
                  _loc1_ = new ManualPiecesItem(_loc2_,this._itemW,this._itemH);
                  _loc1_.info = this._debrisInfo[_loc2_];
                  _loc1_.x = _loc4_ * this._itemW;
                  _loc1_.y = _loc3_ * this._itemH;
                  _loc1_.xOffset = _loc4_;
                  _loc1_.yOffset = _loc3_;
                  addChild(_loc1_);
                  this._allDebrisState[_loc3_][_loc4_] = 0;
                  _loc1_.addEventListener("click",this.__itemClickHandler);
                  this._allDebris.push(_loc1_);
               }
               else
               {
                  this._allDebrisState[_loc3_][_loc4_] = 1;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         if(this.isCanClick)
         {
            this.checkPuzzleResult();
         }
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ManualPiecesItem = null;
         if(!this._isCanClick)
         {
            return;
         }
         _loc2_ = param1.target as ManualPiecesItem;
         var _loc3_:int = _loc2_.xOffset - 1;
         var _loc4_:int = _loc2_.xOffset + 1;
         var _loc5_:int = _loc2_.yOffset - 1;
         var _loc6_:int = _loc2_.yOffset + 1;
         if(_loc3_ != -1 && this._allDebrisState[_loc3_][_loc2_.yOffset] == 1)
         {
            this._allDebrisState[_loc3_][_loc2_.yOffset] = 0;
            this._allDebrisState[_loc2_.xOffset][_loc2_.yOffset] = 1;
            _loc2_.xOffset = _loc3_;
            _loc2_.x = _loc3_ * this._itemW;
            _loc2_.index -= 1;
         }
         else if(_loc4_ < this._rows && this._allDebrisState[_loc4_][_loc2_.yOffset] == 1)
         {
            this._allDebrisState[_loc2_.xOffset][_loc2_.yOffset] = 1;
            this._allDebrisState[_loc4_][_loc2_.yOffset] = 0;
            _loc2_.xOffset = _loc4_;
            _loc2_.x = _loc4_ * this._itemW;
            _loc2_.index += 1;
         }
         else if(_loc5_ != -1 && this._allDebrisState[_loc2_.xOffset][_loc5_] == 1)
         {
            this._allDebrisState[_loc2_.xOffset][_loc2_.yOffset] = 1;
            this._allDebrisState[_loc2_.xOffset][_loc5_] = 0;
            _loc2_.yOffset = _loc5_;
            _loc2_.y = _loc5_ * this._itemH;
            _loc2_.index -= this._rows;
         }
         else if(_loc6_ < this._cols && this._allDebrisState[_loc2_.xOffset][_loc6_] == 1)
         {
            this._allDebrisState[_loc2_.xOffset][_loc2_.yOffset] = 1;
            this._allDebrisState[_loc2_.xOffset][_loc6_] = 0;
            _loc2_.yOffset = _loc6_;
            _loc2_.y = _loc6_ * this._itemH;
            _loc2_.index += this._rows;
         }
         this.checkPuzzleResult();
      }
      
      private function checkPuzzleResult() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = true;
         _loc2_ = 0;
         while(_loc2_ < this._allDebris.length)
         {
            if(!(this._allDebris[_loc2_] as ManualPiecesItem).isRight)
            {
               _loc3_ = false;
               break;
            }
            _loc2_++;
         }
         if(_loc3_)
         {
            this.isPuzzleSucceed = _loc3_;
            this.isCanClick = false;
         }
      }
      
      public function akey() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = Math.sqrt(this._count + 1);
         var _loc6_:int = this._rows;
         var _loc7_:int = this._totalWidth / this._rows;
         var _loc8_:int = this._totalHeight / this._cols;
         _loc4_ = 0;
         while(_loc4_ < this._allDebris.length)
         {
            _loc2_ = ((_loc1_ = this._allDebris[_loc4_] as ManualPiecesItem).info.Sort - 1) % _loc5_;
            _loc3_ = (_loc1_.info.Sort - 1) / _loc5_;
            _loc1_.x = _loc2_ * _loc7_;
            _loc1_.y = _loc3_ * _loc8_;
            _loc1_.index = _loc3_ * _loc6_ + _loc2_;
            _loc4_++;
         }
         this.checkPuzzleResult();
      }
      
      public function clear() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._allDebris) && this._allDebris.length > 0)
         {
            while(this._allDebris.length > 0)
            {
               _loc1_ = this._allDebris.shift();
               _loc1_.removeEventListener("click",this.__itemClickHandler);
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         this._allDebris = null;
      }
      
      public function dispose() : void
      {
         this.clear();
         this._isCanClick = false;
         this._isPuzzleSucceed = false;
         this._debrisInfo = null;
         this._allDebrisState = null;
      }
   }
}
