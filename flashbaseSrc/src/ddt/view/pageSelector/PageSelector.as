package ddt.view.pageSelector
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PageSelector extends Sprite implements Disposeable
   {
       
      
      private var _itemList;
      
      private var _itemDataArr:Array;
      
      private var _curPage:Number = 1;
      
      protected var _rightBtn:BaseButton;
      
      protected var _leftBtn:BaseButton;
      
      protected var _numBG:Scale9CornerImage;
      
      protected var _pageNum:FilterFrameText;
      
      private var _totalPage:Number = 1;
      
      private var _itemLengthPerPage:Number = 0;
      
      public function PageSelector()
      {
         super();
      }
      
      public function set itemList(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._itemList = param1;
         this._itemLengthPerPage = this._itemList.length;
         if(this._itemDataArr != null)
         {
            this._totalPage = Math.max(1,Math.ceil(this._itemDataArr.length / this._itemLengthPerPage));
            this._pageNum.text = "1/" + this._totalPage.toString();
            this.setPageArr();
         }
      }
      
      public function set itemDataArr(param1:Array) : void
      {
         this._itemDataArr = param1;
         if(this._itemLengthPerPage > 0)
         {
            this._totalPage = Math.max(1,Math.ceil(this._itemDataArr.length / this._itemLengthPerPage));
            this._pageNum.text = "1/" + this._totalPage.toString();
            this.setPageArr();
         }
      }
      
      public function set updateItemDataArr(param1:Array) : void
      {
         this._itemDataArr = param1;
         if(this._itemLengthPerPage > 0)
         {
            this._totalPage = Math.max(1,Math.ceil(this._itemDataArr.length / this._itemLengthPerPage));
            this._pageNum.text = this._curPage + "/" + this._totalPage.toString();
         }
      }
      
      public function get curPage() : Number
      {
         return this._curPage;
      }
      
      public function setRightBtn(param1:String) : void
      {
         this._rightBtn = ComponentFactory.Instance.creat(param1);
         addChild(this._rightBtn);
         this._rightBtn.addEventListener("click",this.mouseClickHander);
      }
      
      public function setLeftBtn(param1:String) : void
      {
         this._leftBtn = ComponentFactory.Instance.creat(param1);
         addChild(this._leftBtn);
         this._leftBtn.addEventListener("click",this.mouseClickHander);
      }
      
      public function setNumBG(param1:String) : void
      {
         this._numBG = ComponentFactory.Instance.creat(param1);
         addChild(this._numBG);
      }
      
      public function setPageNumber(param1:String) : void
      {
         this._pageNum = ComponentFactory.Instance.creatComponentByStylename(param1);
         this._pageNum.autoSize = "center";
         this._pageNum.text = "1/1";
         addChild(this._pageNum);
      }
      
      public function updateByIndex(param1:int) : void
      {
         var _loc2_:int = (this._curPage - 1) * this._itemLengthPerPage;
         var _loc3_:int = Math.min(this._curPage * this._itemLengthPerPage,this._itemDataArr.length) - 1;
         if(_loc2_ <= param1 && param1 <= _loc3_)
         {
            (this._itemList[param1 - _loc2_] as IPageItem).updateItem(this._itemDataArr[param1]);
         }
      }
      
      private function mouseClickHander(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._itemDataArr)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this._rightBtn:
               ++this._curPage;
               if(this._curPage > this._totalPage)
               {
                  this._curPage = 1;
               }
               break;
            case this._leftBtn:
               --this._curPage;
               if(this._curPage < 1)
               {
                  this._curPage = this._totalPage;
               }
         }
         this._pageNum.text = this._curPage + "/" + this._totalPage;
         this.setPageArr();
      }
      
      public function setPageArr() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = (this._curPage - 1) * this._itemLengthPerPage;
         var _loc4_:int = Math.min(this._curPage * this._itemLengthPerPage,this._itemDataArr.length);
         _loc1_ = this._itemDataArr.slice(_loc3_,_loc4_);
         this.clearAllItemData();
         var _loc5_:int = int(_loc1_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            (this._itemList[_loc2_] as IPageItem).updateItem(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      private function clearAllItemData() : void
      {
         var _loc1_:int = 0;
         if(this._itemList == null)
         {
            return;
         }
         var _loc2_:int = int(this._itemList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._itemList[_loc1_].updateItem();
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         if(this._leftBtn != null)
         {
            this._leftBtn.removeEventListener("click",this.mouseClickHander);
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(this._rightBtn != null)
         {
            this._rightBtn.removeEventListener("click",this.mouseClickHander);
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(this._pageNum != null)
         {
            ObjectUtils.disposeObject(this._pageNum);
            this._pageNum = null;
         }
         if(this._numBG != null)
         {
            ObjectUtils.disposeObject(this._numBG);
            this._numBG = null;
         }
      }
   }
}
