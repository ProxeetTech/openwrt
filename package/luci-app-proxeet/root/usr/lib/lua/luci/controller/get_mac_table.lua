module("luci.controller.get_mac_table", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_mac_table"}, call("get_mac_table"))
end

function get_mac_table()
    local handle = io.popen("bridge fdb show")
    local result = handle:read("*a")
    handle:close()

    local mac_entries = {}
    local line_number = 0  -- Счетчик для номера строки

    for line in result:gmatch("[^\r\n]+") do
        line_number = line_number + 1  -- Увеличиваем номер строки

        local mac, dev, iface, perm = line:match("(%S+) dev (%S+) (%S+) (%S+)")
        if mac and dev then
            -- Добавляем поле id в каждый элемент
            table.insert(mac_entries, {
                id = line_number,  -- Номер строки
                mac = mac,
                dev = dev,
                iface = iface,
                perm = perm
            })
        end
    end

    http.prepare_content("application/json")
    http.write(json.encode(mac_entries))
end
