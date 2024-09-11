module("luci.controller.test_port", package.seeall)

--local json = require("cjson")
local http = require("luci.http")

--local socket = require("socket")
local json = require("cjson")

local function index()
    local result = { speed = "flapping", duplex = "flapping", link_detected = "no" }

    local speed = { attempt = 0, value = "Unknown!" }
    local duplex = { attempt = 0, value = "Unknown!" }
    local link =  { attempt = 0, value = "no" }

    local speed_err = false
    local duplex_err = false
    local link_err = false

    local n = 5  
    local step = 1  

    for i = 1, n, step do
        speed.attempt = i
        duplex.attempt = i
        link.attempt =i

        speed.value, duplex.value, link.value = test_port()
        
        if speed.value == "Unknown!" then
            speed_err = true
        end

        if duplex.value == "Unknown!" then
            duplex_err = true
        end

        if link.value == "no" then
            link_err = true
        end
    
        os.execute("sleep 1")
        --socket.sleep(0.5)
    end

    
    if not speed_err then
        result.speed = speed.value
    end

    if not duplex_err then
        result.duplex = duplex.value
    end

    if not link_err then
        result.link_detected = link.value
    end

    print(json.encode(result))  
end

function test_port()
    local handle = io.popen("ethtool eth0")
    local result = handle:read("*a")  
    handle:close()

    local speed, duplex, link

    for line in result:gmatch("[^\r\n]+") do
        if line:match("Speed:") then
            speed = line:match("Speed: (%S+)")  
        elseif line:match("Duplex:") then
            duplex = line:match("Duplex: (%S+)")  
        elseif line:match("Link detected:") then
            link = line:match("Link detected: (%S+)")  
        end
    end

    return speed or "Unknown!", duplex or "Unknown!", link or "no"
end

index()
