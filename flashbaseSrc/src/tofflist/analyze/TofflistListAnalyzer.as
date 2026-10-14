package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.describeType;
   import tofflist.data.TofflistConsortiaData;
   import tofflist.data.TofflistConsortiaInfo;
   import tofflist.data.TofflistListData;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistListAnalyzer extends DataAnalyzer
   {
       
      
      public var data:TofflistListData;
      
      private var _xml:XML;
      
      public function TofflistListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:TofflistPlayerInfo = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:TofflistConsortiaData = null;
         var _loc7_:TofflistConsortiaInfo = null;
         var _loc8_:TofflistPlayerInfo = null;
         this._xml = new XML(param1);
         var _loc9_:Array = new Array();
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
               _loc6_ = new TofflistConsortiaData();
               _loc7_ = new TofflistConsortiaInfo();
               ObjectUtils.copyPorpertiesByXML(_loc7_,_loc2_[_loc5_]);
               _loc6_.consortiaInfo = _loc7_;
               if(_loc2_[_loc5_].children().length() > 0)
               {
                  _loc8_ = new TofflistPlayerInfo();
                  _loc8_.beginChanges();
                  ObjectUtils.copyPorpertiesByXML(_loc8_,_loc2_[_loc5_].Item[0]);
                  _loc8_.commitChanges();
                  _loc6_.playerInfo = _loc8_;
                  _loc9_.push(_loc6_);
               }
               _loc5_++;
            }
            this.data.list = _loc9_;
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
