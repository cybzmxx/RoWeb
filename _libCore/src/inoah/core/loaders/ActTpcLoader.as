package inoah.core.loaders
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    import inoah.core.consts.MgrTypeConsts;
    import inoah.game.ro.viewModels.actSpr.structs.CACT;
    import inoah.core.managers.MainMgr;
    import inoah.core.managers.TextureMgr;
    
    import starling.textures.TextureAtlas;
    import inoah.core.interfaces.ILoader;
    
    public class ActTpcLoader extends EventDispatcher implements ILoader
    {
        protected var _cact:CACT;
        protected var _textureAtlas:TextureAtlas;
        protected var _actUrl:String;
        protected var _tpcUrl:String;
        protected var _actLoader:URLLoader;
        protected var _tpcLoader:URLLoader;
        
        public function ActTpcLoader( tpcPath:String )
        {
            _tpcUrl = tpcPath;
            _actUrl = _tpcUrl.replace( "tpc" , "act" );
        }
        
        public function get cact():CACT
        {
            return _cact;
        }

        public function get textureAtlas():TextureAtlas
        {
            return _textureAtlas;
        }
        
        public function get actUrl():String
        {
            return _actUrl;
        }
        
        public function get url():String
        {
            return _tpcUrl;
        }
        
        public function load():void
        {
            _actLoader = new URLLoader();
            _actLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _actLoader.addEventListener( Event.COMPLETE, onActLoaderComplete );
            _actLoader.load( new URLRequest( _actUrl ) );
        }
        
        protected function onActLoaderComplete( e:Event):void
        {
            _actLoader.removeEventListener( Event.COMPLETE, onActLoaderComplete );
            
            _cact = new CACT( _actLoader.data );
            
            _tpcLoader = new URLLoader();
            _tpcLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _tpcLoader.addEventListener( Event.COMPLETE, onTpcLoaderComplete );
            _tpcLoader.load( new URLRequest( _tpcUrl ) );
        }
        
        protected function onTpcLoaderComplete( e:Event):void
        {
            _tpcLoader.removeEventListener( Event.COMPLETE, onTpcLoaderComplete );
            
            var textureMgr:TextureMgr = MainMgr.instance.getMgr( MgrTypeConsts.TEXTURE_MGR ) as TextureMgr;
            var data:ByteArray = _tpcLoader.data;
            data.inflate();
            var len:int = data.readByte();
            len = data.readUnsignedInt();
            var textureData:ByteArray = new ByteArray();
            data.readBytes( textureData , 0,  len );
            len = data.readUnsignedInt();
            var atlasXml:XML = XML( decodeURI( data.readUTFBytes( len ) ) );
            textureMgr.getTextureAtlas( _tpcUrl , textureData , atlasXml , onInited );
        }
        
        private function onInited( textureAtlas:TextureAtlas = null):void
        {
            _textureAtlas = textureAtlas;
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
    }
}