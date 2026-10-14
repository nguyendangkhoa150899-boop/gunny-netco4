package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AvatarCollectionAllPropertyView extends Sprite implements Disposeable
   {
       
      
      private var _allPropertyCellList:Vector.<AvatarCollection.view.AvatarCollectionPropertyCell>;
      
      public function AvatarCollectionAllPropertyView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._allPropertyCellList = new Vector.<AvatarCollectionPropertyCell>();
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = new AvatarCollection.view.AvatarCollectionPropertyCell(_loc1_);
            _loc2_.x = int(_loc1_ / 4) * 110;
            _loc2_.y = _loc1_ % 4 * 25;
            addChild(_loc2_);
            this._allPropertyCellList.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.addEventListener("updatePlayerState",this.__updatePlayerPropertyHandler);
      }
      
      private function __updatePlayerPropertyHandler(param1:Event) : void
      {
         this.refreshView();
      }
      
      public function refreshView() : void
      {
         var _loc12_:AvatarCollectionUnitVo = null;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Array = (_loc11_ = (_loc11_ = AvatarCollectionManager.instance.maleUnitList).concat(AvatarCollectionManager.instance.femaleUnitList)).concat(AvatarCollectionManager.instance.weaponUnitList);
         var _loc13_:Array = [(_loc12_ = new AvatarCollectionUnitVo()).Attack,_loc12_.Defence,_loc12_.Agility,_loc12_.Luck,_loc12_.Damage,_loc12_.Guard,_loc12_.Blood];
         _loc1_ = 0;
         while(_loc1_ < _loc11_.length)
         {
            _loc2_ = _loc11_[_loc1_];
            _loc3_ = [_loc2_.Attack,_loc2_.Defence,_loc2_.Agility,_loc2_.Luck,_loc2_.Damage,_loc2_.Guard,_loc2_.Blood];
            _loc4_ = int(_loc2_.totalItemList.length);
            _loc5_ = int(_loc2_.totalActivityItemCount);
            _loc6_ = _loc2_.endTime;
            _loc7_ = TimeManager.Instance.Now().getTime();
            if(_loc5_ < _loc4_ / 2)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc13_.length)
               {
                  _loc15_ = _loc8_;
                  _loc16_ = _loc13_[_loc15_] + 0;
                  _loc13_[_loc15_] = _loc16_;
                  _loc8_++;
               }
            }
            else if(_loc5_ == _loc4_)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc13_.length)
               {
                  _loc16_ = _loc9_;
                  _loc15_ = _loc13_[_loc16_] + _loc3_[_loc9_] * 2;
                  _loc13_[_loc16_] = _loc15_;
                  _loc9_++;
               }
            }
            else
            {
               _loc10_ = 0;
               while(_loc10_ < _loc13_.length)
               {
                  _loc15_ = _loc10_;
                  _loc16_ = _loc13_[_loc15_] + _loc3_[_loc10_];
                  _loc13_[_loc15_] = _loc16_;
                  _loc10_++;
               }
            }
            _loc1_++;
         }
         _loc12_.Attack = _loc13_[0];
         _loc12_.Defence = _loc13_[1];
         _loc12_.Agility = _loc13_[2];
         _loc12_.Luck = _loc13_[3];
         _loc12_.Damage = _loc13_[4];
         _loc12_.Guard = _loc13_[5];
         _loc12_.Blood = _loc13_[6];
         for each(_loc14_ in this._allPropertyCellList)
         {
            _loc14_.refreshAllProperty(_loc12_);
         }
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.removeEventListener("updatePlayerState",this.__updatePlayerPropertyHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._allPropertyCellList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
