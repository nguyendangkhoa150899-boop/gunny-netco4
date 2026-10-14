package explorerManual.data.model
{
   public class ManualChapterInfo
   {
       
      
      private var _ID:int;
      
      private var _name:String;
      
      private var _describe:String;
      
      private var _sort:int;
      
      public function ManualChapterInfo()
      {
         super();
      }
      
      public function get Sort() : int
      {
         return this._sort;
      }
      
      public function set Sort(param1:int) : void
      {
         this._sort = param1;
      }
      
      public function get Describe() : String
      {
         return this._describe;
      }
      
      public function set Describe(param1:String) : void
      {
         this._describe = param1;
      }
      
      public function get Name() : String
      {
         return this._name;
      }
      
      public function set Name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get ID() : int
      {
         return this._ID;
      }
      
      public function set ID(param1:int) : void
      {
         this._ID = param1;
      }
   }
}
