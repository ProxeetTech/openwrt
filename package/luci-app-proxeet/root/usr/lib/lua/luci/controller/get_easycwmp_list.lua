module("luci.controller.get_easycwmp_list", package.seeall) 

local json = require("cjson")
local http = require("luci.http")
 

function index()
    entry({"pxrouter", "get_easycwmp_list"}, call("get_easycwmp_list"))
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function get_easycwmp_list()

    local handle = io.popen("uci show easycwmp")
    --local handle = io.popen("uci show")
    local result = handle:read("*a")
    handle:close()

    
    log_to_syslog("UCI output: " .. result)

    local cwmp_entries = {}
    local line_number = 0 

    for line in result:gmatch("[^\r\n]+") do
        local key, value = line:match("(%S+)%s*=%s*(.+)")
        if key and value then
            local entry_name = key:match("easycwmp%.(.*)")
            if entry_name then
                cwmp_entries[entry_name] = value
            
            end
        end
    end

    http.prepare_content("application/json")
    http.write(json.encode(cwmp_entries))
end