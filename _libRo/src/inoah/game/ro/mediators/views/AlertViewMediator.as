package inoah.game.ro.mediators.views
{
    import inoah.core.consts.ConstsGame;
    import inoah.core.consts.commands.GameCommands;
    import inoah.game.ro.ui.sysView.AlertView;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    public class AlertViewMediator extends Mediator
    {
        private var _msgList:Vector.<String>;
        
        public function AlertViewMediator( viewComponent:Object=null)
        {
            super(ConstsGame.ALERT_VIEW, viewComponent);
            _msgList = new Vector.<String>();
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.SHOW_ALERT  );
            arr.push( GameCommands.HIDE_ALERT  );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array;
            switch( notification.getName() )
            {
                case GameCommands.SHOW_ALERT:
                {
                    arr = notification.getBody() as Array;
                    showAlert( arr[0] );
                    break;
                }
                case GameCommands.HIDE_ALERT:
                {
                    hideAlert();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function showAlert( msg:String ):void
        {
            _msgList.push( msg );
            mainView.txtMsg.text = msg;
        }
        
        private function hideAlert():void
        {
            _msgList.shift();
            if( _msgList.length > 0 )
            {
                mainView.txtMsg.text = _msgList[0];
            }
            else
            {
                mainView.parent.removeChild( mainView );
            }
        }
        
        public function get mainView():AlertView
        {
            return viewComponent as AlertView;
        }
    }
}