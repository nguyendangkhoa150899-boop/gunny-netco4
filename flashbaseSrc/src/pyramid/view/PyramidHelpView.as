package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PyramidHelpView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _descripTxt:FilterFrameText;
      
      public function PyramidHelpView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("assets.pyramid.helpViewBg");
         addChild(this._bg);
         this._descripTxt = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.helpViewScriptTxt");
         this._descripTxt.text = "1. Nhấp rương từ tầng thấp nhất, nhấp Tiến lên " + "\n" + "để vào tầng kế, đạt tầng cao nhất sẽ nhận " + "\n" + "điểm tích lũy. " + "\n" + "2. Nhấp rương mỗi lần sẽ nhận điểm tích lũy trả " + "\n" + "lại và còn cơ hội nhận thưởng." + "\n" + "3. Điểm tích lũy thêm cuối mỗi vòng tính trên " + "\n" + "cơ sở tích lũy vòng đó. " + "\n" + "4. Điểm tích lũy dùng đổi vật phẩm ở Shop," + "\n" + "hoạt động kết thúc sau 24 giờ nếu không đổi" + "\n" + "sẽ đổi thành EXP hoặc công trạng.";
         this._list = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.helpViewVBox");
         this._list.addChild(this._descripTxt);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.helpViewScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._panel);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._descripTxt);
         this._descripTxt = null;
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}
