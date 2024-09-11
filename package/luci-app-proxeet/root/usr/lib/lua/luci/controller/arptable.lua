module("luci.controller.arptable", package.seeall)

function index()

    entry({"admin", "pxrouter"}, firstchild(), _("Diagnostics"), 10).dependent = false
    entry({"admin", "pxrouter", "arptable"}, call("get_arp_table"), _("ARP table"), 10)

end

function get_arp_table()

    local theme_utils = require("luci.utils.theme_utils")

    local arp_entries = {}
    local page_header = "ARP Table"
    local api_endpoint = "/cgi-bin/luci/pxrouter/get_arp_table"
    local index_css = "/luci-static/resources/view/pxrouter/index.css"
    local tables_js = "/luci-static/resources/view/pxrouter/tables.js"

    local table_headers_names = { "id", "ip", "hw_type", "flags", "hw_address", "mask", "device" }
    local json = require("luci.jsonc")

    local theme, bg_color, btn_text_color, table_header_color, btn_bg_color = theme_utils.theme_set()





    

    luci.http.context.template_header = { resource = "/luci-static/resources/view/pxrouter" }
    luci.template.render("pxrouter/arptable", {
        arp_entries = arp_entries,
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
