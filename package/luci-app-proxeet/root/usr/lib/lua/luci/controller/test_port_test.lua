module("luci.controller.test_port_test", package.seeall)

--local socket = require("socket")
local json = require("cjson")

local function index()
    math.randomseed(os.time())  -- Инициализация генератора случайных чисел
    local result = { speed = "flapping", duplex = "flapping", link_detected = "no" }

    local speed = { attempt = 0, value = "Unknown!" }
    local duplex = { attempt = 0, value = "Unknown!" }
    local link =  { attempt = 0, value = "no" }

    local speed_err = false
    local duplex_err = false
    local link_err = false

    local n = 1  
    local step = 1  

    for i = 1, n, step do
        speed.attempt = i
        duplex.attempt = i
        link.attempt = i

        -- Используем тестовую функцию для генерации значений
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

-- Функция для генерации случайных значений
function test_port()
    local speeds = {"1000Mb/s", "100Mb/s", "10Mb/s", "Unknown!"}
    local duplexes = {"Full", "Half", "Unknown!"}
    local links = {"yes", "no"}

    -- Получаем случайные индексы
    local speed = speeds[math.random(#speeds)]
    local duplex = duplexes[math.random(#duplexes)]
    local link = links[math.random(#links)]

    return speed, duplex, link
end

index()
