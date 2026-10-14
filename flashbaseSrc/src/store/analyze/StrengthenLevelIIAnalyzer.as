package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.store.StrengthenLevelII;
   import flash.utils.Dictionary;
   
   public class StrengthenLevelIIAnalyzer extends DataAnalyzer
   {
       
      
      public var LevelItems1:Dictionary;
      
      public var LevelItems2:Dictionary;
      
      public var LevelItems3:Dictionary;
      
      public var LevelItems4:Dictionary;
      
      public var SucceedRate:int;
      
      private var _xml:XML;
      
      public function StrengthenLevelIIAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:StrengthenLevelII = null;
         this._xml = new XML(param1);
         this.LevelItems1 = new Dictionary(true);
         this.LevelItems2 = new Dictionary(true);
         this.LevelItems3 = new Dictionary(true);
         this.LevelItems4 = new Dictionary(true);
         var _loc4_:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length())
            {
               _loc3_ = new StrengthenLevelII();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc4_[_loc2_]);
               this.SucceedRate = _loc3_.DamagePlusRate;
               this.LevelItems1[_loc3_.StrengthenLevel] = _loc3_.Rock;
               this.LevelItems2[_loc3_.StrengthenLevel] = _loc3_.Rock1;
               this.LevelItems3[_loc3_.StrengthenLevel] = _loc3_.Rock2;
               this.LevelItems4[_loc3_.StrengthenLevel] = _loc3_.Rock3;
               _loc2_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
