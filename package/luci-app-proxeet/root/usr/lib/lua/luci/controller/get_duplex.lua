module("luci.controller.get_duplex", package.seeall)

local json = require("cjson")
local http = require("luci.http")
--local socket = require("socket")

function index()
    entry({"pxrouter", "get_duplex"}, call("get_duplex"), "get duplex", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function get_port_duplex(post_data)
    local handle = io.popen("ethtool " .. post_data)
    local result = handle:read("*a")
    handle:close()

    log_to_syslog("PORT DUPLEX __________________: " .. json.encode(result))
    local port_state = result:match("Duplex:%s*(%S+)")
    log_to_syslog("PORT DUPLEX __________________: " .. port_state)

    return port_state or "Unknown!"
end

function get_duplex()
   
    local post_data = http.formvalue("port") or "no data"
   
    local response = {}

    if post_data ~= "no data" then
        local count_map = {} 

        for i = 1, 5 do
            local duplex_state = get_port_duplex(post_data)
            table.insert(count_map, duplex_state)

            
            count_map[duplex_state] = (count_map[duplex_state] or 0) + 1
            os.execute("sleep 1")
            --socket.sleep(0.5)
        end

        
        for value, count in pairs(count_map) do
            if count == 5 then
                response = { duplex = value }
                break
            end
        end

        
        if not response.duplex then
            response = { duplex = "flapping" }
        end
    else
        response = {
            status = "err",
            code = 500
        }
    end

    http.prepare_content("application/json")
    http.write(json.encode(response))
end
