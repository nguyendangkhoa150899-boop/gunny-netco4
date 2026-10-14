package com.pickgliss.loader
{
   import flash.events.Event;
   
   public class LoaderEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const LOAD_ERROR:String = "loadError";
      
      public static const PROGRESS:String = "progress";
       
      
      public var loader:com.pickgliss.loader.BaseLoader;
      
      public function LoaderEvent(param1:String, param2:com.pickgliss.loader.BaseLoader)
      {
         this.loader = param2;
         super(param1);
      }
   }
}
