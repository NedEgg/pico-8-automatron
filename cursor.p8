cursor = {}
    cursor.x = 3
    cursor.y = 3
    cursor.update = function(self)
        if(not btn(🅾️)) then
            if(btnp(⬆️)) then self.y -= 1; R=0 end
            if(btnp(⬇️)) then self.y += 1; R=1 end
            if(btnp(⬅️)) then self.x -= 1; R=2 end
            if(btnp(➡️)) then self.x += 1; R=3 end
        end
        if(self.x < 0) self.x = 0
        if(self.y < 0) self.y = 0
        if(self.x > 10) self.x = 10
        if(self.y > 15) self.y = 15

        if(btn(🅾️)) then
            if(btnp(⬇️) and inventory.selected ~= inventory.max) inventory.selected += 1
            if(btnp(⬆️) and inventory.selected ~= 0) inventory.selected -= 1
        end
        if(btnp(❎) and self.x ~= 10 and self.y ~= 15 and self.x ~= 0 and self.y ~= 0) then
            -- Check if there's already a station at this position
            local canPlace = true
            for s in all(stations) do
                if self.x == s.x and self.y == s.y then
                    canPlace = false
                    break
                end
            end
            
            if canPlace then
                if(inventory.selected == 0 and balance >= inventory.prices[inventory.selected+1]) then
                    placeGenerator(self.x, self.y)
                    balance -= inventory.prices[inventory.selected+1]
                end
                if(inventory.selected == 1 and balance >= inventory.prices[inventory.selected+1]) then
                    placeSmelter(self.x, self.y)
                    balance -= inventory.prices[inventory.selected+1]
                end
                if(inventory.selected == 2 and balance >= inventory.prices[inventory.selected+1]) then
                    placeTrack(self.x, self.y, R)
                    balance -= inventory.prices[inventory.selected+1]
                end
                if(inventory.selected == 3 and balance >= inventory.prices[inventory.selected+1]) then
                    placeSeller(self.x, self.y)
                    balance -= inventory.prices[inventory.selected+1]
                end
                if(inventory.selected == 4 and balance >= inventory.prices[inventory.selected+1]) then
                    placeWoodspawn(self.x, self.y)
                    balance -= inventory.prices[inventory.selected+1]
                end
                if(inventory.selected == 5 and balance >= inventory.prices[inventory.selected+1]) then
                    placeCrafter(self.x, self.y)
                    balance -= inventory.prices[inventory.selected+1]
                end
            end
            
            -- Delete station (selected == 6) doesn't need the position check
            if(inventory.selected == 6) then
                for s in all(stations) do
                    if(self.x == s.x and self.y == s.y) del(stations, s)
                end
            end
        end
    end

    cursor.draw = function(self)
        spr(1, self.x*tilesize, self.y*tilesize)
    end

orientation_indicator = {}
    orientation_indicator.draw = function(self)
        if(R==0) spr(17,cursor.x*tilesize,cursor.y*tilesize)
        if(R==1) spr(17,cursor.x*tilesize,cursor.y*tilesize,1,1,false,true)
        if(R==2) spr(16,cursor.x*tilesize,cursor.y*tilesize,1,1,true)
        if(R==3) spr(16,cursor.x*tilesize,cursor.y*tilesize)
    end

inventory = {}
    inventory.selected = 0
    inventory.max = 6
    inventory.prices = {100, 800, 20, 4000, 3000, 2300, 0}
    inventory.stations = {"ore generator", "smelter", "track", "sell box", "wood generator", "crafter", "eraser"}
    inventory.draw = function(self)
        rect(94,46+(8*self.selected),
             105,57+(8*self.selected),7)
        print("$", 107, 49+(8*self.selected), 10)
        print(self.prices[self.selected+1], 112, 49+(8*self.selected), 10)
        rectfill(14,120,70,128,1)
        rect(13,120,71,129,7)
        print(inventory.stations[self.selected+1],15,122,6)
    end

function deleteStation(sx, sy)
    for s in all(stations) do
        if(s.x == sx and s.y == sy) del(stations, s)
    end
end