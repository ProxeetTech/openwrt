module("luci.controller.get_iface_list", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_iface_list"}, call("get_iface_list"), "get interfaces list", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function get_iface_list()
    local iface_list = {}

    
    local handle = io.popen("ip addr")
    local result = handle:read("*a")
    handle:close()

    
    for line in result:gmatch("[^\n]+") do
        
        --log_to_syslog("Line: " .. line)

        local iface_number, iface_name = line:match("^(%d+):%s*(%S+):")
                           
        
        if iface_name then
            --log_to_syslog("Found iface_name: " .. iface_name)
            
            if iface_name:match("^eth(%d+)$") then
                local iface_number = tonumber(iface_name:match("eth(%d+)"))  
                if iface_number >= 1 and iface_number < 17 then  
                    local iface_info = {}
                    iface_info.name = iface_name
                    table.insert(iface_list, iface_info)
                    --log_to_syslog("Added iface: " .. iface_info.name)
                end
            end
        else
    
        end
    end

    
    http.prepare_content("application/json")
    http.write(json.encode(iface_list))
end
