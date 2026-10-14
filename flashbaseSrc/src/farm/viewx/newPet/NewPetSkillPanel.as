package farm.viewx.newPet
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.view.item.SkillItem;
   
   public class NewPetSkillPanel extends Sprite implements Disposeable
   {
       
      
      private var _petSkill:SimpleTileList;
      
      private var _petSkillScroll:ScrollPanel;
      
      private var _itemInfoVec:Array;
      
      private var _itemViewVec:Vector.<farm.viewx.newPet.PetSkillItem>;
      
      public function NewPetSkillPanel()
      {
         super();
         this._itemInfoVec = [];
         this._itemViewVec = new Vector.<PetSkillItem>();
         this.creatView();
      }
      
      private function creatView() : void
      {
         this._petSkillScroll = ComponentFactory.Instance.creatComponentByStylename("farm.scrollPanel.petSkillPnl");
         addChild(this._petSkillScroll);
         this._petSkill = ComponentFactory.Instance.creatCustomObject("farm.simpleTileList.petSkill",[4]);
         this._petSkillScroll.setView(this._petSkill);
      }
      
      public function set itemInfo(param1:Array) : void
      {
         this._itemInfoVec = param1;
         this._itemInfoVec.sortOn("ID",Array.NUMERIC);
         this.update();
      }
      
      public function update() : void
      {
         this.removeItems();
         this.creatItems();
      }
      
      protected function creatItems() : void
      {
         var _loc1_:farm.viewx.newPet.PetSkillItem = null;
         _loc1_ = null;
         var _loc2_:PetSkillTemplateInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 8;
         for each(_loc2_ in this._itemInfoVec)
         {
            if(Boolean(_loc2_))
            {
               _loc1_ = new farm.viewx.newPet.PetSkillItem(_loc2_,_loc3_++);
               _loc1_.DoubleClickEnabled = true;
               _loc1_.iconPos = new Point(2.5,2.5);
               this._petSkill.addChild(_loc1_);
               this._itemViewVec.push(_loc1_);
            }
         }
         _loc4_ = 8;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = new farm.viewx.newPet.PetSkillItem(null,_loc3_++);
            _loc1_.iconPos = new Point(3,3);
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
            this._petSkill.addChild(_loc1_);
            this._itemViewVec.push(_loc1_);
         }
      }
      
      public function set scrollVisble(param1:Boolean) : void
      {
         this._petSkillScroll.vScrollbar.visible = param1;
      }
      
      private function removeItems() : void
      {
         var _loc1_:SkillItem = null;
         for each(_loc1_ in this._itemViewVec)
         {
            if(Boolean(_loc1_))
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._itemViewVec.splice(0,this._itemViewVec.length);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._petSkill);
         this._petSkill = null;
         ObjectUtils.disposeObject(this._petSkillScroll);
         this._petSkillScroll = null;
         this._itemInfoVec = null;
         this._itemViewVec = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
