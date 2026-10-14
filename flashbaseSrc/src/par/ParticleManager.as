package par
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ObjectUtils;
   import flash.system.ApplicationDomain;
   import flash.utils.describeType;
   import par.emitters.Emitter;
   import par.emitters.EmitterInfo;
   import par.lifeeasing.AbstractLifeEasing;
   import par.particals.ParticleInfo;
   import road7th.math.ColorLine;
   import road7th.math.XLine;
   
   public class ParticleManager
   {
      
      public static var list:Array = new Array();
      
      private static var _ready:Boolean;
      
      public static const PARTICAL_XML_PATH:String = "partical.xml";
      
      public static const SHAPE_PATH:String = "shape.swf";
      
      public static const PARTICAL_LITE:String = "particallite.xml";
      
      public static const SHAPE_LITE:String = "shapelite.swf";
      
      internal static var Domain:ApplicationDomain;
       
      
      public function ParticleManager()
      {
         super();
      }
      
      public static function get ready() : Boolean
      {
         return _ready;
      }
      
      public static function addEmitterInfo(param1:EmitterInfo) : void
      {
         list.push(param1);
      }
      
      public static function removeEmitterInfo(param1:EmitterInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < list.length)
         {
            if(list[_loc2_] == param1)
            {
               list.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public static function creatEmitter(param1:Number) : Emitter
      {
         var _loc2_:EmitterInfo = null;
         var _loc3_:Emitter = null;
         for each(_loc2_ in list)
         {
            if(_loc2_.id == param1)
            {
               _loc3_ = new Emitter();
               _loc3_.info = _loc2_;
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function clear() : void
      {
         list = new Array();
         _ready = false;
      }
      
      private static function load(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:EmitterInfo = null;
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc6_:ParticleInfo = null;
         var _loc7_:XMLList = null;
         var _loc8_:AbstractLifeEasing = null;
         var _loc9_:XML = null;
         var _loc10_:XMLList = param1..emitter;
         var _loc11_:XML = describeType(new ParticleInfo());
         var _loc12_:XML = describeType(new EmitterInfo());
         for each(_loc2_ in _loc10_)
         {
            _loc3_ = new EmitterInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc2_);
            _loc4_ = _loc2_.particle;
            for each(_loc5_ in _loc4_)
            {
               _loc6_ = new ParticleInfo();
               ObjectUtils.copyPorpertiesByXML(_loc6_,_loc5_);
               _loc7_ = _loc5_.easing;
               _loc8_ = new AbstractLifeEasing();
               for each(_loc9_ in _loc7_)
               {
                  if(_loc9_.@name != "colorLine")
                  {
                     _loc8_[_loc9_.@name].line = XLine.parse(_loc9_.@value);
                  }
                  else
                  {
                     _loc8_.colorLine = new ColorLine();
                     _loc8_.colorLine.line = XLine.parse(_loc9_.@value);
                  }
               }
               _loc6_.lifeEasing = _loc8_;
               _loc3_.particales.push(_loc6_);
            }
            list.push(_loc3_);
         }
         _ready = true;
      }
      
      public static function initPartical(param1:String, param2:String = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:BaseLoader = null;
         var _loc6_:ModuleLoader = null;
         if(!_ready && param1 != null)
         {
            Domain = new ApplicationDomain();
            _loc3_ = param1 + (param2 == "lite" ? PARTICAL_LITE : PARTICAL_XML_PATH);
            _loc4_ = param1 + (param2 == "lite" ? SHAPE_LITE : SHAPE_PATH);
            _loc5_ = LoaderManager.Instance.creatLoader(_loc3_,BaseLoader.TEXT_LOADER);
            _loc5_.addEventListener(LoaderEvent.COMPLETE,__loadComplete);
            LoaderManager.Instance.startLoad(_loc5_);
            _loc6_ = LoaderManager.Instance.creatLoader(_loc4_,BaseLoader.MODULE_LOADER,null,"GET",Domain);
            _loc6_.addEventListener(LoaderEvent.COMPLETE,__onShapeLoadComplete);
            LoaderManager.Instance.startLoad(_loc6_);
         }
      }
      
      private static function __onShapeLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,__onShapeLoadComplete);
         ShapeManager.setup();
      }
      
      private static function __loadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,__loadComplete);
         try
         {
            load(new XML(param1.loader.content));
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      private static function save() : XML
      {
         var _loc1_:EmitterInfo = null;
         var _loc2_:XML = null;
         var _loc3_:ParticleInfo = null;
         var _loc4_:XML = null;
         var _loc5_:XML = <list></list>;
         for each(_loc1_ in list)
         {
            _loc2_ = ObjectUtils.encode("emitter",_loc1_);
            for each(_loc3_ in _loc1_.particales)
            {
               _loc4_ = ObjectUtils.encode("particle",_loc3_);
               _loc4_.appendChild(encodeXLine("vLine",_loc3_.lifeEasing.vLine));
               _loc4_.appendChild(encodeXLine("rvLine",_loc3_.lifeEasing.rvLine));
               _loc4_.appendChild(encodeXLine("spLine",_loc3_.lifeEasing.spLine));
               _loc4_.appendChild(encodeXLine("sizeLine",_loc3_.lifeEasing.sizeLine));
               _loc4_.appendChild(encodeXLine("weightLine",_loc3_.lifeEasing.weightLine));
               _loc4_.appendChild(encodeXLine("alphaLine",_loc3_.lifeEasing.alphaLine));
               if(Boolean(_loc3_.lifeEasing.colorLine))
               {
                  _loc4_.appendChild(encodeXLine("colorLine",_loc3_.lifeEasing.colorLine));
               }
               _loc2_.appendChild(_loc4_);
            }
            _loc5_.appendChild(_loc2_);
         }
         return _loc5_;
      }
      
      private static function encodeXLine(param1:String, param2:XLine) : XML
      {
         return new XML("<easing name=\"" + param1 + "\" value=\"" + XLine.ToString(param2.line) + "\" />");
      }
   }
}
