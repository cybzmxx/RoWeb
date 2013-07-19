package com.inoah.ro.managers
{
    import com.inoah.ro.interfaces.IMgr;
    
    import flash.utils.ByteArray;
    
    import starling.textures.Texture;
    
    /**
     * 贴图管理器 
     * @author inoah
     */    
    public class TextureMgr implements IMgr
    {
        private var _atfDataListIndex:Vector.<ByteArray>;
        private var _textureList:Vector.<Texture>;
        private var _usedCountList:Vector.<int>;
        private var _resIdList:Vector.<String>;
        
        private var _isDisposed:Boolean;
        
        public function TextureMgr()
        {
            _atfDataListIndex= new Vector.<ByteArray>();
            _textureList = new Vector.<Texture>();
            _usedCountList = new Vector.<int>();
            _resIdList = new Vector.<String>();
        }
        
        public function getTexture( resId:String , atfByte:ByteArray, loadAsync:Function=null):Texture
        {
            var index:int = _atfDataListIndex.indexOf( atfByte );
            if( index == -1 )
            {
                _atfDataListIndex.push( atfByte );
                _textureList.push( Texture.fromAtfData( atfByte, 1, false, loadAsync) );
                index = _atfDataListIndex.indexOf( atfByte );
                _usedCountList[index] = 0;
                _resIdList[index] = resId;
            }
            else
            {
                loadAsync( _textureList[index] );
            }
            if(resId == "hy_cha_normal_muye1_0"  )
            {
                var bool:Boolean = true;
            }
            _usedCountList[index]++;
            return _textureList[index];
        }
        
        public function disposeTexture( texture:Texture ):void
        {
            var index:int = _textureList.indexOf( texture );
            if(index != -1 )
            {
                _usedCountList[index]--;
                var usedCount:int = _usedCountList[index];
                if(_resIdList[index] == "hy_cha_normal_muye1_0")
                {
                    var bool:Boolean = true;
                }
                if(usedCount == 0)
                {
                    _textureList[index].dispose();
                    _textureList.splice( index ,1 );
                    _atfDataListIndex.splice( index , 1 );
                    _usedCountList.splice( index ,  1 );
                    _resIdList.splice( index ,  1 );
                }
            }
        }
        
        public function dispose():void 
        {
            if (_isDisposed == false)
            {
                _isDisposed = true;
                distruct ();
            }
        }
        
        protected function distruct():void 
        {
        }
        
        public function get isDisposed():Boolean 
        {
            return _isDisposed;
        }
    }
}

