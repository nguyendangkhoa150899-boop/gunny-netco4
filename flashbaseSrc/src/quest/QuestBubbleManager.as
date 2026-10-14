package quest
{
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class QuestBubbleManager extends EventDispatcher
   {
      
      private static var _instance:quest.QuestBubbleManager;
       
      
      private var _view:quest.QuestBubble;
      
      private var _model:quest.QuestBubbleMode;
      
      public const SHOWTASKTIP:String = "show_task_tip";
      
      public function QuestBubbleManager()
      {
         super();
      }
      
      public static function get Instance() : quest.QuestBubbleManager
      {
         if(_instance == null)
         {
            _instance = new quest.QuestBubbleManager();
         }
         return _instance;
      }
      
      public function get view() : quest.QuestBubble
      {
         return this._view;
      }
      
      public function show() : void
      {
         if(Boolean(this._view))
         {
            return;
         }
         this._model = new quest.QuestBubbleMode();
         if(this._model.questsInfo.length <= 0)
         {
            this._model = null;
            dispatchEvent(new Event(this.SHOWTASKTIP));
            return;
         }
         this._view = new quest.QuestBubble();
         this._view.start(this._model.questsInfo);
         this._view.show();
      }
      
      public function dispose(param1:Boolean = false) : void
      {
         ObjectUtils.disposeObject(this._view);
         this._view = null;
      }
   }
}
