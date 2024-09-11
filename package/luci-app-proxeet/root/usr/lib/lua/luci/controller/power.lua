module("luci.controller.power", package.seeall)

function index()
    -- Добавляем новый пункт меню в корень меню LuCI
    entry({"admin", "Power"}, firstchild(), _("Power configuration"), 10)

    -- Добавляем подпункт к новому меню
    entry({"admin", "power", "reboot"}, template("power/reboot"), _("Reboot"), 1)
end

