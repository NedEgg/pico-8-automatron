function placeGenerator(sx, sy)
    local generator = {}
        generator.x = sx
        generator.y = sy
        generator.flag = 2
        generator.cost = 100
        generator.update = function(self)
            if(tick == 60) then
                --spawnOre(self.x + 1, self.y)
                --spawnOre(self.x - 1, self.y)
                spawnOre(self.x, self.y + 1)
                --spawnOre(self.x, self.y - 1)
            end
        end
        generator.draw = function(self)
            spr(48, self.x*tilesize, self.y*tilesize)
        end

    add(stations, generator)
end

function placeTrack(sx, sy, sr)
    --sr is the orientation (0 ⬆️, 1 ⬇️, 2 ⬅️, 3 ➡️)
    local track = {}
        track.x = sx
        track.y = sy
        track.r = sr
        track.flag = 1
        track.sprite = 0
        track.price = 2
        track.update = function(self)
        end
        track.draw = function(self)
            if(tick < 60) self.sprite = 3
            if(tick < 45) self.sprite = 2
            if(tick < 30) self.sprite = 1
            if(tick < 15) self.sprite = 0
            
            if(self.r == 0) then
                spr(11-self.sprite, self.x*tilesize, self.y*tilesize)
            end
            if(self.r == 1) then
                spr(8+self.sprite, self.x*tilesize, self.y*tilesize)
            end
            if(self.r == 2) then
                spr(27-self.sprite, self.x*tilesize, self.y*tilesize)
            end
            if(self.r == 3) then
                spr(24+self.sprite, self.x*tilesize, self.y*tilesize)
            end
        end

    add(stations, track)
end

function placeSmelter(sx, sy)
    local smelter = {}
        smelter.x = sx
        smelter.y = sy
        smelter.flag = 4
        smelter.sprite = 0
        smelter.price = 80
        smelter.update = function(self) end
        smelter.draw = function(self)
            if(tick < 60) self.sprite = 2
            if(tick < 50) self.sprite = 1
            if(tick < 40) self.sprite = 0
            if(tick < 30) self.sprite = 2
            if(tick < 20) self.sprite = 1
            if(tick < 10) self.sprite = 0
            spr(49+self.sprite, self.x * tilesize, self.y * tilesize)
        end

    add(stations, smelter)
end

function placeSeller(sx, sy)
    local seller = {}
        seller.x = sx
        seller.y = sy
        seller.flag = 5
        seller.price = 200
        seller.update = function(self) end
        seller.draw = function(self)
            spr(52, self.x * tilesize, self.y * tilesize)
        end
    
    add(stations, seller)
end