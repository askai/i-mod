--[[
LuCI - Lua Configuration Interface

Copyright 2011 RA <ravageralpha@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

local map, section, net = ...
local fs = require "nixio.fs"

local server, port, password, mtu, concurrency, ifname

server = section:taboption("general", Value, "server", translate("VPN Server"))
server.datatype = "host"
server.optional = false

port = section:taboption("general", Value, "port", translate("Port"))
port.datatype = "port"
port.optional = false

password = section:taboption("general", Value, "password", translate("Password"))
password.password = true
password.optional = false

mtu = section:taboption("general", Value, "mtu", translate("MTU"))
mtu.datatype = "uinteger"
mtu.default = "1440"
mtu.placeholder = "1440"

concurrency = section:taboption("general", Value, "concurrency", translate("Concurrency"))
concurrency.datatype = "uinteger"
concurrency.default = "1"
concurrency.placeholder = "1"

ifname = section:taboption("general", Value, "interface", translate("Output Interface"))
ifname.template = "cbi/network_netlist"

clientup = section:taboption("advanced", TextValue, "clientup", "client_up.sh")
clientup.template = "cbi/tvalue"
clientup.rows = 15

function clientup.cfgvalue(self, section)
	return fs.readfile("/etc/shadowvpn/client_up.sh") or ""
end

function clientup.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/shadowvpn/client_up.sh", value)
	end
end

clientdown = section:taboption("advanced", TextValue, "clientdown", "client_down.sh")
clientdown.template = "cbi/tvalue"
clientdown.rows = 15

function clientdown.cfgvalue(self, section)
	return fs.readfile("/etc/shadowvpn/client_down.sh") or ""
end

function clientdown.write(self, section, value)
	if value then
		value = value:gsub("\r\n?", "\n")
		fs.writefile("/etc/shadowvpn/client_down.sh", value)
	end
end
