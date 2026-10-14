package hallIcon.info
{
   public class HallIconInfo
   {
       
      
      public var halltype:int;
      
      public var icontype:String;
      
      public var isopen:Boolean;
      
      public var timemsg:String;
      
      public var fightover:Boolean;
      
      public var orderid:int;
      
      public var num:int;
      
      public function HallIconInfo(param1:String = "", param2:Boolean = false, param3:String = null, param4:int = 0, param5:Boolean = false, param6:int = 0, param7:int = -1)
      {
         super();
         this.icontype = param1;
         this.isopen = param2;
         this.timemsg = param3;
         this.halltype = param4;
         this.fightover = param5;
         this.orderid = param6;
         this.num = param7;
      }
   }
}
