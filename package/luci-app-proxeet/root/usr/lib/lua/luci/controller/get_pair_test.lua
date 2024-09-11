module("luci.controller.get_pair_test", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_pair_test"}, call("get_pair_test"), "get pair test", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function get_pair_test()

    local post_data = http.formvalue("port") or "no data"

    local response = {}

    log_to_syslog("UCI output: " .. post_data)

    if post_data ~= "no data" then
        
       

        response = {
            status = "ok",
            code = 200
        }
    else 
        response = {
            status = "err",
            code = 500
        }
    end

    http.prepare_content("application/json")
    http.write(json.encode(response))
end

