package com.inoah.ro.controllers
{
    import com.inoah.ro.objects.BaseObject;
    
    import as3.patterns.mediator.Mediator;
    
    import starling.animation.IAnimatable;

    public class BaseController extends Mediator
    {
        protected var _animationUnitList:Vector.<IAnimatable>;
        protected var _me:BaseObject;
        
        public function BaseController()
        {
            _animationUnitList = new Vector.<IAnimatable>();
        }
        
        public function unsetupListener():void
        {
            
        }
        
        public function setupListener():void
        {
            
        }
        
        public function appendAnimateUnit(animateUnit:IAnimatable):void
        {
            if(_animationUnitList.indexOf(animateUnit)<0)
            {
                _animationUnitList.push(animateUnit);
            }
        }
            
        public function tick(delta:Number):void
        {
            var len:int = _animationUnitList.length;
            var animateUnit:IAnimatable;
            
            for(var i:int = 0; i<len; i++)
            {
                animateUnit = _animationUnitList[i];
                animateUnit.advanceTime(delta);
                
                if((animateUnit as Object).hasOwnProperty("isComplete") == true &&
                    animateUnit["isComplete"] == true )
                {
                    _animationUnitList.splice(i,1);
                    len--;
                    i--;
                    continue;
                }
            }
        }
        
        public function get me():BaseObject
        {
            return _me;
        }
        
        public function set me( value:BaseObject ):void
        {
            _me = value;
        }
    }
}