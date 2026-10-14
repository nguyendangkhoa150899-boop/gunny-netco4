package godCardRaise.model
{
   import flash.utils.Dictionary;
   
   public class GodCardRaiseModel
   {
       
      
      public var score:int;
      
      public var chipCount:int;
      
      public var freeCount:int;
      
      public var cards:Dictionary;
      
      public var awardIds:Dictionary;
      
      public var groups:Dictionary;
      
      public function GodCardRaiseModel()
      {
         this.cards = new Dictionary();
         this.awardIds = new Dictionary();
         this.groups = new Dictionary();
         super();
      }
   }
}
