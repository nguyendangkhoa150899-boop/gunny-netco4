package ddt.data.analyze
{
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import pyramid.data.PyramidSystemItemsInfo;
   
   public class ActivitySystemItemsDataAnalyzer extends DataAnalyzer
   {
       
      
      public var pyramidSystemDataList:Array;
      
      public var chickActivationDataList:Array;
      
      public function ActivitySystemItemsDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:PyramidSystemItemsInfo = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:ChickActivationInfo = null;
         var _loc9_:Array = null;
         this.pyramidSystemDataList = [];
         this.chickActivationDataList = [];
         var _loc10_:XML = new XML(param1);
         if(_loc10_.@value == "true")
         {
            _loc2_ = _loc10_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@ActivityType == "8")
               {
                  _loc4_ = new PyramidSystemItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  _loc5_ = this.pyramidSystemDataList[_loc4_.Quality - 1];
                  if(!_loc5_)
                  {
                     _loc5_ = [];
                  }
                  _loc5_.push(_loc4_);
                  this.pyramidSystemDataList[_loc4_.Quality - 1] = _loc5_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "40")
               {
                  _loc8_ = new ChickActivationInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc8_,_loc2_[_loc3_]);
                  if(_loc8_.Quality >= 10001 && _loc8_.Quality <= 10010)
                  {
                     _loc9_ = this.chickActivationDataList[12];
                     if(!_loc9_)
                     {
                        _loc9_ = new Array();
                     }
                     _loc9_.push(_loc8_);
                     _loc9_.sortOn("Quality",Array.NUMERIC);
                     this.chickActivationDataList[12] = _loc9_;
                  }
                  else
                  {
                     _loc9_ = this.chickActivationDataList[_loc8_.Quality];
                     if(!_loc9_)
                     {
                        _loc9_ = new Array();
                     }
                     _loc9_.push(_loc8_);
                     this.chickActivationDataList[_loc8_.Quality] = _loc9_;
                  }
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc10_.@message;
            onAnalyzeError();
         }
      }
   }
}
