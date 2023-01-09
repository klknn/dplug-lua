/// Lua binding module.
module dplug.lua;

import dplug.core.nogc;
import dplug.gui.context;
import dplug.gui.element;
import dplug.lua.luasupport;
// import dplug.wren;
import bindbc.lua;

enum LUA_OK = 0;

/// Lua C API playground.
version (unittest) {
  extern (C) nothrow
  int test_add(lua_State* L) {
    if (lua_gettop(L) < 2) return luaL_error(L, "error at " ~ __FUNCTION__);
    lua_Number v1 = lua_tonumber(L, 1);
    lua_Number v2 = lua_tonumber(L, 2);
    lua_pop(L,2);
    lua_pushnumber(L,v1 + v2);
    return 1;
  }
}

unittest {
  lua_State* L;
  int result;

  L = luaL_newstate();
  assert(L !is null, "luaL_newstate() error");
  luaL_openlibs(L);

  lua_pushcfunction(L, &test_add);
  lua_setglobal(L, "test_add");

  result = luaL_loadfile(L, "test/add.lua");
  assert(result == LUA_OK, "luaL_loadfile() error");

  result = lua_pcall(L, 0, LUA_MULTRET, 0);
  assert(result == LUA_OK, "lua_pcall() error");
  assert(lua_gettop(L) > 0);
  assert(lua_tonumber(L, -1) == 4);
  lua_pop(L, 1);
  lua_close(L);
}

void enableLuaSupport() {

}
