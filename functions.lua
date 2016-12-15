-- If there isn't a file, make one.
local f, err = io.open(minetest.get_worldpath() .. "/accounts", "r")
if f == nil then
     local f, err = io.open(minetest.get_worldpath() .. "/accounts", "w")
     f:write(minetest.serialize(accounts))
     f:close()
end

-- Saves changes to player's account.
function save_account()
     local data = accounts
     local f, err = io.open(minetest.get_worldpath() .. "/accounts", "w")
     if err then
          return err
     end
     f:write(minetest.serialize(data))
     f:close()
end

-- Reads changes from player's account.
function read_account()
     local f, err = io.open(minetest.get_worldpath() .. "/accounts", "r")
     local data = minetest.deserialize(f:read("*a"))
     f:close()
          return data
end
