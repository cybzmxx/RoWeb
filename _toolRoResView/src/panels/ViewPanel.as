package panels
{
    import com.bit101.components.InputText;
    import com.bit101.components.Label;
    import com.bit101.components.Panel;
    import com.bit101.components.PushButton;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.net.URLLoader;
    
    import consts.AppConsts;
    
    import inoah.core.consts.ConstsDirIndex;
    import inoah.core.infos.CharacterInfo;
    
    import robotlegs.bender.framework.api.IInjector;
    
    public class ViewPanel extends Panel
    {
        [Inject]
        public var injector:IInjector;
        
        private var _txtPath:InputText;
        
        private var _dirUpBtn:PushButton;
        private var _dirDownBtn:PushButton;
        private var _dirLeftBtn:PushButton;
        private var _dirRightBtn:PushButton;
        
        private var _dirUpLeftBtn:PushButton;
        private var _dirUpRightBtn:PushButton;
        private var _dirDownLeftBtn:PushButton;
        private var _dirDownRightBtn:PushButton;
        
        private var _actLoader:URLLoader;
        private var _sprLoader:URLLoader;
        
        private var _url:String;
        private var _couldTick:Boolean;
        
        private var _charView:ECharacterView;
        private var _actionIndexLabel:Label;
        private var _actionTxt:InputText;
        private var _prewActionBtn:PushButton;
        private var _nextActionBtn:PushButton;
        private var _switchType:uint;
        private var _charInfo:CharacterInfo;
        
        public function ViewPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
        }
        
        override protected function init():void
        {
            super.init();
            
            _txtPath = new InputText( this , 0 , 0 ,"aaa" );
            _txtPath.setSize( 450, 30 );
            
            var startPosX:int = 10;
            var startPosY:int = 40;
            
            _dirUpBtn = new PushButton( this, startPosX + 55 , startPosY , "U", onClickPanelHandler );
            _dirUpBtn.setSize( 40, 40 );
            _dirDownBtn = new PushButton( this, startPosX + 55 , startPosY + 110, "D", onClickPanelHandler );
            _dirDownBtn.setSize( 40, 40 );
            _dirLeftBtn = new PushButton( this, startPosX , startPosY + 55 , "L", onClickPanelHandler );
            _dirLeftBtn.setSize( 40, 40 );
            _dirRightBtn = new PushButton( this, startPosX + 110 , startPosY + 55 , "R", onClickPanelHandler );
            _dirRightBtn.setSize( 40, 40 );
            
            _dirUpLeftBtn = new PushButton( this, startPosX , startPosY , "UL", onClickPanelHandler );
            _dirUpLeftBtn.setSize( 40, 40 );
            _dirUpRightBtn = new PushButton( this, startPosX + 110, startPosY , "UR", onClickPanelHandler );
            _dirUpRightBtn.setSize( 40, 40 );
            _dirDownLeftBtn = new PushButton( this, startPosX , startPosY + 110, "DL", onClickPanelHandler );
            _dirDownLeftBtn.setSize( 40, 40 );
            _dirDownRightBtn = new PushButton( this, startPosX + 110 , startPosY + 110, "DR", onClickPanelHandler );
            _dirDownRightBtn.setSize( 40, 40 );
            
            _actionIndexLabel = new Label( this, startPosX, startPosY + 155 , "actionIndex: " );
            
            _prewActionBtn = new PushButton( this, startPosX, startPosY + 180, "-" );
            _prewActionBtn.setSize( 24 , 24 );
            _actionTxt = new InputText( this , startPosX + 24, startPosY + 180 );
            _actionTxt.setSize( 48, 24 );
            _actionTxt.enabled = false;
            _nextActionBtn = new PushButton( this, startPosX + 72, startPosY + 180 ,  "+" );
            _nextActionBtn.setSize( 24 , 24 );
            _prewActionBtn.addEventListener( MouseEvent.CLICK, onChangeActionHandler );
            _nextActionBtn.addEventListener( MouseEvent.CLICK, onChangeActionHandler );
            
            setSize( AppConsts.VIEW_PANEL_WIDTH - 350, AppConsts.HEIGHT );
        }
        
        protected function onChangeActionHandler(e:MouseEvent):void
        {
            if( e.currentTarget == _prewActionBtn )
            {
                if( _charView )
                {
                    if( _charView.action > 0 )
                    {
                        _charView.setActionIndex( _charView.action - 8 );
                    }
                }
            }
            else if( e.currentTarget == _nextActionBtn )
            {
                if( _charView )
                {
                    if( _charView.action < _charView.actions.GetNumAction() - 8 )
                    {
                        _charView.setActionIndex( _charView.action + 8 );
                    }
                }
            }
            _actionTxt.text = _charView.action.toString();
        }        
        
        protected function onClickPanelHandler( e:MouseEvent):void
        {
            switch(  e.target )
            {
                case _dirUpBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.UP );
                    break;
                }
                case _dirDownBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.DOWN );
                    break;
                }
                case _dirLeftBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.LEFT );
                    break;
                }
                case _dirRightBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.RIGHT );
                    break;
                }
                case _dirUpLeftBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.UP_LIFT );
                    break;
                }
                case _dirUpRightBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.UP_RIGHT );
                    break;
                }
                case _dirDownLeftBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.DOWN_LEFT );
                    break;
                }
                case _dirDownRightBtn:
                {
                    _charView.setDirIndex( ConstsDirIndex.DOWN_RIGHT );
                    break;
                }
            }
        }
        
        override public function draw():void
        {
            super.draw();
        }
        
        public function showAct(data:String , swtichType:uint):void
        {
            _couldTick = false;
            _url = data;
            _switchType = swtichType;
            
            if( !_charInfo )
            {
                _charInfo = new CharacterInfo();
                _charInfo.init( "", "", false );
            }
            switch( _switchType )
            {
                case 0:
                {
                    _charInfo.setBodyRes( data );
                    _txtPath.text = data;
                    break;
                }
                case 1:
                {
                    _charInfo.setHeadRes( data );
                    break;
                }
                case 2:
                {
                    _charInfo.setWeaponRes( data );
                    break;
                }
            }
            if( !_charView )//&& _charInfo.isReady )
            {
                var sh:Shape = new Shape();
                sh.graphics.lineStyle( 1 , 0xff0000 );
                sh.graphics.drawRect( 0, 400, 500 , 1 );
                addChild( sh );
                sh = new Shape();
                sh.graphics.lineStyle( 1 , 0xff0000 );
                sh.graphics.drawRect( 200 , 0 , 1 , 500 );
                addChild( sh );

                _charView = new ECharacterView();
                injector.injectInto(_charView);
                _charView.initInfo( _charInfo );
                _charView.x = 200;
                _charView.y = 400;
                addChild( _charView );
            }
            else
            {
                _charView.updateCharInfo( _charInfo );
            }
            
            if( _actionTxt.text == "" )
            {
                _actionTxt.text = "0";
            }
            
            _couldTick = true;
        }
        
        public function tick(delta:Number):void
        {
            if( !_couldTick )
            {
                return;
            }
            if( _charView )
            {
                if( !StarlingMain.actSprView && _charView.bodyView )
                {
                    StarlingMain.actSprView = _charView.bodyView;
                }
                _charView.tick( delta );
            }
        }
    }
}