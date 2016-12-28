-- Read saved data.
accounts = read_account()

minetest.register_privilege("seized", {
     description = "Account seized.",
     give_to_singleplayer = false,
})

-- Set your PIN.
minetest.register_chatcommand("set_pin", {
     param = "<number>",
     description = "Set pin for bank account.",
     func = function(name, param)
          if param == nil or param == "" then
               minetest.chat_send_player(name, "[Account] No numbers entered.")
          elseif string.match(param, "%d%d%d%d") ~= param then
               minetest.chat_send_player(name, "[Account] Invalid number entered.")
          elseif string.match(param, "%d%d%d%d") then
               minetest.chat_send_player(name, "[Account] Pin successfully set!")
               accounts.pin[name] = param
               local player = minetest.get_player_by_name(name)
               local inv = player:get_inventory()
               inv:add_item("main", {name="bank_accounts:atm_card", count=1})
               save_account()
          end
     end
})

-- If you have server priv, you can set players' account balance.
minetest.register_chatcommand("account_balance", {
     params = "<name> <number>",
     description = "Set a player's account balance.",
     func = function(name, params)
          local s = params
          local playername = s:match("%w+")
          local number = s:match("%d+")
          if not s:match("%d") then
               minetest.chat_send_player(name, "[Bank] No number entered.")
          end
          if minetest.check_player_privs(name, {server=true}) == true then
               if not accounts.balance[playername] then
                    minetest.chat_send_player(name, "[Bank] Invalid name entered.")
               else
                    minetest.chat_send_player(name, "[Bank] Funds successfully set!")
                    accounts.balance[playername] = number
                    save_account()
               end
          end
     end
})

--[[ If you have server priv, you can clear a player's account balance.
     Equal to /account_balance (playername) 0.]]
minetest.register_chatcommand("wipe", {
     param = "<name>",
     description = "Wipe a player's bank account.",
     func = function(name, param)
          if minetest.check_player_privs(name, {server=true}) == true then
               if not accounts.balance[param] then
                    minetest.chat_send_player(name, "[Bank] Invalid name entered.")
               else
                    minetest.chat_send_player(name, "[Bank] Account successfully wiped!")
                    accounts.balance[param] = 0
                    save_account()
               end
          end
     end
})

-- If you have server priv, you can forgive a player's credit debt.
minetest.register_chatcommand("forgive", {
     param = "<name>",
     description = "Forgive a player's credit debt.",
     func = function(name, param)
          if minetest.check_player_privs(name, {server=true}) == true then
               if not accounts.credit[param] then
                    minetest.chat_send_player(name, "[Bank] Invalid name entered.")
               else
                    minetest.chat_send_player(name, "[Bank] " .. param .. "'s credit successfully forgiven!")
                    accounts.credit[param] = 0
                    save_account()
               end
          end
     end
})

-- If you have server priv, you can add funds to an account.
minetest.register_chatcommand("add", {
     params = "<name> <number>",
     description = "Add to a player's account balance.",
     func = function(name, params)
          local s = params
          local playername = s:match("%w+")
          local number = s:match("%d+")
          if not s:match("%d") then
               minetest.chat_send_player(name, "[Bank] No number entered.")
          else
               if minetest.check_player_privs(name, {server=true}) == true then
                    if not accounts.balance[playername] then
                         minetest.chat_send_player(name, "[Bank] Invalid name entered.")
                    else
                         minetest.chat_send_player(name, "[Bank] $" .. number .. " successfully added to " .. playername .. "'s account.")
                         accounts.balance[playername] = accounts.balance[playername] + tonumber(number)
                         save_account()
                    end
               end
          end
     end
})


-- If you have server priv, you can subtract funds from an account.
minetest.register_chatcommand("subtract", {
     params = "<name> <param>",
     description = "Subtract from a player's account balance.",
     func = function(name, params)
          local s = params
          local playername = s:match("%w+")
          local number = s:match("%d+")
          if not s:match("%d") then
               minetest.chat_send_player(name, "[Bank] No number entered.")
          else
               if minetest.check_player_privs(name, {server=true}) == true then
                    if not accounts.balance[playername] then
                         minetest.chat_send_player(name, "[Bank] Invalid name entered.")
                    else
                         minetest.chat_send_player(name, "[Bank] $" .. number .. " successfully subtracted from " .. playername .. "'s account.")
                         accounts.balance[playername] = accounts.balance[playername] - tonumber(number)
                         save_account()
                    end
               end
          end
     end
})

-- If you have server priv, you can seize a player's account.
minetest.register_chatcommand("seize", {
     param = "<name>",
     description = "Seize a player's account.",
     func = function(name, param)
          if minetest.check_player_privs(name, {server=true}) == true then
               if not accounts.balance[param] then
                    minetest.chat_send_player(name, "[Bank] Invalid name entered.")
               else
                    local privs = minetest.get_player_privs(param)
                    privs.seized = true
                    minetest.set_player_privs(param, privs)
                    minetest.chat_send_player(name, "[Bank] Account successfully seized!")
               end
          end
     end
})

-- If you have server priv, you can unseize a player's account.
minetest.register_chatcommand("unseize", {
     param = "<name>",
     description = "Unseize a player's account.",
     func = function(name, param)
          if minetest.check_player_privs(name, {server=true}) == true then
               if not accounts.balance[param] then
                    minetest.chat_send_player(name, "[Bank] Invalid name entered.")
               else
                    local privs = minetest.get_player_privs(param)
                    privs.seized = nil
                    minetest.set_player_privs(param, privs)
                    minetest.chat_send_player(name, "[Bank] Account successfully unseized!")
               end
          end
     end
})
