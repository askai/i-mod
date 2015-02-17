--[[
LuCI - Lua Configuration Interface - mjpg-streamer support

Script by oldoldstone@gmail.com 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

local fs = require "nixio.fs"

local running=(luci.sys.call("pidof adbyby > /dev/null") == 0)
if running then	
	m = Map("adbyby", translate("adbyby"), translate("adbyby is running"))
else
	m = Map("adbyby", translate("adbyby"), translate("adbyby is not running"))
end

s = m:section(TypedSection, "adbyby", "")
s.anonymous = true

switch = s:option(Flag, "enabled", translate("Enable"))
switch.rmempty = false

forward=s:option(Flag, "forward", translate("Enable autoforward"))
forward.rmempty = false

listen_address = s:option(Value, "listen_address", translate("Listening Address"))
listen_address.datatype = ipaddr
listen_address.optional = false

listen_port = s:option(Value, "listen_port", translate("Listening Port"))
listen_port.datatype = "range(0,65535)"
listen_port.optional = false


enable_remote_http_toggle=s:option(Flag, "enable_remote_http_toggle", translate("Enable Remote Http toggle"))
enable_remote_http_toggle.rmempty = false

buffer_limit= s:option(Value, "buffer_limit", translate("Buffer Limit"))
buffer_limit.optional = false

keep_alive_timeout= s:option(Value, "keep_alive_timeout", translate("Keep Alive Timeout"))
keep_alive_timeout.optional = false

socket_timeout= s:option(Value, "socket_timeout", translate("Socket Timeout"))
socket_timeout.optional = false

debug=s:option(Flag, "debug", translate("Enable Debug"))
debug.enabled="1"
debug.disabled="0"
debug.rmempty = false

log_messages=s:option(Flag, "log_messages", translate("Log Messages"))
log_messages.rmempty = false
log_messages:depends("debug", "1")

rule= s:option(Value, "rule", translate("Update Rules"))
rule.optional = false

s2 = m:section(TypedSection, "_dummy", translate("Extern Rules"),
	translate("Here you can paste extern rules (one per line)"))
s2.addremove = false
s2.anonymous = true
s2.template  = "cbi/tblsection"

function s2.cfgsections()
	return { "_exrules" }
end

exrule = s2:option(TextValue, "_data", "")
exrule.wrap    = "off"
exrule.rows    = 3
exrule.rmempty = false

function exrule.cfgvalue()
	return fs.readfile("/usr/share/adbyby/data/extrules.txt") or ""
end

function exrule.write(self, section, value)
	if value then
		fs.writefile("/usr/share/adbyby/data/extrules.txt", value:gsub("\r\n", "\n"))
	end
end

return m

