function placeGenerator(sx, sy)
    local generator = {}
        generator.x = sx
        generator.y = sy
        generator.flag = 2
        generator.update = function(self)
            if(tick == 60) then
                --spawnOre(self.x + 1, self.y, 32)
                --spawnOre(self.x - 1, self.y, 32)
                spawnOre(self.x, self.y + 1, 32)
                --spawnOre(self.x, self.y - 1, 32)
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
        seller.update = function(self) end
        seller.draw = function(self)
            spr(52, self.x * tilesize, self.y * tilesize)
        end
    
    add(stations, seller)
end

function placeWoodspawn(sx, sy)
    local woodspawn = {}
        woodspawn.x = sx
        woodspawn.y = sy
        woodspawn.flag = 7
        woodspawn.update = function(self)
            if(tick == 60) then
                spawnOre(self.x, self.y + 1, 34)
            end
        end
        woodspawn.draw = function(self)
            spr(54, self.x*tilesize, self.y*tilesize)
        end

    add(stations, woodspawn)
end

function placeCrafter(sx, sy)
    local crafter = {}
    crafter.x = sx
    crafter.y = sy
    crafter.flag = 6
    crafter.materials = {
        wood = nil,      -- Will store wood piece
        ore = nil,       -- Will store raw ore
        smelted = nil    -- Will store smelted ore
    }
    
    crafter.update = function(self)
        -- Check adjacent tiles for materials (left, right, up, down)
        for o in all(ores) do
            if (o.x == self.x-1 and o.y == self.y) or  -- left
               (o.x == self.x+1 and o.y == self.y) or  -- right
               (o.x == self.x and o.y == self.y-1) or  -- up
               (o.x == self.x and o.y == self.y+1) then  -- down
                
                -- Store materials based on type
                if o.sprite == 34 and not self.materials.wood then  -- Wood
                    self.materials.wood = o
                    del(ores, o)
                elseif o.smelted and not self.materials.smelted then  -- Smelted ore
                    self.materials.smelted = o
                    del(ores, o)
                elseif not o.smelted and not self.materials.ore then  -- Raw ore
                    self.materials.ore = o
                    del(ores, o)
                end
            end
        end
        
        -- Check if we have all required materials
        if self.materials.wood and self.materials.ore and self.materials.smelted then
            -- Create furniture
            spawnOre(self.x, self.y + 1, 35 + flr(rnd(3)))
            log("furniture made")
            
            -- Consume materials
            self.materials.wood = nil
            self.materials.ore = nil
            self.materials.smelted = nil
        end
    end
    
    crafter.draw = function(self)
        spr(55, self.x*tilesize, self.y*tilesize)
        
        -- Draw materials on the crafter (visual feedback)
        if self.materials.wood then
            spr(34, self.x*tilesize-3, self.y*tilesize)  -- Wood on top
        end
        if self.materials.ore then
            spr(32, (self.x*tilesize)+2, (self.y*tilesize)+2)  -- Ore offset
        end
        if self.materials.smelted then
            spr(33, (self.x*tilesize)-2, (self.y*tilesize)-3)  -- Smelted offset
        end
    end

    add(stations, crafter)
end