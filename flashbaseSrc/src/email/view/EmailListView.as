package email.view
{
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.manager.LanguageMgr;
   import email.data.EmailInfo;
   import email.data.EmailType;
   import email.manager.MailManager;
   import flash.events.Event;
   
   public class EmailListView extends VBox
   {
       
      
      private var _strips:Array;
      
      public function EmailListView()
      {
         super();
         this._strips = new Array();
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function update(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:EmailInfo = null;
         var _loc4_:Number = NaN;
         var _loc5_:EmailStrip = null;
         this.clearElements();
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            _loc3_ = param1[_loc6_] as EmailInfo;
            if(_loc3_.Type == 59)
            {
               _loc3_.ValidDate = 24 * 3;
            }
            _loc4_ = MailManager.Instance.calculateRemainTime(_loc3_.SendTime,_loc3_.ValidDate);
            if(_loc4_ == -1)
            {
               this.clearElements();
               MailManager.Instance.changeSelected(null);
               MailManager.Instance.removeMail(_loc3_);
               return;
            }
            if(param2)
            {
               _loc5_ = new EmailStripSended();
            }
            else
            {
               _loc5_ = new EmailStrip();
            }
            _loc5_.addEventListener(EmailStrip.SELECT,this.__select);
            _loc5_.info = param1[_loc6_] as EmailInfo;
            if(_loc5_.info.Title == LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Object") && _loc5_.info.Type == 9)
            {
               if(Boolean(_loc5_.info.Annex1))
               {
                  _loc5_.info.Annex1.ValidDate = -1;
               }
            }
            addChild(_loc5_);
            this._strips.push(_loc5_);
            _loc6_++;
         }
         refreshChildPos();
      }
      
      public function switchSeleted() : void
      {
         if(this.allHasSelected())
         {
            this.changeAll(false);
            return;
         }
         this.changeAll(true);
      }
      
      private function allHasSelected() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._strips.length)
         {
            if(!(EmailStrip(this._strips[_loc1_]).info.Type == EmailType.ADVERT_MAIL || EmailStrip(this._strips[_loc1_]).info.Type == EmailType.CONSORTIONQUIT_EMAIL))
            {
               if(!EmailStrip(this._strips[_loc1_]).selected)
               {
                  return false;
               }
            }
            _loc1_++;
         }
         return true;
      }
      
      private function changeAll(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._strips.length)
         {
            EmailStrip(this._strips[_loc2_]).selected = param1;
            _loc2_++;
         }
      }
      
      public function getSelectedMails() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this._strips.length)
         {
            if(EmailStrip(this._strips[_loc2_]).selected)
            {
               _loc1_.push(EmailStrip(this._strips[_loc2_]).info);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function updateInfo(param1:EmailInfo) : void
      {
         var _loc2_:EmailStrip = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in this._strips)
         {
            if(param1 == _loc2_.info)
            {
               _loc2_.info = param1;
               break;
            }
         }
      }
      
      private function clearElements() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._strips.length)
         {
            this._strips[_loc1_].removeEventListener(EmailStrip.SELECT,this.__select);
            this._strips[_loc1_].dispose();
            this._strips[_loc1_] = null;
            _loc1_++;
         }
         this._strips = new Array();
      }
      
      private function __select(param1:Event) : void
      {
         var _loc2_:EmailStrip = null;
         var _loc3_:EmailStrip = param1.target as EmailStrip;
         for each(_loc2_ in this._strips)
         {
            if(_loc2_ != _loc3_)
            {
               _loc2_.isReading = false;
            }
         }
      }
      
      internal function canChangePage() : Boolean
      {
         var _loc1_:EmailStrip = null;
         for each(_loc1_ in this._strips)
         {
            if(_loc1_.emptyItem)
            {
               return false;
            }
         }
         return true;
      }
   }
}
