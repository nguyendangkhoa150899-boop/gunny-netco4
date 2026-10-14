package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.describeType;
   import tofflist.data.TofflistListData;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistListTwoAnalyzer extends DataAnalyzer
   {
       
      
      private var _xml:XML;
      
      public var data:TofflistListData;
      
      public function TofflistListTwoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:TofflistPlayerInfo = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:TofflistPlayerInfo = null;
         this._xml = new XML(param1);
         var _loc7_:Array = new Array();
         this.data = new TofflistListData();
         this.data.lastUpdateTime = this._xml.@date;
         if(this._xml.@value == "true")
         {
            _loc2_ = XML(this._xml)..Item;
            _loc3_ = new TofflistPlayerInfo();
            _loc4_ = describeType(_loc3_);
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length())
            {
               _loc6_ = new TofflistPlayerInfo();
               _loc6_.beginChanges();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc2_[_loc5_]);
               _loc6_.commitChanges();
               _loc7_.push(_loc6_);
               _loc5_++;
            }
            this.data.list = _loc7_;
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
