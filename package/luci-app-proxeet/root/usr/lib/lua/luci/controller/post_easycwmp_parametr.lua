module("luci.controller.post_easycwmp_parametr", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "post_easycwmp_parametr"}, call("post_easycwmp_parametr"), "Post CWMP Parameters", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end



function post_easycwmp_parametr()
    local post_data = http.formvalue("data") or "no data"

    local cwmp_response = {}

    --local post_data = post_data:gsub("=(%w+)$", "='%1'")
    --local post_data = post_data:gsub("=(.+)$", "='%1'")
    --local post_data = post_data:gsub("=([^']+)$", "='%1'")
    local post_data = post_data:gsub("=([^=]+)$", "='%1'")




    log_to_syslog("easycwmp API CALL ______________________________________" .. post_data)



    if post_data ~= "no data" then
        
        --os.execute("uci set easycwmp.some_option='" .. post_data .. "'")
        os.execute("uci set easycwmp." .. post_data)
        os.execute("uci commit easycwmp")
        os.execute("/etc/init.d/easycwmpd restart")


        cwmp_response = {
            status = "ok",
            code = 200
        }
    else 
        cwmp_response = {
            status = "err",
            code = 500
        }
    end

    http.prepare_content("application/json")
    http.write(json.encode(cwmp_response))
end

