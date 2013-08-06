package inoah.game.ro.mapModels
{
    import flash.display.Bitmap;
    import flash.geom.Point;
    
    import inoah.core.Global;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ILoader;
    import inoah.core.interfaces.IMapLevel;
    import inoah.core.loaders.JpgLoader;
    import inoah.core.managers.AssetMgr;
    import inoah.core.managers.MainMgr;
    import inoah.core.utils.Counter;
    import inoah.data.map.MapInfo;
    import inoah.data.map.MapTileSetInfo;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.textures.RenderTexture;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    /**
     *  
     * @author inoah
     */    
    public class BaseMapModel
    {
        protected var _mapInfo:MapInfo;
        protected var _container:DisplayObjectContainer;
        protected var _currentResIndexList:Vector.<String>;
        protected var _currentResList:Vector.<Bitmap>;
        protected var _currentTextureAtlasIndexList:Vector.<int>;
        protected var _currentTextureAtlasList:Vector.<TextureAtlas>;
        protected var _levelList:Vector.<IMapLevel>;
        protected var _mapImageList:Vector.<Image>;
        
        protected var _drawTileObj:DrawTileObj;
        private var _isDrawComplete:Boolean;
        private var _couldTick:Boolean;
        private var _drawCounter:Counter;
        
        public function BaseMapModel(  container:DisplayObjectContainer )
        {
            _container = container;
            _container.x = - Global.TILE_W * 4;
            _levelList = new Vector.<IMapLevel>();
            _currentResIndexList = new Vector.<String>();
            _currentResList = new Vector.<Bitmap>();
            _currentTextureAtlasIndexList = new Vector.<int>();
            _currentTextureAtlasList = new Vector.<TextureAtlas>();
            _mapImageList = new Vector.<Image>();
            _drawCounter = new Counter();
            _drawCounter.initialize();
        }
        
        public function init( mapInfo:MapInfo ):void
        {
            _mapInfo = mapInfo;
            
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var resList:Vector.<String> = new Vector.<String>();
            var len:int = _mapInfo.tilesets.length;
            for( var i:int =0;i<len;i++)
            {
                resList.push( "map/" + _mapInfo.tilesets[i].image );
                _currentResIndexList.push( "map/" + _mapInfo.tilesets[i].image );
            }
            assetMgr.getResList( resList , onLoadMapRes );
        }
        
        private function onLoadMapRes( loader:ILoader ):void
        {
            var assetMgr:AssetMgr = MainMgr.instance.getMgr( MgrTypeConsts.ASSET_MGR ) as AssetMgr;
            var tileSetList:Vector.<MapTileSetInfo> = _mapInfo.tilesets;
            var tileSet:MapTileSetInfo;
            var len:int = tileSetList.length;
            var iCount:int = 1;
            _currentTextureAtlasIndexList.push( int.MAX_VALUE );
            for( var i:int =0;i<len;i++)
            {
                tileSet = tileSetList[i];
                //get bitmap
                _currentResList.push( (assetMgr.getRes( "map/" + tileSet.image ,null ) as JpgLoader).content as Bitmap );
                //get textureAtlas
                var texture:Texture = Texture.fromBitmap( _currentResList[i], false );
                var atlasXml:XML = XML('<texture id="'+tileSet.name+'" width="'+2048+'" height="'+2048+'"></texture>');
                var sequenceCount:int = tileSet.imagewidth / tileSet.tilewidth * tileSet.imageheight / tileSet.tileheight;
                var subTexture:XML;
                var sx:int = 0;
                var sy:int = 0;
                var soffx:int = 0;
                var soffy:int = 0;
                for(var j:int = 0; j<sequenceCount; j++)
                {
                    subTexture = XML(<SubTexture />);
                    _currentTextureAtlasIndexList[iCount] = i;
                    subTexture.@name =  iCount.toString();
                    iCount ++;
                    subTexture.@width = tileSet.tilewidth;
                    subTexture.@height = tileSet.tileheight;
                    subTexture.@x = sx;
                    subTexture.@y = sy;
                    subTexture.@frameX = 0;
                    subTexture.@frameY = 0;
                    subTexture.@frameWidth = tileSet.tilewidth;
                    subTexture.@frameHeight = tileSet.tileheight;
                    atlasXml.appendChild(subTexture);
                    sx += tileSet.tilewidth;
                    if( sx >= tileSet.imagewidth )
                    {
                        sx = 0
                        sy += tileSet.tileheight;
                    }
                }
                _currentTextureAtlasList.push( new TextureAtlas( texture, atlasXml ) );
            }
            
            len = _mapInfo.layers.length;
            for( i=0;i<len;i++)
            {
                if( _mapInfo.layers[i].type == "tilelayer" )
                {
                    drawTile( i );
                    _couldTick = true;
                    return;
                }
                else if( _mapInfo.layers[i].type == "objectgroup" )
                {
//                    drawObject( i );
                }
            }
        }
        
        private function drawObject( index:int ):void
        {
            var bx:Number;
            var by:Number;
            var bw:Number;
            var bh:Number;
            //mapblocks
            var mbw:Number = _mapInfo.layers[index].width;
            var mbh:Number = _mapInfo.layers[index].height;
            //mapheight
            var w:int = mbw * Global.TILE_W;
            var h:int = mbh * Global.TILE_H / 2;
            
            var textureIndex:int;
            var len:int = _mapInfo.layers[ index ].objects.length;
            var image:Image;
            for( var i:int=0;i< len;i++)
            {
                if( _mapInfo.layers[index].objects[i].visible == false )
                {
                    continue;
                }
                //tileblockxy
                bx = _mapInfo.layers[ index ].objects[ i ].x / ( Global.TILE_W / 2 );
                by = _mapInfo.layers[ index ].objects[ i ].y / ( Global.TILE_H / 2 );
                //tileblocks
                bw = _mapInfo.layers[ index ].objects[ i ].width;
                bh = _mapInfo.layers[ index ].objects[ i ].height;
                
                textureIndex = _currentTextureAtlasIndexList[ _mapInfo.layers[ index ].objects[ i ].gid ];
                image = new Image( _currentTextureAtlasList[textureIndex].getTexture( _mapInfo.layers[ index ].objects[ i ].gid.toString() ) );
                image.touchable = false;
                
                if( bx > by )
                {
                    image.x = w / 2 * ( 1 + bx / mbw - by / mbh ) - bw / 2;
                    image.y = ( bx / mbw + by / mbh ) * h / 2 - bh  + Global.TILE_H / 2;
                }
                else if( bx < by )
                {
                    image.x = w / 2 * ( 1 + bx / mbw - by / mbh ) - bw / 2;
                    image.y = ( bx / mbw + by / mbh ) * h / 2 - bh + Global.TILE_H / 2;
                }
                else
                {
                    image.x = w / 2 - bw / 2;
                    image.y = ( bx / mbw + by / mbh ) * h / 2 - bh + Global.TILE_H / 2;
                }
                _container.addChild( image );
            }
        }
        
        private function drawTile( index:int ):void
        {
            _drawTileObj = new DrawTileObj();
            _drawTileObj.textureIndex = 0;
            _drawTileObj.mapDataArr = _mapInfo.layers[index].data;
            
            _drawTileObj.bw = _mapInfo.layers[index].width;
            _drawTileObj.bh = _mapInfo.layers[index].height;
            _drawTileObj.w = _mapInfo.layers[index].width * Global.TILE_W;
            _drawTileObj.h = _mapInfo.layers[index].height * Global.TILE_H;
            
            _drawTileObj.pointList = new Vector.<Point>();
            _drawTileObj.pointList.push( new Point() );
            _drawTileObj.pointList.push( new Point() );
            _drawTileObj.pointList.push( new Point() );
            _drawTileObj.pointList.push( new Point() );
            
            _drawTileObj.tmpRenderTexture = new Vector.<RenderTexture>();
            _drawTileObj.tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            _drawTileObj.tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            _drawTileObj.tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            _drawTileObj.tmpRenderTexture.push( new RenderTexture( 1600 , 832 ) );
            
            _drawTileObj.i = 0;
            _drawTileObj.j = 0;
            
            _isDrawComplete = false;
            _drawCounter.reset( 0.3 );
        }
        
        public function tick( delta:Number ):void
        {
            if( !_couldTick )
            {
                return;
            }
            if( !_isDrawComplete )
            {
                while( true )
                {
                    _drawCounter.tick( delta );
                    if( _drawCounter.expired )
                    {
                        _drawCounter.reset( 0.3 )
                        break;
                    }
                    drawTileStep();
                }
            }
        }
        
        private function drawTileStep():void
        {
            if( _drawTileObj.j >= _drawTileObj.bw )
            {
                _drawTileObj.j = 0;
                _drawTileObj.i++;
            }
            if( _drawTileObj.i < _drawTileObj.bh )
            {
                if( _drawTileObj.j < _drawTileObj.bw )
                {
                    _drawTileObj.textureIndex = _currentTextureAtlasIndexList[ _drawTileObj.mapDataArr[ _drawTileObj.j + _drawTileObj.i * _drawTileObj.bw ]];
                    _drawTileObj.image = new Image( _currentTextureAtlasList[ _drawTileObj.textureIndex ].getTexture( _drawTileObj.mapDataArr[ _drawTileObj.j + _drawTileObj.i * _drawTileObj.bw ].toString() ) );
                    if( _drawTileObj.j < 25 && _drawTileObj.i < 25 )
                    {
                        _drawTileObj.image.x =_drawTileObj.w / 4 - ( _drawTileObj.i + 1 ) * Global.TILE_W / 2 + _drawTileObj.j * Global.TILE_W / 2;
                        _drawTileObj.image.y = _drawTileObj.i * Global.TILE_H / 2 + _drawTileObj.j * Global.TILE_H / 2;
                        _drawTileObj.tmpRenderTexture[0].draw( _drawTileObj.image );
                    }
                    else if( _drawTileObj.j >= 25 && _drawTileObj.i < 25 )
                    {
                        _drawTileObj.image.x =_drawTileObj.w / 4 - ( _drawTileObj.i + 1 ) * Global.TILE_W / 2 + ( _drawTileObj.j - 25 ) * Global.TILE_W / 2;
                        _drawTileObj.image.y = _drawTileObj.i * Global.TILE_H / 2 + ( _drawTileObj.j - 25 ) * Global.TILE_H / 2;
                        _drawTileObj.tmpRenderTexture[1].draw( _drawTileObj.image );
                    }
                    else if( _drawTileObj.j < 25 && _drawTileObj.i >= 25 )
                    {
                        _drawTileObj.image.x =_drawTileObj.w / 4 - ( _drawTileObj.i + 1 - 25 ) * Global.TILE_W / 2 +  _drawTileObj.j * Global.TILE_W / 2;
                        _drawTileObj.image.y = ( _drawTileObj.i - 25 ) * Global.TILE_H / 2 + _drawTileObj.j * Global.TILE_H / 2;
                        _drawTileObj.tmpRenderTexture[2].draw( _drawTileObj.image );
                    }
                    else if( _drawTileObj.j>= 25 && _drawTileObj.i >= 25 )
                    {
                        _drawTileObj.image.x =_drawTileObj.w / 4 - ( _drawTileObj.i + 1 - 25 ) * Global.TILE_W / 2 + ( _drawTileObj.j - 25 ) * Global.TILE_W / 2;
                        _drawTileObj.image.y = ( _drawTileObj.i - 25 ) * Global.TILE_H / 2 + ( _drawTileObj.j - 25 ) * Global.TILE_H / 2;
                        _drawTileObj.tmpRenderTexture[3].draw( _drawTileObj.image );
                    }
                    _drawTileObj.j++;
                }
            }
            
            if( _drawTileObj.i >= _drawTileObj.bh )
            {
                _mapImageList[ 0 ] = new Image( _drawTileObj.tmpRenderTexture[0] );
                _mapImageList[ 0 ].touchable = false;
                _mapImageList[ 0 ].x = 800;
                _mapImageList[ 0 ].y = 0;
                _container.addChild( _mapImageList[ 0 ] );
                _mapImageList[ 1 ] = new Image( _drawTileObj.tmpRenderTexture[1] );
                _mapImageList[ 1 ].touchable = false;
                _mapImageList[ 1 ].x = 1600;
                _mapImageList[ 1 ].y = 400;
                _container.addChild( _mapImageList[ 1 ] );
                _mapImageList[ 2 ] = new Image( _drawTileObj.tmpRenderTexture[2] );
                _mapImageList[ 2 ].touchable = false;
                _mapImageList[ 2 ].x = 0;
                _mapImageList[ 2 ].y = 400;
                _container.addChild( _mapImageList[ 2 ] );
                _mapImageList[ 3 ] = new Image( _drawTileObj.tmpRenderTexture[3] );
                _mapImageList[ 3 ].touchable = false;
                _mapImageList[ 3 ].x = 800;
                _mapImageList[ 3 ].y = 800;
                _container.addChild( _mapImageList[ 3 ] );
                _isDrawComplete = true;
            }
        }
    }
}