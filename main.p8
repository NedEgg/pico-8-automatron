function _init()
    printh("Start", "logs/log.txt", true)
    menuitem(1, "toggle music", function() play_music() end)
    selected = 0
    tilesize = 8
    tick = 0
    time = 0
    balance = 200
    stations = {}
    ores = {}
    placeSmelter(12,7) --for display only
    placeTrack(12,8,0) --for display only
    placeSeller(12,9) --for display only
    placeCrafter(12,11)
    playing = false
    play_music()

    placeSeller(9,14)
end

function _update60()
    cursor:update()
    clock()
    for s in all(stations) do s:update() end
    for o in all(ores) do o:update() end
    
end

function _draw()
    cls(0)
    map(0,0)
    for s in all(stations) do s:draw() end
    for o in all(ores) do o:draw() end
    print("bALANCE:", 90, 10, 9)
    print("$", 90,17,10)
    print(balance, 94,17,10)
    inventory:draw()
    cursor:draw()
    orientation_indicator:draw()
end

function log(text)
    printh(text, "logs/log.txt")
end

function clock()
    tick += 1
    if(tick > 60) then
        tick = 0
        time += 1
    end
end

function flagget(fx, fy)
    return fget(mget(fx/8, fy/8))
end

function distance(x1, y1, x2, y2)
	return abs(x1-x2) + abs(y1-y2)
end

function play_music()
    playing = not playing
    if(playing) music(0)
    if(not playing)music(-1)
end