package inoah.core.events
{
    import flash.events.Event;
    
    public class ActSprEvent extends Event
    {
        public static var NEXT_FRAME:String = "ActSprViewEvent.next_frame";
        public static var ACTION_END:String = "ActSprViewEvent.action_end";
        public static var ACTION_DEAD_START:String = "ActSprViewEvent.action_dead_start";
        public static var ACTION_DEAD_END:String = "ActSprViewEvent.action_dead_end";
        
        public function ActSprEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}