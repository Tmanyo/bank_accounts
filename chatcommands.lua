accounts = read_account()

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
