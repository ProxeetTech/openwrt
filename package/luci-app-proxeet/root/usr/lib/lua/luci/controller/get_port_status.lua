 
module("luci.controller.get_port_status", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_port_status"}, call("get_port_status"), "Ethernet port status", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function get_port_status()

    local post_data = http.formvalue("data") or "no data"

    local port_state = { port_status = "err", code = 500 }

    log_to_syslog("Port in request: " .. post_data)
    
    if post_data ~= "no data" then
        
        local interface = post_data
        local path = "/sys/class/net/" .. interface .. "/operstate"


        local file = io.open(path, "r")
        if file then
            local state = file:read("*line")
            file:close()

            if state == "up" then

                port_state = { port_status = "up", code = 200 }

            else
                port_state = { port_status = "down", code = 200 }
            end
        else
            log_to_syslog("GET Port state error: " .. interface)
        end
    
    end

     http.prepare_content("application/json")
     http.write(json.encode(port_state))

end    