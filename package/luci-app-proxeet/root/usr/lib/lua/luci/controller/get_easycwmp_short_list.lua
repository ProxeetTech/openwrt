module("luci.controller.get_easycwmp_short_list", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_easycwmp_short_list"}, call("get_easycwmp_short_list"))
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

-- Список параметров для фильтрации
local filter_params = {
    "@local[0].enable",
    "@acs[0].url",
    "@acs[0].username",
    "@acs[0].password",
    "@acs[0].periodic_enable",
    "@acs[0].periodic_interval",
    "@local[0].port",
    "@local[0].interface"
}

-- Функция для проверки, есть ли параметр в списке фильтрации
local function is_in_filter(param)
    for _, filter in ipairs(filter_params) do
        if param == filter then
            return true
        end
    end
    return false
end

function get_easycwmp_short_list()
    local handle = io.popen("uci show easycwmp")
    local result = handle:read("*a")
    handle:close()

    log_to_syslog("UCI output: " .. result)

    local cwmp_entries = {}

    for line in result:gmatch("[^\r\n]+") do
        local key, value = line:match("(%S+)%s*=%s*(.+)")
        if key and value then
            local entry_name = key:match("easycwmp%.(.*)")
            if entry_name and is_in_filter(entry_name) then
                
                cwmp_entries[entry_name] = value
            end
        end
    end

    http.prepare_content("application/json")
    http.write(json.encode(cwmp_entries))
end
