local M = {}

function M.theme_set()

    local json = require("luci.jsonc")
    local config_dump = json.stringify(luci.config.main or {})
    local cmd = string.format('logger "Конфигурация: %s"', config_dump)
    os.execute(cmd)

    local theme = luci and luci.config and luci.config.main and luci.config.main.mediaurlbase or "default"
    
    theme = theme:match("([^/]+)$") or theme

    
    local bg_color = "none"
    local btn_text_color  = "none"
    local btn_bg_color  = "none"
    local table_header_color = "none"

    

    if string.match(string.lower(theme), "dark") then
        
        cmd = string.format('logger "%s"', "Тема тёмная")
        os.execute(cmd)

        bg_color = "#1e1e1e"
        btn_text_color = "--proxeet-white"
        table_header_color = "--px-table-header-dark" 
    
    elseif string.match(string.lower(theme), "argon") then
        
        cmd = string.format('logger "%s"', "argon theme")
        os.execute(cmd)

        bg_color = "#1e1e1e"
        btn_text_color = "--proxeet-white"
        btn_bg_color = "--px-argon-btn"
        table_header_color = "--px-table-header-dark" 

    elseif string.match(string.lower(theme), "bootstrap") and not string.find(string.lower(theme), "light") then       
    
        cmd = string.format('logger "%s"', "Тема тёмная")
        os.execute(cmd)

        bg_color = "#1e1e1e"
        btn_text_color = "--proxeet-white"
        table_header_color = "--px-table-header-dark" 

    else
        
        cmd = string.format('logger "%s"', "Тема светлая")
        os.execute(cmd)
        
        bg_color = "#ffffff"
        btn_text_color = "--proxeet-blue"
        table_header_color = "--px-table-header-light"
    
    end

    return theme, bg_color, btn_text_color, table_header_color , btn_bg_color

end

return M
