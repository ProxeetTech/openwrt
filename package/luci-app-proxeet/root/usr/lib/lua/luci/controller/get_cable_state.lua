module("luci.controller.get_cable_state", package.seeall)

local json = require("cjson")
local http = require("luci.http")

function index()
    entry({"pxrouter", "get_cable_state"}, call("get_cable_state"), "Post cable test", 10)
end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function split(str, sep)
    local result = {}
    for match in (str..sep):gmatch("(.-)"..sep) do
        table.insert(result, match)
    end
    return result
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function get_cable_state()

    local post_data = http.formvalue("port") or "no data"

    local test_result = { status = "err", code = 500 }

    
    if post_data ~= "no data" and post_data:match("eth") then


        local handle = io.popen("ethtool --cable-test " .. post_data)
        local result = handle:read("*a")
        handle:close()



        --log_to_syslog("Port for test: " .. result)

        local pair_a = ""
        local pair_a_len = ""

        local pair_b = ""
        local pair_b_len = ""

        local pair_c = ""
        local pair_c_len = ""

        local pair_d = ""
        local pair_d_len = ""


        local separated_result = split(result, "\n")

        

        for _, one_result in ipairs(separated_result) do

            

            if one_result:match("Pair A") then
                if one_result:match("OK") then
                    pair_a = "OK"
                elseif one_result:match("Open Circuit") then
                    pair_a = "Open Circuit"
                elseif one_result:match("Short within Pair") then
                    pair_a = "short within pair"
                elseif one_result:match("fault length") then
                    pair_a_len = trim(split(one_result,":")[2])
                end
            elseif one_result:match("Pair B") then
                if one_result:match("OK") then
                    pair_b = "OK"
                elseif one_result:match("Open Circuit") then
                    pair_b = "Open Circuit"
                elseif one_result:match("Short within Pair") then
                    pair_b = "short within pair"
                elseif one_result:match("fault length") then
                    pair_b_len = trim(split(one_result,":")[2])
                end
            elseif one_result:match("Pair C") then
                if one_result:match("OK") then
                    pair_c = "OK"
                elseif one_result:match("Open Circuit") then
                    pair_c = "Open Circuit"
                elseif one_result:match("Short within Pair") then
                    pair_c = "short within pair"
                elseif one_result:match("fault length") then
                    pair_c_len = trim(split(one_result,":")[2])
                end
            elseif one_result:match("Pair D") then
                if one_result:match("OK") then
                    pair_d = "OK"
                elseif one_result:match("Open Circuit") then
                    pair_d = "Open Circuit"
                elseif one_result:match("Short within Pair") then
                    pair_d = "short within pair"
                elseif one_result:match("fault length") then
                    pair_d_len = trim(split(one_result,":")[2])
                end
            else
                log_to_syslog("Port test ERR ")
            end
        end



        if pair_a_len == "" and pair_b_len == "" and pair_c_len == "" and pair_d_len == "" then

            test_result = {

                port = post_data,
                pair_a = pair_a,
                pair_b = pair_b,
                pair_c = pair_c,
                pair_d = pair_d,
                status = "ok",
                code = 200
            }
        else

            test_result = {

                port = post_data,
                pair_a = pair_a,
                pair_a_len = pair_a_len,
                pair_b = pair_b,
                pair_b_len = pair_b_len,
                pair_c = pair_c,
                pair_c_len = pair_c_len,
                pair_d = pair_d,
                pair_d_len = pair_d_len,
                status = "ok",
                code = 200
            }

        end

    end

    http.prepare_content("application/json")
    http.write(json.encode(test_result))
end

