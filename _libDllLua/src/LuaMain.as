package
{
    import com.adobe.utils.AGALMacroAssembler;
    import com.inoah.ro.LuaDisplayObject;
    
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    import interfaces.ILuaMain;
    
    import sample.lua.CModule;
    import sample.lua.__lua_objrefs;
    import sample.lua.vfs.ISpecialFile;
    
    import starling.textures.RenderTexture;

    public class LuaMain implements ISpecialFile, ILuaMain
    {
        private static var _luaMain:LuaMain;
        private static var luastate:int;
        
        public function LuaMain()
        {
            var pointlessref1:LuaDisplayObject = null;
            var pointlessref2:AGALMacroAssembler = null;
            var pointlesref3:RenderTexture = null;
            
            _luaMain = this;
            
            CModule.rootSprite = this;
            CModule.vfs.console = this;
            CModule.startAsync(this);
        }
        
        public function runScript( luaStr:String ):void
        {
            var err:int = 0;
            luastate = luaL_newstate();
            
            luaL_openlibs(luastate);
            err = luaL_loadstring(luastate, luaStr);
            if(err) 
            {
                lua_settop(luastate, -2);
                lua_close(luastate);
                output("Can't parse script: " + err);
                return;
            }
            
            var runtime:int = getTimer();
            err = lua_pcallk(luastate, 0, LUA_MULTRET, 0, 0, null);
            runtime = getTimer() - runtime;
            output("Script time: " + runtime + "ms" );/* + " final stack depth: " + Lua.lua_gettop(luastate) */
            
            if (err) 
            {
                output("Failed to run script: " +  lua_tolstring(luastate, -1, 0));
            }
            else
            {
                var result:Number = lua_tonumberx(luastate, -1, 0);
                output("Script returned: " + result);
            }
            
            lua_settop(luastate, -2);
            lua_close(luastate);
        }
        
        private function lua_tonumberx( L:int , idx:int ,isnum:int ):Number
        {
            return Lua.lua_tonumberx( L , idx , isnum );
        }
        
        private function lua_tolstring( L:int , idx:int , len:int ):String
        {
            return Lua.lua_tolstring( L , idx , len );
        }
        
        private function lua_settop( L:int , idx:int ):void
        {
            Lua.lua_settop( L , idx );
        }
        
        public function lua_getglobal( L:int, varname:String ):void
        {
            Lua.lua_getglobal( L, varname );
        }
        public function lua_callk( L:int, nargs:int , nresults:int , ctx:int , k:Function ):void
        {
            Lua.lua_callk( L, nargs , nresults, ctx , k );
        }
        public function luaL_newstate():int
        {
            return Lua.luaL_newstate();
        }
        public function lua_atpanic( L:int , panicf:Function ):void
        {
            Lua.lua_atpanic( L , panicf );
        }
        public function luaL_openlibs( L:int ):void
        {
            Lua.luaL_openlibs( L );
        }
        public function luaL_loadstring( L:int , s:String ):int
        {
            return Lua.luaL_loadstring( L , s );
        }
        public function push_flashref( L:int ):int
        {
            return Lua.push_flashref( L );
        }
        public function get __lua_objrefs():Dictionary
        {
            return sample.lua.__lua_objrefs;
        }
        public function set __lua_objrefs( value:Dictionary ):void
        {
            sample.lua.__lua_objrefs = value;
        }
        public function luaL_checklstring( L:int , numArg:int, l:int ):String
        {
            return Lua.luaL_checklstring( L , numArg , l );
        }
        public function lua_close( L:int ):void
        {
            Lua.lua_close( L );
        }
        public function lua_pcallk( L:int , nargs:int , nresults:int , errfunc:int ,ctx:int , k:Function ):int
        {
            return Lua.lua_pcallk( L , nargs, nresults , errfunc , ctx , k  );
        }
        public function lua_pushinteger( L:int , n:* ):void
        {
            Lua.lua_pushinteger( L ,n );
        }
        public function get LUA_MULTRET():int
        {
            return Lua.LUA_MULTRET;
        }
        
        public function output(s:String):void
        {
            trace( "[LuaMain] " + s );
        }
        
        /**
         * The PlayerKernel implementation will use this function to handle
         * C IO write requests to the file "/dev/tty" (e.g. output from
         * printf will pass through this function). See the ISpecialFile
         * documentation for more information about the arguments and return value.
         */
        public function write(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
        {
            var str:String = CModule.readString(bufPtr, nbyte);
            output(str);
            return nbyte;
        }
        
        /**
         * The PlayerKernel implementation will use this function to handle
         * C IO read requests to the file "/dev/tty" (e.g. reads from stdin
         * will expect this function to provide the data). See the ISpecialFile
         * documentation for more information about the arguments and return value.
         */
        public function read(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
        {
            return 0;
        }
        
        /**
         * The PlayerKernel implementation will use this function to handle
         * C fcntl requests to the file "/dev/tty" 
         * See the ISpecialFile documentation for more information about the
         * arguments and return value.
         */
        public function fcntl(fd:int, com:int, data:int, errnoPtr:int):int
        {
            return 0;
        }
        
        /**
         * The PlayerKernel implementation will use this function to handle
         * C ioctl requests to the file "/dev/tty" 
         * See the ISpecialFile documentation for more information about the
         * arguments and return value.
         */
        public function ioctl(fd:int, com:int, data:int, errnoPtr:int):int
        {
            return 0;
        }
    }
}