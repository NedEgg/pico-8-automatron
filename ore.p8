function spawnOre(sx, sy)
    local ore = {}
        ore.x = sx
        ore.y = sy
        ore.life = 30
        ore.sprite = 32
        ore.smelted = false
        ore.update = function(self)
            for t in all(stations) do
                if(t.flag == 1 and t.x == self.x and t.y == self.y) then
                    if(t.r == 0 and tick == 10) then self.y -= 1; tick=11 end
                    if(t.r == 1 and tick == 20) then self.y += 1; tick=21 end
                    if(t.r == 2 and tick == 30) then self.x -= 1; tick=31 end
                    if(t.r == 3 and tick == 40) then self.x += 1; tick=41 end
                    --if(tick < 30) log(distance(self.x, self.y, t.x, t.y))
                end
                if(distance(self.x, self.y, t.x, t.y)<=1) then
                    if(t.flag == 4) then
                        ore.smelted = true
                        ore.sprite = 33
                    end
                    if(t.flag == 5) then
                        if(ore.smelted) then
                            balance += 20
                        else
                            balance += 10
                        end
                        del(ores, self)
                    end
                end
            end
            --[[
            if(time%5 == 0) then
                for o in all(ores) do
                    if(self.x == o.x and self.y == o.y) del(ores, o)
                end
            end
            --]]
            if(self.x == 10 or self.x == 0 or self.y == 0 or self.y == 15) del(ores, self)
            if(tick == 30) self.life -= 1
            if(self.life < 0) del(ores, self)
        end
        ore.draw = function(self)
            spr(self.sprite, self.x * tilesize, self.y * tilesize)
        end
    
    add(ores, ore)
end