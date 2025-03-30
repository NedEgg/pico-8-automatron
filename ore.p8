function spawnOre(sx, sy, sp)
    local ore = {}
    ore.x = sx
    ore.y = sy
    ore.life = 30
    ore.sprite = sp
    ore.smelted = false
    ore.price = 0
    ore.moveDir = nil
    ore.moveTimer = 0  -- Controls movement speed (higher = slower)
    ore.moveDelay = 10 -- Adjust this for speed (e.g., 10 = ~half speed)

    -- Set base price based on sprite type
    if sp == 32 then      -- Raw ore
        ore.price = 2
    elseif sp == 33 then  -- Smelted ore
        ore.price = 5
        ore.smelted = true
    elseif sp == 34 then  -- Wood
        ore.price = 3     -- Wood is worth more than raw ore but less than smelted
    elseif sp >= 35 then  -- Furniture (sprites 35+)
        ore.price = 20
        ore.smelted = true  -- Treat furniture as "smelted" for any smelting checks
    end

    ore.update = function(self)
        -- Smelter interaction (wood and furniture can't be smelted)
        for t in all(stations) do
            if distance(self.x, self.y, t.x, t.y) <= 1 then
                if t.flag == 4 and self.sprite == 32 then -- Only raw ore can be smelted
                    self.smelted = true
                    self.sprite = 33
                    self.price = 5  -- Update price after smelting
                    sfx(rnd(flr(2)+1))
                elseif t.flag == 5 then -- Seller
                    balance += self.price
                    del(ores, self)
                    sfx(0)
                    return
                end
            end
        end

        -- Movement logic (slower)
        if self.moveTimer <= 0 then
            -- Check for track at current position
            for t in all(stations) do
                if t.flag == 1 and t.x == self.x and t.y == self.y then
                    self.moveDir = t.r
                    -- Move in the track's direction
                    if self.moveDir == 0 then self.y -= 1 -- Up
                    elseif self.moveDir == 1 then self.y += 1 -- Down
                    elseif self.moveDir == 2 then self.x -= 1 -- Left
                    elseif self.moveDir == 3 then self.x += 1 -- Right
                    end
                    self.moveTimer = self.moveDelay -- Reset timer
                    break
                end
            end
        else
            self.moveTimer -= 1 -- Count down
        end

        -- Boundary/life checks (unchanged)
        if self.x == 10 or self.x == 0 or self.y == 0 or self.y == 15 then
            del(ores, self)
            return
        end
        if tick == 30 then
            self.life -= 1
            if self.life < 0 then del(ores, self) end
        end
    end

    ore.draw = function(self)
        spr(self.sprite, self.x * tilesize, self.y * tilesize)
    end

    add(ores, ore)
end