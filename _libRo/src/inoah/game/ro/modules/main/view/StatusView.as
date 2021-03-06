package inoah.game.ro.modules.main.view
{
    import flash.events.MouseEvent;
    
    import game.ui.sysViews.statusViewUI;
    
    import inoah.core.infos.UserInfo;
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    public class StatusView extends statusViewUI
    {
        public function StatusView()
        {
            super();
            
            this.btnClose.addEventListener( MouseEvent.CLICK, onCloseHandler );
            this.btnStr.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnAgi.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnVit.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnInt.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnDex.addEventListener( MouseEvent.CLICK, onAddPointHandler );
            this.btnLuk.addEventListener( MouseEvent.CLICK, onAddPointHandler );
        }
        
        protected function onAddPointHandler( e:MouseEvent ):void
        {
            //            var userInfo:UserInfo = Global.userInfo;
            //            switch( e.currentTarget )
            //            {
            //                case btnStr:
            //                {
            //                    userInfo.statusPoint -= 1;
            //                    userInfo.strength += 1;
            //                    break;
            //                }
            //                case btnAgi:
            //                {
            //                    userInfo.statusPoint -= 1;
            //                    userInfo.agile += 1;
            //                    break;
            //                }
            //                case btnVit:
            //                {
            //                    userInfo.statusPoint -= 1;
            //                    userInfo.vit += 1;
            //                    break;
            //                }
            //                case btnInt:
            //                {
            //                    userInfo.statusPoint -= 1;
            //                    userInfo.intelligence += 1;
            //                    break;
            //                }
            //                case btnDex:
            //                {
            //                    userInfo.statusPoint -= 1;
            //                    userInfo.dexterous += 1;
            //                    break;
            //                }
            //                case btnLuk:
            //                {
            //                    userInfo.statusPoint -= 1;
            //                    userInfo.lucky += 1;
            //                    break;
            //                }
            //                default:
            //                {
            //                    break;
            //                }
            //            }
            //            dispatchEvent( new GameEvent( GameEvent.UPDATE_STATUS_POINT ) );
        }
        
        public function updateInfo( userModel:UserModel ):void
        {
            var userInfo:UserInfo = userModel.info as UserInfo;
            
            this.labStr.text = userInfo.strength + "";
            this.labAgi.text = userInfo.agile + "";
            this.labVit.text = userInfo.vit + "";
            this.labInt.text = userInfo.intelligence + "";
            this.labDex.text = userInfo.dexterous + "";
            this.labLuk.text = userInfo.lucky + "";
            this.labAtk.text = userInfo.atk + "";
            this.labMAtk.text = userInfo.matk + "";
            this.labHit.text = userInfo.hit + "";
            this.labCritical.text = userInfo.critical + "";
            this.labDef.text = userInfo.def + "";
            this.labMDef.text = userInfo.mdef + "";
            this.labFlee.text = userInfo.flee + "";
            this.labAspd.text = userInfo.aspd + "";
            this.labStatusPoint.text = userInfo.statusPoint + "";
            
            var bool:Boolean = userInfo.statusPoint > 0;
            this.btnStr.visible = bool;
            this.btnAgi.visible = bool;
            this.btnVit.visible = bool;
            this.btnInt.visible = bool;
            this.btnDex.visible = bool;
            this.btnLuk.visible = bool;
            
            this.labUpStr.visible = false;
            this.labUpAgi.visible = false;
            this.labUpVit.visible = false;
            this.labUpInt.visible = false;
            this.labUpDex.visible = false;
            this.labUpLuk.visible = false;
        }
        
        protected function onCloseHandler( e:MouseEvent):void
        {
            dispatchEvent( new GameEvent( GameEvent.CLOSE_STATUS ) );
        }
    }
}