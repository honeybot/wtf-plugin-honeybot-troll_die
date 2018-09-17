local require = require
local tools = require("wtf.core.tools")
local Plugin = require("wtf.core.classes.plugin")

local _M = Plugin:extend()
_M.name = "honeybot.troll_die"

function _M:content(...)
  local ngx = ngx
  local pairs = pairs
  local select = select
  local err = tools.error
  local instance = select(1, ...)
  local string = string
  local die
  local payload
  local md5 = require("resty.nettle.md5")
  local str = require("resty.string")
  
  local do_action = self:get_mandatory_parameter('action')
  if ngx.ctx.post then
    for p_name, p_value in pairs(ngx.ctx.post) do
      local a,b,c = string.match(p_value,"^.*([dD][iI][eE])%((m?d?5?%(?)'?\"?([^)'\"]*).*$")
      if a ~= nil then
        if b == '' then
          payload = c
        else
          local hash=md5.new()
          hash:update(c)
          payload = str.to_hex(hash:digest())
        end
        
        instance:get_action(do_action):act(payload)
      end
    end
  end
  -- instance:get_action(do_action):act("Didn't catch anything")
  
end

return _M