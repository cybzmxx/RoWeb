package inoah.game.ro.managers
{
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    import inoah.core.consts.ConstsActions;
    import inoah.core.consts.commands.BattleCommands;
    import inoah.core.infos.BattleCharacterInfo;
    import inoah.game.ro.objects.BattleCharacterObject;
    import inoah.game.ro.objects.CharacterObject;
    import inoah.game.ro.objects.MonsterObject;
    import inoah.game.ro.objects.PlayerObject;
    import inoah.interfaces.base.ITickable;
    import inoah.interfaces.map.ISceneMediator;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    
    /**
     * 战斗管理器 （ 主要的战斗逻辑 ）
     * @author inoah
     */    
    public class BattleMgr extends Mediator implements ITickable
    {
        protected var _scene:ISceneMediator;
        protected var _animationUnitList:Vector.<IAnimatable>;
        
        public function BattleMgr( scene:ISceneMediator )
        {
            _animationUnitList = new Vector.<IAnimatable>();
            _scene = scene;
            addContextListener( BattleCommands.PLAYER_ATTACK , handleNotification , null );
            addContextListener( BattleCommands.MONSTER_ATTACK , handleNotification , null );
            
        }
        
        public function handleNotification( e:Event ):void
        {
            //            var arr:Array;
            //            switch( notification.getName() )
            //            {
            //                case BattleCommands.PLAYER_ATTACK:
            //                {
            //                    arr = notification.getBody() as Array;
            //                    onPlayerAttack( arr[0] , arr[1] );
            //                    break;
            //                }
            //                case BattleCommands.MONSTER_ATTACK:
            //                {
            //                    arr = notification.getBody() as Array;
            //                    onMonsterAttatk( arr[0] , arr[1] );
            //                    break;
            //                }
            //                default:
            //                {
            //                    break;
            //                }
            //            }
        }
        
        private function onPlayerAttack( meTarget:PlayerObject , atkTarget:BattleCharacterObject ):void
        {
            //            var atkTargetInfo:BattleCharacterInfo = atkTarget.info as BattleCharacterInfo;
            //            var meTargetInfo:BattleCharacterInfo = meTarget.info as BattleCharacterInfo;
            //            var isCritical:Boolean = (Math.random() * 100 + meTargetInfo.critical ) >= 100;
            //            var atkPoint:uint = isCritical?meTargetInfo.atk * 2:meTargetInfo.atk;
            //            var textField:TextField = new TextField();
            //            var tf:TextFormat = new TextFormat( "宋体" , 28 , 0xffffff );
            //            textField.defaultTextFormat = tf;
            //            textField.text =atkPoint.toString();
            //            textField.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            //            textField.y = -50;
            //            textField.x = - textField.textWidth >> 1;
            //            //            (atkTarget.viewObject as DisplayObjectContainer).addChild( textField );
            //            var tween:Tween = new Tween( textField , 0.6 );
            //            tween.moveTo( - textField.textWidth >> 1, - 150 );
            //            tween.onComplete = onBlooded;
            //            tween.onCompleteArgs = [textField];
            //            appendAnimateUnit( tween );
            
            //            var monsterCtrl:MonsterController = facade.retrieveMediator( ConstsGame.MONSTER_CONTROLLER ) as MonsterController
            //            monsterCtrl.fightTo( atkTarget as MonsterObject, meTarget ); 
            //            
            //            atkTarget.hp -= atkPoint; 
            //            
            //            var msg:String;
            //            if( isCritical )
            //            {
            //                msg =  "<font color='#00ff00'>" + meTargetInfo.name + "对" + atkTargetInfo.name + "造成" + atkPoint + "伤害(爆击)</font>";
            //            }
            //            else
            //            {
            //                msg =  "<font color='#00ff00'>" + meTargetInfo.name + "对" + atkTargetInfo.name + "造成" + atkPoint + "伤害</font>";
            //            }
            //            facade.sendNotification( GameCommands.RECV_CHAT , [ msg ] );
            //            
            //            if(atkTarget.hp==0)
            //            {
            //                meTargetInfo.baseExp += 5;
            //                msg =  "<font color='#ffff00'>" + meTargetInfo.name + "获得5点经验，升级总经验" + Math.pow( meTargetInfo.baseLv + 1, 3 )+ "</font>";
            //                facade.sendNotification( GameCommands.RECV_CHAT , [ msg ] );
            //                
            //                atkTarget.action = ConstsActions.Die;
            //                atkTarget.isDead = true;
            //                tween = new Tween( atkTarget.viewObject, 5 );
            //                tween.fadeTo( 0 );
            //                tween.onComplete = onRemoveAtkTarget;
            //                tween.onCompleteArgs = [atkTarget];
            //                appendAnimateUnit( tween );
            //            }
        }
        
        private function onMonsterAttatk( meTarget:MonsterObject , atkTarget:BattleCharacterObject ):void 
        {
            var atkTargetInfo:BattleCharacterInfo = atkTarget.info as BattleCharacterInfo;
            var meTargetInfo:BattleCharacterInfo = meTarget.info as BattleCharacterInfo;
            var isCritical:Boolean = (Math.random() * 100 + meTargetInfo.critical ) >= 100;
            var atkPoint:uint = isCritical?meTargetInfo.atk * 2:meTargetInfo.atk;
            var textField:TextField = new TextField();
            var tf:TextFormat = new TextFormat( "宋体" , 28 , 0xffffff );
            textField.defaultTextFormat = tf;
            textField.text =atkPoint.toString();
            textField.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            textField.y = -50;
            textField.x = - textField.textWidth >> 1;
            //            (atkTarget.viewObject as DisplayObjectContainer).addChild( textField );
            var tween:Tween = new Tween( textField , 0.6 );
            tween.moveTo( - textField.textWidth >> 1, - 150 );
            tween.onComplete = onBlooded;
            tween.onCompleteArgs = [textField];
            appendAnimateUnit( tween );
            
            atkTarget.hp -= atkPoint; 
            
            var msg:String;
            if( isCritical )
            {
                msg =  "<font color='#00ff00'>" + meTargetInfo.name + "对" + atkTargetInfo.name + "造成" + atkPoint + "伤害(爆击)</font>";
            }
            else
            {
                msg =  "<font color='#00ff00'>" + meTargetInfo.name + "对" + atkTargetInfo.name + "造成" + atkPoint + "伤害</font>";
            }
            //            facade.sendNotification( GameCommands.RECV_CHAT , [ msg ] );
            
            if(atkTarget.hp==0)
            {
                msg =  "<font color='#ffff00'>" + meTargetInfo.name + "获得5点经验，升级总经验" + Math.pow( meTargetInfo.baseLv + 1, 3 )+ "</font>";
                //                facade.sendNotification( GameCommands.RECV_CHAT , [ msg ] );
                
                atkTarget.action = ConstsActions.Die;
                atkTarget.isDead = true;
                tween = new Tween( atkTarget.viewObject, 5 );
                tween.fadeTo( 0 );
                tween.onComplete = onRemoveAtkTarget;
                tween.onCompleteArgs = [atkTarget];
                appendAnimateUnit( tween );
            }
        }
        
        private function onBlooded( textField:TextField ):void
        {
            if( textField.parent )
            {
                textField.parent.removeChild( textField );
            }
        }
        
        private function onRemoveAtkTarget( atkTarget:CharacterObject ):void
        {
            _scene.removeObject( atkTarget );
        }
        
        public function appendAnimateUnit(animateUnit:IAnimatable):void
        {
            if(_animationUnitList.indexOf(animateUnit)<0)
            {
                _animationUnitList.push(animateUnit);
            }
        }
        
        public function tick( delta:Number ):void
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
        
        public function get couldTick():Boolean
        {
            return true;
        }
        public function dispose():void
        {
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
    }
}