package
{
   import character.CharacterType;
   import character.ComplexBitmapCharacter;
   import character.ICharacter;
   import character.MovieClipCharacter;
   import character.SimpleBitmapCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class CharacterFactory
   {
      
      private static var _instance:CharacterFactory;
       
      
      private var _filse:Dictionary;
      
      private var _loadedResource:Array;
      
      private var _bitmapdatas:Dictionary;
      
      private var _characterDefines:Dictionary;
      
      private var _movieClips:Dictionary;
      
      private var _loader:URLLoader;
      
      public function CharacterFactory()
      {
         this._filse = new Dictionary();
         super();
         this._loadedResource = [];
         this._bitmapdatas = new Dictionary();
         this._characterDefines = new Dictionary();
         this._movieClips = new Dictionary();
         this._loader = new URLLoader();
         this._loader.dataFormat = URLLoaderDataFormat.BINARY;
      }
      
      public static function get Instance() : CharacterFactory
      {
         if(_instance == null)
         {
            _instance = new CharacterFactory();
         }
         return _instance;
      }
      
      public function addResource(param1:String) : URLLoader
      {
         var onComplete:Function = null;
         var url:String = param1;
         onComplete = null;
         onComplete = function(param1:Event):void
         {
            _loader.removeEventListener(Event.COMPLETE,onComplete);
            var _loc2_:ByteArray = _loader.data;
            readFile(_loc2_);
            _loadedResource.push(url);
         };
         var request:URLRequest = new URLRequest(url);
         this._loader.addEventListener(Event.COMPLETE,onComplete,false,99);
         this._loader.load(request);
         return this._loader;
      }
      
      public function hasResource(param1:String) : Boolean
      {
         return this._loadedResource.indexOf(param1) > -1;
      }
      
      public function hasChactater(param1:String) : Boolean
      {
         return this._characterDefines[param1] != null;
      }
      
      public function creatChacrater(param1:String) : ICharacter
      {
         var _loc2_:XML = null;
         var _loc3_:* = null;
         var _loc4_:ICharacter = null;
         for(_loc3_ in this._characterDefines)
         {
            if(Boolean(this._characterDefines[_loc3_][param1]))
            {
               _loc2_ = this._characterDefines[_loc3_][param1];
               break;
            }
         }
         if(Boolean(_loc2_))
         {
            if(int(_loc2_.@type) == CharacterType.SIMPLE_BITMAP_TYPE)
            {
               _loc4_ = new SimpleBitmapCharacter(this._bitmapdatas[_loc3_][String(_loc2_.@resource)],_loc2_);
            }
            else if(int(_loc2_.@type) == CharacterType.COMPLEX_BITMAP_TYPE)
            {
               _loc4_ = new ComplexBitmapCharacter(this._bitmapdatas[_loc3_],_loc2_);
            }
            else if(int(_loc2_.@type) == CharacterType.MOVIECLIP_TYPE)
            {
               _loc4_ = new MovieClipCharacter(null,_loc2_,param1);
            }
         }
         return _loc4_;
      }
      
      public function releaseResource() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:BitmapData = null;
         for each(_loc1_ in this._bitmapdatas)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.dispose();
            }
         }
         this._bitmapdatas = new Dictionary();
         this._filse = new Dictionary();
         this._characterDefines = new Dictionary();
      }
      
      public function hasFile(param1:String) : Boolean
      {
         return this._filse[param1] == true;
      }
      
      public function addFile(param1:String, param2:ByteArray) : void
      {
         this._filse[param1] = true;
         this.readFile(param2);
      }
      
      public function readFile(param1:ByteArray) : void
      {
         var assetNum:int;
         var assetInitNum:int;
         var swfNum:int;
         var swfInitNum:int;
         var monstNum:int;
         var i:int;
         var j:int;
         var fileDescription:XML;
         var characters:XMLList;
         var fileName:String;
         var characterDefines:Dictionary;
         var k:int;
         var bitmapdatas:Dictionary = null;
         var loaderComplete:Function = null;
         var file:ByteArray = param1;
         bitmapdatas = null;
         loaderComplete = null;
         var label:String = null;
         var content:ByteArray = null;
         var contentLen:uint = 0;
         var loader:Loader = null;
         var swfLabel:String = null;
         var swfContent:ByteArray = null;
         var swfLen:uint = 0;
         var ld:Loader = null;
         var context:LoaderContext = null;
         var description:XML = null;
         loaderComplete = function(param1:Event):void
         {
            var _loc2_:Loader = LoaderInfo(param1.target).loader;
            _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderComplete);
            bitmapdatas[_loc2_.name] = Bitmap(_loc2_.content).bitmapData;
         };
         if(file.position == 0)
         {
            file.uncompress();
         }
         else
         {
            file.position = 0;
         }
         assetNum = 0;
         assetInitNum = 0;
         swfNum = 0;
         swfInitNum = 0;
         monstNum = 0;
         assetNum = file.readByte();
         i = 0;
         while(i < assetNum)
         {
            label = file.readUTF();
            content = new ByteArray();
            contentLen = file.readUnsignedInt();
            file.readBytes(content,0,contentLen);
            loader = new Loader();
            loader.name = label;
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
            loader.loadBytes(content);
            i++;
         }
         swfNum = file.readByte();
         j = 0;
         while(j < swfNum)
         {
            swfLabel = file.readUTF();
            swfContent = new ByteArray();
            swfLen = file.readUnsignedInt();
            file.readBytes(swfContent,0,swfLen);
            ld = new Loader();
            context = new LoaderContext(false,ApplicationDomain.currentDomain);
            ld.loadBytes(swfContent,context);
            j++;
         }
         fileDescription = new XML(file.readUTF());
         characters = fileDescription..character;
         fileName = fileDescription.@fileName;
         bitmapdatas = new Dictionary();
         characterDefines = new Dictionary();
         monstNum = characters.length();
         k = 0;
         while(k < monstNum)
         {
            description = characters[k];
            characterDefines[String(description.@label)] = description;
            k++;
         }
         this._characterDefines[fileName] = characterDefines;
         this._bitmapdatas[fileName] = bitmapdatas;
      }
   }
}
