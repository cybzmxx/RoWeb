package com.inoah.ro.displays.starling
{
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0101;
    
    import starling.textures.Texture;
    
    
    public class TpcOtherView extends TpcView
    {
        private var _bodyView:TpcBodyView;
        
        public function TpcOtherView( bodyView:TpcBodyView )
        {
            super();
            _bodyView = bodyView;
        }
        
        override public function tick(delta:Number):void
        {

        }
        
        override public function updateFrame():void
        {
            _currentAaap = _tpAnimation.act.aall.aa[_actionIndex].aaap[_currentFrame];
            
            var isExt:Boolean = false;
            if( _currentAaap.apsList.length == 0 )
            {
                return;
            }
            
            var apsv:AnyPatSprV0101 = _currentAaap.apsList[0];
            if( !apsv )
            {
                return;
            }
            if( apsv.sprNo == 0xffffffff )
            {
                if( _currentAaap.apsList.length > 1)
                {
                    apsv = _currentAaap.apsList[1];
                    isExt = true;
                }
            }
            if( apsv as AnyPatSprV0101 && apsv.sprNo != 0xffffffff )
            {
                var mTexture:Texture = _tpAnimation.getTexture( apsv.sprNo );
                if( mTexture )
                {
                    _animationDisplay.texture = mTexture ;
                }
                
                if( apsv.mirrorOn == 0 )
                {
                    _animationDisplay.x = int(-_animationDisplay.texture.width / 2 + apsv.xOffs + _bodyView.currentAaap.ExtXoffs - _currentAaap.ExtXoffs );
                    _animationDisplay.y = int(-_animationDisplay.texture.height / 2 + apsv.yOffs + _bodyView.currentAaap.ExtYoffs - _currentAaap.ExtYoffs);
                    _animationDisplay.scaleX = 1;
                }
                else
                {
                    _animationDisplay.x = int(_animationDisplay.texture.width / 2 + apsv.xOffs + _bodyView.currentAaap.ExtXoffs - _currentAaap.ExtXoffs );
                    _animationDisplay.y = int(-_animationDisplay.texture.height / 2 + apsv.yOffs + _bodyView.currentAaap.ExtYoffs - _currentAaap.ExtYoffs );
                    _animationDisplay.scaleX = -1;
                }
                _animationDisplay.readjustSize();
            }
        }
    }
}