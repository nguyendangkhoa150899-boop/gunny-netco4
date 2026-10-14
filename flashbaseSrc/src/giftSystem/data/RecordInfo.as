package giftSystem.data
{
   public class RecordInfo
   {
       
      
      public var giftCount:int = 0;
      
      public var recordList:Vector.<giftSystem.data.RecordItemInfo>;
      
      public function RecordInfo()
      {
         this.recordList = new Vector.<RecordItemInfo>();
         super();
      }
   }
}
