package com.pickgliss.ui.controls
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   [Event(name="stateChange",type="com.pickgliss.events.InteractiveEvent")]
   public class ComboBox extends Component
   {
      
      public static const P_button:String = "button";
      
      public static const P_defaultShowState:String = "currentShowState";
      
      public static const P_listInnerRect:String = "listInnerRect";
      
      public static const P_listPanel:String = "listPanel";
      
      public static const P_textField:String = "textField";
      
      public static const P_textInnerRect:String = "textInnerRect";
      
      protected static const COMBOX_HIDE_STATE:int = 0;
      
      protected static const COMBOX_SHOW_STATE:int = 1;
      
      public static var HIDE:int = 0;
      
      public static var SHOW:int = 1;
      
      public static const P_snapItemHeight:String = "snapItemHeight";
       
      
      protected var _button:com.pickgliss.ui.controls.BaseButton;
      
      protected var _buttonStyle:String;
      
      protected var _comboboxZeroPos:Point;
      
      protected var _currentSelectedCellValue;
      
      protected var _currentSelectedIndex:int = -1;
      
      protected var _currentSelectedItem;
      
      protected var _defaultShowState:int = 0;
      
      protected var _listInnerRect:InnerRectangle;
      
      protected var _listInnerRectString:String;
      
      protected var _listPanel:com.pickgliss.ui.controls.ListPanel;
      
      protected var _listPanelStyle:String;
      
      protected var _maskExtends:int = 100;
      
      protected var _maskShape:Shape;
      
      protected var _selctedPropName:String;
      
      protected var _state:int;
      
      protected var _textField:TextField;
      
      protected var _textInnerRect:InnerRectangle;
      
      protected var _textRectString:String = "textRectString";
      
      protected var _textStyle:String;
      
      protected var _tweenY:int;
      
      protected var _maxHeight:int = 540;
      
      protected var _easeType:int = 1;
      
      private var mGrayLayer:Sprite;
      
      protected var _snapItemHeight:Boolean;
      
      public function ComboBox()
      {
         super();
      }
      
      public function set button(param1:com.pickgliss.ui.controls.BaseButton) : void
      {
         if(this._button == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._button);
         this._button = param1;
         onPropertiesChanged("button");
      }
      
      public function get button() : com.pickgliss.ui.controls.BaseButton
      {
         return this._button;
      }
      
      public function set buttonStyle(param1:String) : void
      {
         if(this._buttonStyle == param1)
         {
            return;
         }
         this._buttonStyle = param1;
         this.button = ComponentFactory.Instance.creat(this._buttonStyle);
      }
      
      public function get currentSelectedCellValue() : *
      {
         return this._currentSelectedCellValue;
      }
      
      public function get currentSelectedIndex() : int
      {
         return this._currentSelectedIndex;
      }
      
      public function set currentSelectedIndex(param1:int) : void
      {
         this._listPanel.list.currentSelectedIndex = param1;
      }
      
      public function get currentSelectedItem() : *
      {
         return this._currentSelectedItem;
      }
      
      public function set defaultShowState(param1:int) : void
      {
         if(this._defaultShowState == param1)
         {
            return;
         }
         this._defaultShowState = param1;
         onPropertiesChanged("currentShowState");
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._listPanel) && Boolean(this._listPanel.list))
         {
            this._listPanel.list.removeStateListener(this.updateListSize);
         }
         StageReferance.stage.removeEventListener("click",this.__onStageClick);
         StageReferance.stage.removeEventListener("mouseDown",this.__onStageDown);
         removeEventListener("addedToStage",this.__onAddToStage);
         if(Boolean(this._listPanel) && Boolean(this._listPanel.list))
         {
            this._listPanel.list.removeEventListener("listItemClick",this.__onItemChanged);
         }
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = null;
         ObjectUtils.disposeObject(this._button);
         this._button = null;
         ObjectUtils.disposeObject(this._textField);
         this._textField = null;
         ObjectUtils.disposeObject(this._maskShape);
         this._maskShape = null;
         this._listInnerRect = null;
         super.dispose();
      }
      
      public function doHide() : void
      {
         if(this._state == HIDE)
         {
            return;
         }
         if(this._listPanel.vectorListModel == null)
         {
            return;
         }
         if(this._listPanel.vectorListModel.getSize() == 0)
         {
            return;
         }
         this._defaultShowState = 0;
         TweenLite.killTweensOf(this._listPanel);
         TweenLite.to(this._listPanel,ComponentSetting.COMBOBOX_HIDE_TIME,{
            "y":this._comboboxZeroPos.y - this._listPanel.height,
            "ease":ComponentSetting.COMBOBOX_HIDE_EASE_FUNCTION,
            "onComplete":this.onHideComplete
         });
         this._state = HIDE;
      }
      
      public function doShow() : void
      {
         if(this._state == SHOW)
         {
            return;
         }
         if(this._listPanel.vectorListModel == null)
         {
            return;
         }
         if(this._listPanel.vectorListModel.getSize() == 0)
         {
            return;
         }
         this.onPosChanged();
         this._defaultShowState = 1;
         if(Boolean(this._listPanel))
         {
            ComponentSetting.COMBOX_LIST_LAYER.addChild(this._listPanel.asDisplayObject());
         }
         ComponentSetting.COMBOX_LIST_LAYER.addChild(this._maskShape);
         TweenLite.killTweensOf(this._listPanel);
         TweenLite.to(this._listPanel,ComponentSetting.COMBOBOX_SHOW_TIME,{
            "y":this._tweenY,
            "ease":ComponentSetting.COMBOBOX_SHOW_EASE_FUNCTION
         });
         this._state = SHOW;
      }
      
      public function set listInnerRect(param1:InnerRectangle) : void
      {
         if(this._listInnerRect != null && this._listInnerRect.equals(param1))
         {
            return;
         }
         this._listInnerRect = param1;
         onPropertiesChanged("listInnerRect");
      }
      
      public function set listInnerRectString(param1:String) : void
      {
         if(this._listInnerRectString == param1)
         {
            return;
         }
         this._listInnerRectString = param1;
         this.listInnerRect = ClassUtils.CreatInstance("com.pickgliss.geom.InnerRectangle",ComponentFactory.parasArgs(this._listInnerRectString));
      }
      
      public function get listPanel() : com.pickgliss.ui.controls.ListPanel
      {
         return this._listPanel;
      }
      
      public function set listPanel(param1:com.pickgliss.ui.controls.ListPanel) : void
      {
         if(this._listPanel == param1)
         {
            return;
         }
         if(Boolean(this._listPanel))
         {
            this._listPanel.list.removeEventListener("listItemClick",this.__onItemChanged);
         }
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = param1;
         this._listPanel.list.addEventListener("listItemClick",this.__onItemChanged);
         onPropertiesChanged("listPanel");
      }
      
      public function set listPanelStyle(param1:String) : void
      {
         if(this._listPanelStyle == param1)
         {
            return;
         }
         this._listPanelStyle = param1;
         this.listPanel = ComponentFactory.Instance.creat(this._listPanelStyle);
      }
      
      public function set selctedPropName(param1:String) : void
      {
         if(this._selctedPropName == param1)
         {
            return;
         }
         this._selctedPropName = param1;
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
      
      public function set textField(param1:TextField) : void
      {
         if(this._textField == param1)
         {
            return;
         }
         this._textField = param1;
         onPropertiesChanged("textField");
      }
      
      public function set textInnerRect(param1:InnerRectangle) : void
      {
         if(this._textInnerRect != null && this._textInnerRect.equals(param1))
         {
            return;
         }
         this._textInnerRect = param1;
         onPropertiesChanged("textInnerRect");
      }
      
      public function set textInnerRectString(param1:String) : void
      {
         if(this._textRectString == param1)
         {
            return;
         }
         this._textRectString = param1;
         this.textInnerRect = ClassUtils.CreatInstance("com.pickgliss.geom.InnerRectangle",ComponentFactory.parasArgs(this._textRectString));
      }
      
      public function set textStyle(param1:String) : void
      {
         if(this._textStyle == param1)
         {
            return;
         }
         this._textStyle = param1;
         this.textField = ComponentFactory.Instance.creat(this._textStyle);
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._button.enable = param1;
         if(!param1)
         {
            this.mGrayLayer = new Sprite();
            this.mGrayLayer.width = 500;
            this.mGrayLayer.height = 500;
            this.mGrayLayer.alpha = 0.5;
            addChild(this.mGrayLayer);
         }
         else if(Boolean(this.mGrayLayer) && Boolean(this.mGrayLayer.parent))
         {
            this.mGrayLayer.parent.removeChild(this.mGrayLayer);
         }
      }
      
      public function get enable() : Boolean
      {
         return this._button.enable;
      }
      
      protected function __onItemChanged(param1:ListItemEvent) : void
      {
         this._currentSelectedItem = param1.cell;
         this._currentSelectedCellValue = param1.cellValue;
         this._currentSelectedIndex = param1.index;
         if(this._selctedPropName != null)
         {
            this._textField.text = param1.cell[this._selctedPropName];
         }
         dispatchEvent(new InteractiveEvent("stateChange"));
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._button))
         {
            addChild(this._button);
         }
         if(Boolean(this._textField))
         {
            addChild(this._textField);
         }
      }
      
      override protected function init() : void
      {
         this._maskShape = new Shape();
         addEventListener("addedToStage",this.__onAddToStage);
         StageReferance.stage.addEventListener("click",this.__onStageClick);
         StageReferance.stage.addEventListener("mouseDown",this.__onStageDown);
         super.init();
      }
      
      protected function __onStageClick(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(!DisplayUtils.isTargetOrContain(_loc2_,this) && !DisplayUtils.isTargetOrContain(_loc2_,this._listPanel))
         {
            return;
         }
         if(DisplayUtils.isTargetOrContain(_loc2_,this._button) || DisplayUtils.isTargetOrContain(_loc2_,this._listPanel.list))
         {
            if(this._state == HIDE)
            {
               this.doShow();
            }
            else
            {
               this.doHide();
            }
         }
      }
      
      protected function __onStageDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(DisplayUtils.isTargetOrContain(_loc2_,this._listPanel) || DisplayUtils.isTargetOrContain(_loc2_,this))
         {
            return;
         }
         this.doHide();
      }
      
      protected function onHideComplete() : void
      {
         if(Boolean(this._listPanel) && Boolean(this._listPanel.parent))
         {
            this._listPanel.parent.removeChild(this._listPanel.asDisplayObject());
         }
         if(Boolean(this._maskShape) && Boolean(this._maskShape.parent))
         {
            this._maskShape.parent.removeChild(this._maskShape);
         }
      }
      
      override protected function onPosChanged() : void
      {
         this._comboboxZeroPos = DisplayUtils.getPointFromObject(new Point(0,0),this,ComponentSetting.COMBOX_LIST_LAYER);
         if(this._comboboxZeroPos.y + this._listInnerRect.para2 + this._listInnerRect.para4 > this._maxHeight)
         {
            this._tweenY = this._comboboxZeroPos.y - this._listInnerRect.para4;
            this._easeType = 2;
         }
         else
         {
            this._tweenY = this._comboboxZeroPos.y + this._listInnerRect.para2;
            this._easeType = 1;
         }
         this.updateListPos();
         this.updateMask();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(Boolean(_changedPropeties["listInnerRect"]) || Boolean(_changedPropeties["height"]) || Boolean(_changedPropeties["width"]) || Boolean(_changedPropeties["currentShowState"]) || Boolean(_changedPropeties["listPanel"]))
         {
            this.onPosChanged();
            this.updateListSize();
            if(Boolean(this._listPanel))
            {
               this._listPanel.list.addStateListener(this.updateListSize);
            }
         }
         if(Boolean(_changedPropeties["textInnerRect"]) || Boolean(_changedPropeties["height"]) || Boolean(_changedPropeties["width"]))
         {
            DisplayUtils.layoutDisplayWithInnerRect(this._textField,this._textInnerRect,_width,_height);
         }
         if(Boolean(_changedPropeties["height"]) || Boolean(_changedPropeties["width"]))
         {
            this._button.beginChanges();
            this._button.width = _width;
            this._button.height = _height;
            this._button.commitChanges();
         }
      }
      
      protected function updateListPos() : void
      {
         var _loc1_:Rectangle = null;
         if(this._listInnerRect == null || this._listPanel == null)
         {
            return;
         }
         _loc1_ = this._listInnerRect.getInnerRect(_width,_height);
         this._listPanel.x = this._comboboxZeroPos.x + _loc1_.x;
         this._listPanel.y = this._comboboxZeroPos.y + _loc1_.y;
         if(this._defaultShowState == 0)
         {
            if(this._easeType == 1)
            {
               this._listPanel.y = this._comboboxZeroPos.y - this._listPanel.height;
            }
            else
            {
               this._listPanel.y = this._comboboxZeroPos.y;
            }
         }
         else if(this._defaultShowState == 1)
         {
            this._listPanel.y = this._comboboxZeroPos.y + this._listInnerRect.para2;
         }
      }
      
      protected function updateListSize(param1:InteractiveEvent = null) : void
      {
         if(this._listPanel == null)
         {
            return;
         }
         var _loc2_:Rectangle = this._listInnerRect.getInnerRect(_width,_height);
         if(this._snapItemHeight)
         {
            this._listPanel.height = this._listPanel.list.getViewSize().height + this._listPanel.getShowHScrollbarExtendHeight();
         }
         else
         {
            this._listPanel.height = _loc2_.height;
         }
         this._listPanel.width = _loc2_.width;
         this._maskShape = DisplayUtils.drawRectShape(this._listPanel.width + 2 * this._maskExtends,this._listPanel.height + this._maskExtends * 2,this._maskShape);
         this.updateMask();
      }
      
      protected function updateMask() : void
      {
         if(!this._listPanel)
         {
            return;
         }
         this._listPanel.mask = this._maskShape;
         this._maskShape.x = this._comboboxZeroPos.x - this._maskExtends;
         this._maskShape.y = this._easeType == 1 ? this._comboboxZeroPos.y + _height : Number(this._comboboxZeroPos.y - this._maskShape.height);
      }
      
      public function set snapItemHeight(param1:Boolean) : void
      {
         if(this._snapItemHeight == param1)
         {
            return;
         }
         this._snapItemHeight = param1;
         onPropertiesChanged("snapItemHeight");
      }
      
      protected function __onAddToStage(param1:Event) : void
      {
         this.onPosChanged();
      }
   }
}
