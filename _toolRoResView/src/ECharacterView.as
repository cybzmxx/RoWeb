package
{
    import inoah.core.characters.nogpu.CharacterView;
    
    public class ECharacterView extends CharacterView
    {
        public function ECharacterView()
        {
            super();
        }
        
        override public function tick(delta:Number):void
        {
            if( _bodyView )
            {
                _bodyView.loop = true;
                _bodyView.tick( delta );
            }
        }
        
        public function setActionIndex( value:uint ):void
        {
            _currentIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
            var len:int = _otherViews.length;
            for( var i:int = 0;i<len;i++)
            {
                if( _otherViews[i] )
                {
                    _otherViews[i].actionIndex = _currentIndex + _dirIndex;
                }
            }
        }
    }
}