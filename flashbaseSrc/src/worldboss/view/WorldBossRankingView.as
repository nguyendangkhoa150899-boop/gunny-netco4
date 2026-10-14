package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossRankingView extends Component
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _container:VBox;
      
      public function WorldBossRankingView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._container = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingView.vbox");
         addChild(this._container);
      }
      
      public function set rankingInfos(param1:Vector.<RankingPersonInfo>) : void
      {
         var _loc2_:RankingPersonInfo = null;
         var _loc3_:RankingPersonInfoItem = null;
         var _loc4_:Rectangle = null;
         if(param1 == null)
         {
            return;
         }
         var _loc5_:int = 1;
         for each(_loc2_ in param1)
         {
            _loc3_ = new RankingPersonInfoItem(_loc5_++,_loc2_,true);
            _loc4_ = ComponentFactory.Instance.creatCustomObject("worldbossAward.rankingItemSize");
            this._container.addChild(_loc3_);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._container);
         this._container = null;
      }
   }
}
