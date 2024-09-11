module("luci.controller.get_link_detected", package.seeall)

local json = require("cjson")
local http = require("luci.http")
--local socket = require("socket")

function index()
    entry({"pxrouter", "get_link_detected"}, call("get_link_detected"), "get link detected", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function get_link(post_data)
    local handle = io.popen("ethtool " .. post_data)
    local result = handle:read("*a")
    handle:close()

    log_to_syslog("PORT LINK DETECTED __________________: " .. json.encode(result))
    local port_state = result:match("Link detected:%s*(%S+)")
    log_to_syslog("PORT LINK DETECTED  __________________: " .. port_state)

    return port_state or "Unknown!"
end

function get_link_detected()

    local post_data = http.formvalue("port") or "no data"

    local response = {}

    --log_to_syslog("UCI output: " .. post_data)

    if post_data ~= "no data" then
        local count_map = {} 

        for i = 1, 5 do
            local state = get_link(post_data)
            table.insert(count_map, state)

            
            count_map[state] = (count_map[state] or 0) + 1
            os.execute("sleep 1")
            --socket.sleep(0.5)
        end

        
        for value, count in pairs(count_map) do
            if count == 5 then
                response = { link_detection = value }
                break
            end
        end

        
        if not response.link_detection then
            response = { link_detection = "flapping" }
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
