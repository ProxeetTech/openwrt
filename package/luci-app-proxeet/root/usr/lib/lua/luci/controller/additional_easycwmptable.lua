module("luci.controller.additional_easycwmptable", package.seeall)

function index()
    entry({"admin", "pxrouter"}, firstchild(), _("Diagnostics"), 10).dependent = false
    entry({"admin", "pxrouter", "additional_easycwmptable"}, call("get_easycwmp_table"), nil, 10).hidden = true
end


function get_easycwmp_table()


    luci.http.prepare_content("text/html")

    local theme_utils = require("luci.utils.theme_utils")

    --

    local easycwmp_entries = {}
    local page_header = "Сwmp"
    local api_endpoint = "/cgi-bin/luci/pxrouter/get_easycwmp_list"
    --local api_endpoint = "/luci-static/resources/view/pxrouter/cwmp.json"
    --local api_endpoint = "/luci-static/resources/view/pxrouter/main_cwmp.json"
    local index_css = "/luci-static/resources/view/pxrouter/index.css"
    local tables_js = "/luci-static/resources/view/pxrouter/tables.js"
    local table_headers_names = { "id","parametr","value","btn" }
    --local table_headers_names = { "parametr","value","btn" }
    local json = require("luci.jsonc")

    local theme, bg_color, btn_text_color, table_header_color, btn_bg_color = theme_utils.theme_set()

    


    luci.http.context.template_header = { resource = "/luci-static/resources/view/pxrouter" }
    luci.template.render("pxrouter/easycwmp", {
        easycwmp_entries = easycwmp_entries ,
        page_header = page_header,
        api_endpoint = api_endpoint,
        index_css = index_css,
        tables_js = tables_js,
        theme = theme,
        bg_color = bg_color,
        btn_text_color = btn_text_color,
        table_header_color = table_header_color,
        btn_bg_color = btn_bg_color,
        table_headers_names = json.stringify(table_headers_names)
    })

end    
