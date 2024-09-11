module("luci.controller.get_arp_table", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_arp_table"}, call("get_arp_table"))
end

function get_arp_table()

    local handle = io.popen("cat /proc/net/arp")
    local result = handle:read("*a")
    handle:close()

    local arp_entries = {}
    local line_number = 0

    for line in result:gmatch("[^\r\n]+") do
        line_number = line_number + 1

        if line_number > 1 then

            local ip,hw_type,flags,hw_address, mask, device = line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
            if ip and hw_type and flags and hw_address and mask and device then

                table.insert(arp_entries,{
                    id = line_number - 1,
                    ip = ip,
                    hw_type = hw_type,
                    flags = flags,
                    hw_address = hw_address,
                    mask = mask,
                    device = device

                })
            end
        end
    end

    http.prepare_content("application/json")
    http.write(json.encode(arp_entries))
end
