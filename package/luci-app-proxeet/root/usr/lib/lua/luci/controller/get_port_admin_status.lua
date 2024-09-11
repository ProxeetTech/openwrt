module("luci.controller.get_port_admin_status", package.seeall)

local json = require("cjson")
local http = require("luci.http")
--local socket = require("socket")

function index()
    entry({"pxrouter", "get_port_admin_status"}, call("get_port_admin_status"), "get port admin status", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

--[[ function get_port(post_data)

    local handle = io.popen("ip link show dev " .. post_data)
    local result = handle:read("*a")
    handle:close()


    local port_state = result:match("state (%S+)")  
    
    return port_state or "Unknown"  
end ]]


function get_port(post_data)
   
    local handle = io.popen("ifconfig")
    local result = handle:read("*a")
    handle:close()

   
    local interface_block = result:match(post_data .. "%s.-\n\n")
    
    if not interface_block then
        return "Unknown"  
    end

    
    local port_state = interface_block:match("UP") and "UP" or "DOWN"
    
    return port_state
end

function get_port_admin_status()

    local post_data = http.formvalue("port") or "no data"

    local resp = {}

    local response = {}

    --log_to_syslog("UCI output: " .. post_data)

    if post_data ~= "no data" then
        
        for i = 1 , 5 do
            
            local response = get_port(post_data)
            table.insert(resp, response)
            os.execute("sleep 1")
            --socket.sleep(0.5)

        end
        
        
        local count_up = 0

        for _, status in ipairs(resp) do
            if status == "UP" then
                count_up = count_up + 1
            end
        end

        if count_up == 5 then 


            response = { port_admin_status = "up" }

        else

            response = { port_admin_status = "down" }
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

