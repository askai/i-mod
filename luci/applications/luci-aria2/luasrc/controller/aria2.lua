--[[
RA-MOD
]]--

module("luci.controller.aria2", package.seeall)

function index()
	
	if not nixio.fs.access("/etc/config/aria2") then
		return
	end

	local page
	page = node("admin", "RA-MOD")
	page.target = firstchild()
	page.title = _("RA-MOD")
	page.order  = 65
	
	page = entry({"admin", "RA-MOD", "aria2"}, cbi("aria2"), _("aria2"), 10)
	page.i18n = "aria2"
	page.dependent = true
end
