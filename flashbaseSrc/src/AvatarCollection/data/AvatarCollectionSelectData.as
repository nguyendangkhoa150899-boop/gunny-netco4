package AvatarCollection.data
{
   public class AvatarCollectionSelectData
   {
       
      
      public var value:AvatarCollection.data.AvatarCollectionUnitVo;
      
      public var selected:Boolean = false;
      
      public function AvatarCollectionSelectData(param1:AvatarCollection.data.AvatarCollectionUnitVo, param2:Boolean)
      {
         super();
         this.value = param1;
         this.selected = param2;
      }
   }
}
