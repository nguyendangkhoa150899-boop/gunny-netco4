package consortionBattle.player
{
   import com.pickgliss.loader.BitmapLoader;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.character.BaseLayer;
   import flash.display.Bitmap;
   
   public class ConsBattSceneCharacterLayer extends BaseLayer
   {
       
      
      private var _equipType:int;
      
      private var _sex:Boolean;
      
      private var _index:int;
      
      private var _direction:int;
      
      public function ConsBattSceneCharacterLayer(param1:ItemTemplateInfo, param2:int, param3:Boolean, param4:int, param5:int)
      {
         this._equipType = param2;
         this._sex = param3;
         this._index = param4;
         this._direction = param5;
         super(param1);
      }
      
      override protected function initLoaders() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:BitmapLoader = null;
         if(_info != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _info.Property8.length)
            {
               _loc2_ = this.getUrl(int(_info.Property8.charAt(_loc1_)));
               _loc3_ = ConsortiaBattleManager.instance.createLoader(_loc2_);
               _queueLoader.addLoader(_loc3_);
               _loc1_++;
            }
            _defaultLayer = 0;
            _currentEdit = _queueLoader.length;
         }
      }
      
      override public function reSetBitmap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         this.clearBitmap();
         _loc1_ = 0;
         while(_loc1_ < _queueLoader.loaders.length)
         {
            if(_queueLoader.loaders[_loc1_].content)
            {
               _loc2_ = new Bitmap((_queueLoader.loaders[_loc1_].content as Bitmap).bitmapData);
            }
            _bitmaps.push(_loc2_);
            if(Boolean(_bitmaps[_loc1_]))
            {
               _bitmaps[_loc1_].smoothing = true;
               _bitmaps[_loc1_].visible = false;
               addChild(_bitmaps[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      override protected function clearBitmap() : void
      {
         while(Boolean(this) && this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         _bitmaps = new Vector.<Bitmap>();
      }
      
      override protected function getUrl(param1:int) : String
      {
         var _loc2_:String = this._equipType == 1 ? "face" : (this._equipType == 2 ? "cloth" : "hair");
         var _loc3_:String = this._sex ? "M" : "F";
         var _loc4_:String = _loc2_ + (this._direction == 1 ? "" : "F");
         return ConsortiaBattleManager.instance.resourcePrUrl + _loc2_ + "/" + _loc3_ + "/" + String(this._index) + "/" + _loc4_ + "/" + String(param1) + ".png";
      }
   }
}
