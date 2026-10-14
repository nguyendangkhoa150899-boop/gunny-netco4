package littleGame.data
{
   internal class Link
   {
       
      
      public var node:littleGame.data.Node;
      
      public var cost:Number;
      
      public function Link(param1:littleGame.data.Node, param2:Number)
      {
         super();
         this.node = param1;
         this.cost = param2;
      }
   }
}
