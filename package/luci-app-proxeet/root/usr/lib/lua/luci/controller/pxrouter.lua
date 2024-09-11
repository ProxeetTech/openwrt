module("luci.controller.pxrouter", package.seeall)

local json = require("cjson")

function index()

    entry({"admin", "pxrouter"}, firstchild(), _("Diagnostics"), 10).dependent = false
    entry({"admin", "pxrouter", "cable_diagnostics"}, call("action_interfaces"), _("Cable diagnostics"), 10)

end

local function log_to_syslog(message)
    os.execute("logger " .. message)
end

function action_interfaces()



    local iface_list = {}
    local interface_list = {}


    --api list 

    local theme_utils = require("luci.utils.theme_utils")
    local theme, bg_color, btn_text_color, table_header_color, btn_bg_color = theme_utils.theme_set()

    local api_endpoin_get_speed  = "/cgi-bin/luci/pxrouter/get_speed"
    local api_endpoin_get_duplex = "/cgi-bin/luci/pxrouter/get_duplex"
    local api_endpoin_get_link_detected = "/cgi-bin/luci/pxrouter/get_link_detected"
    local api_endpoin_get_port_admin_status = "/cgi-bin/luci/pxrouter/get_port_admin_status"
    local api_endpoin_get_pair_test = "/cgi-bin/luci/pxrouter/get_pair_test"
    local api_endpoin_get_get_cable_state = "/cgi-bin/luci/pxrouter/get_cable_state"


    local handle = io.popen("ip addr")
    local result = handle:read("*a")
    handle:close()

    
    for line in result:gmatch("[^\n]+") do
        
        local iface_number, iface_name = line:match("^(%d+):%s*(%S+):")
                           
        
        if iface_name then
          
            
            if iface_name:match("^eth(%d+)$") then
                local iface_number = tonumber(iface_name:match("eth(%d+)"))  
                if iface_number >= 0 and iface_number < 17 then  
                    local iface_info = {}
                    iface_info.name = iface_name
                    table.insert(iface_list, iface_info)
          
                end
            end
        else
    
        end
    end

    table.sort(iface_list, function(a, b)
        
        local num_a = tonumber(a.name:match("%d+"))
        local num_b = tonumber(b.name:match("%d+"))
    
        return num_a < num_b
    end)
 
    for _, iface in ipairs(iface_list) do
        table.insert(interface_list, iface.name)
    end

    luci.http.context.template_header = { resource = "/luci-static/resources/view/pxrouter" }
    luci.template.render("pxrouter/cable_diagnostics", {
        interface_list = interface_list,
        api_endpoin_get_speed = api_endpoin_get_speed,
        api_endpoin_get_duplex = api_endpoin_get_duplex,
        api_endpoin_get_link_detected = api_endpoin_get_link_detected,
        api_endpoin_get_port_admin_status = api_endpoin_get_port_admin_status,
        api_endpoin_get_pair_test = api_endpoin_get_pair_test,
        api_endpoin_get_get_cable_state = api_endpoin_get_get_cable_state,
        iface = iface,
        theme = theme,
        bg_color = bg_color,
        btn_text_color = btn_text_color,
        table_header_color = table_header_color,
        btn_bg_color = btn_bg_color,
        img_dir = "/luci-static/resources/view/pxrouter/img/"
    })
end

