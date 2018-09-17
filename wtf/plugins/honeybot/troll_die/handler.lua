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
      die = string.sub(p_value, 1, 8)
      if die == "die(md5(" then
        payload = string.sub(p_value, 9, -4)
        local hash=md5.new()
        hash:update(payload)
        instance:get_action(do_action):act(str.to_hex(hash:digest()))
      end
    end
  end
  instance:get_action(do_action):act("Didn't catch anithing")
  
  
end

return _M