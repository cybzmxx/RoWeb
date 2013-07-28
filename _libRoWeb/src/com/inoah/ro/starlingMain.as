package com.inoah.ro
{
    import com.inoah.ro.managers.DisplayMgr;
    import com.inoah.ro.ui.LoginView;
    
    import flash.display.Bitmap;
    
    import inoah.game.Global;
    import inoah.game.consts.MgrTypeConsts;
    import inoah.game.loaders.AtfLoader;
    import inoah.game.loaders.ILoader;
    import inoah.game.loaders.JpgLoader;
    import inoah.game.managers.AssetMgr;
    import inoah.game.managers.KeyMgr;
    import inoah.game.managers.MainMgr;
    import inoah.game.managers.SprMgr;
    import inoah.game.managers.TextureMgr;
    
    import morn.core.handlers.Handler;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    
    public class starlingMain extends Sprite
    {
        private var _loginView:LoginView;
        private var _bgImage:Image;
        
        public function starlingMain()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }
        
        private function addedToStageHandler(event:Event):void
        {
            MainMgr.instance;
            MainMgr.instance.addMgr( MgrTypeConsts.ASSET_MGR, new AssetMgr() );
            
            MainMgr.instance.addMgr( MgrTypeConsts.TEXTURE_MGR, new TextureMgr() );
            MainMgr.instance.addMgr( MgrTypeConsts.SPR_MGR , new SprMgr() );
            
            var displayMgr:DisplayMgr = new DisplayMgr( Starling.current.nativeStage , this );
            MainMgr.instance.addMgr( MgrTypeConsts.DISPLAY_MGR , displayMgr );
            MainMgr.instance.addMgr( MgrTypeConsts.KEY_MGR, new KeyMgr( Starling.current.nativeStage ) );
            
            addBgImage();
            
            App.init( displayMgr.uiLevel );
            App.loader.loadAssets( ["assets/comp.swf","assets/login_interface.swf", "assets/basic_interface.swf"] , new Handler( loadComplete ) );
        }
        
        private function addBgImage():void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            assetMgr.getRes( "loginBg.atf" , onAddBgImage );
        }
        
        private function onAddBgImage( loader:ILoader ):void
        {
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            var texture:Texture = Texture.fromAtfData( (loader as AtfLoader).data, 1 , false );
            _bgImage = new Image( texture );
            _bgImage.touchable = false;
            displayMgr.bgLevel.addChild( _bgImage );
        }
        
        private function loadComplete():void
        {
            _loginView = new LoginView();
            
            _loginView.x = Global.SCREEN_W / 2 - _loginView.width / 2;
            _loginView.y = Global.SCREEN_H / 2 - _loginView.height / 2;
            
            var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
            displayMgr.uiLevel.addChild( _loginView );
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            onInitRes( assetMgr );
        }
        
        /**
         * 初始加载，不必等待 作为预缓冲
         * @param assetMgr
         */        
        private function onInitRes( assetMgr:AssetMgr ):void
        {
            //            var resPathList:Vector.<String> = new Vector.<String>();
            //            assetMgr.getResList( resPathList , function():void{} );
        }
        
        public function tick( delta:Number ):void
        {
            
        }
    }
}