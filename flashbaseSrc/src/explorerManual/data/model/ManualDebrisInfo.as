package explorerManual.data.model
{
   public class ManualDebrisInfo
   {
       
      
      private var _ID:int;
      
      private var _pageID:int;
      
      private var _sort:int;
      
      private var _imagePath:String;
      
      private var _describe:String;
      
      private var _jampsCurrency:int;
      
      public function ManualDebrisInfo()
      {
         super();
      }
      
      public function get JampsCurrency() : int
      {
         return this._jampsCurrency;
      }
      
      public function set JampsCurrency(param1:int) : void
      {
         this._jampsCurrency = param1;
      }
      
      public function get Describe() : String
      {
         return this._describe;
      }
      
      public function set Describe(param1:String) : void
      {
         this._describe = param1;
      }
      
      public function get ImagePath() : String
      {
         return this._imagePath;
      }
      
      public function set ImagePath(param1:String) : void
      {
         this._imagePath = param1;
      }
      
      public function get Sort() : int
      {
         return this._sort;
      }
      
      public function set Sort(param1:int) : void
      {
         this._sort = param1;
      }
      
      public function get PageID() : int
      {
         return this._pageID;
      }
      
      public function set PageID(param1:int) : void
      {
         this._pageID = param1;
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
