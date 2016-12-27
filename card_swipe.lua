price = {}
owner_account = {}
debit = 0
done = 0

--[[local insert_stuff = minetest.create_detached_inventory("insert_stuff", {
     allow_put = function(inv, listname, index, stack, player)
          return 100000
     end,
     allow_take = function(inv, listname, index, stack, player)
          return 100000
     end,
     on_take = function(inv, listname, index, stack, player) end,
     on_put = function(inv, listname, index, stack, player) end,
})]]

--insert_stuff:set_size("main", 8)

minetest.register_node("bank_accounts:card_swipe", {
     description = "Card Swipe",
     drawtype = "mesh",
     mesh = "card_swipe.obj",
     paramtype = "light",
     paramtype2 = "facedir",
     tiles = {"card_reader_col.png"},
     groups = {cracky=3, crumbly=3, oddly_breakable_by_hand=2},
     on_construct = function(pos)
          local meta = minetest.get_meta(pos)
          local inv = meta:get_inventory()
          inv:set_size("items", 8*1)
     end,
     after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
          local owner = placer:get_player_name()
		meta:set_string("infotext", "Card Swipe (owned by "..owner..")")
		meta:set_string("owner",owner)
     end,
     can_dig = function(pos, player)
          local meta = minetest.get_meta(pos)
          if player:get_player_name() == meta:get_string("owner") then
               return true
          else
               return false
          end
     end,
     on_rightclick = function(pos, node, player, itemstack, pointed_thing)
          local meta = minetest.get_meta(pos)
          owner_account = meta:get_string("owner")
          if player:get_player_name() == meta:get_string("owner") then
               local list_name = "nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z
               minetest.show_formspec(player:get_player_name(), "bank_accounts:card_swipe_seller",
                    "size[8,8]" ..
                    "field[1,1;4,1;cash;Dollar Amount:;]" ..
                    "list[" .. list_name ..";items;0,2;8,1]" ..
                    "list[current_player;main;0,3.5;8,4;]" ..
                    "button_exit[3,7.4;2,1;exit;Cancel]" ..
                    "button_exit[5,7.4;2,1;enter;Enter]")
          elseif player:get_player_name() ~= meta:get_string("owner") then
               if tonumber(price) == nil then
                    minetest.chat_send_player(player:get_player_name(), "[Card swipe] No price has been set.")
               else
                    if player:get_wielded_item():to_string() == "bank_accounts:debit_card" then
                         local list_name = "nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z
                         debit = 1
                         minetest.show_formspec(player:get_player_name(), "bank_accounts:card_swipe_buyer",
                              "size[8,8]" ..
                              "label[1,1;Price: $" .. price .. "]" ..
                              "label[.5,2.5;Take your items then click enter.]" ..
                              "list[" .. list_name ..";items;0,1.5;8,1]" ..
                              "list[current_player;main;0,3;8,4;]" ..
                              "button_exit[3,7;2,1;exit;Cancel]" ..
                              "button_exit[5,7;2,1;enter;Enter]")
                    elseif player:get_wielded_item():to_string() == "bank_accounts:credit_card" then
                         local list_name = "nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z
                         minetest.show_formspec(player:get_player_name(), "bank_accounts:card_swipe_buyer",
                              "size[8,8]" ..
                              "label[1,1;Price: $" .. price .. "]" ..
                              "label[.5,2.5;Take your items then click enter.]" ..
                              "list[" .. list_name ..";items;0,1.5;8,1]" ..
                              "list[current_player;main;0,3;8,4;]" ..
                              "button_exit[3,7;2,1;exit;Cancel]" ..
                              "button_exit[5,7;2,1;enter;Enter]")
                    else
                         minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Must use debit or credit card.")
                    end
               end
          end
     end,
     allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
          return count
     end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
          return stack:get_count()
     end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
          if debit == 1 then
               if accounts.balance[player:get_player_name()] < tonumber(price) then
                    local nothing = 0
                    return false and nothing
               else
                    return true
               end
          end
          done = done + 1
          return stack:get_count() or nothing
     end,
})

minetest.register_craft({
     output = "bank_accounts:card_swipe",
     recipe = {
          {"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"},
          {"bank_accounts:credit_card", "default:mese", "bank_accounts:debit_card"},
          {"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"},
     },
})

accounts = read_account()

minetest.register_on_player_receive_fields(function(player, formname, fields)
     if formname == "bank_accounts:card_swipe_seller" then
          if fields.enter then
               if fields.cash == "" or fields.cash == nil then
                    minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Must enter dollar amount.")
               elseif string.match(fields.cash, "%a") or string.match(fields.cash, "%a+") then
                    minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Must enter a number.")
               else
                    price = fields.cash
               end
          end
     end
     if formname == "bank_accounts:card_swipe_buyer" then
          local s = minetest.serialize(owner_account)
          local owner = s:gsub("return", ""):gsub("{", ""):gsub("}", ""):gsub("\"", ""):gsub(" ", "")
          if fields.enter then
               if done == 0 then
                    minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Please re-enter and take your items.")
               else
                    if player:get_wielded_item():to_string() == "bank_accounts:debit_card" then
                         if tonumber(price) > accounts.balance[player:get_player_name()] then
                              minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Card declined.")
                              minetest.chat_send_player(owner, "[Card Swipe] Buyer does not have enough money.")
                         elseif tonumber(price) <= accounts.balance[player:get_player_name()] then
                              minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Items successfully bought.")
                              minetest.chat_send_player(owner, "[Card Swipe] Items successfully bought.")
                              accounts.balance[player:get_player_name()] = accounts.balance[player:get_player_name()] - tonumber(price)
                              accounts.balance[owner] = accounts.balance[owner] + tonumber(price)
                              save_account()
                         end
                    elseif player:get_wielded_item():to_string() == "bank_accounts:credit_card" then
                         minetest.chat_send_player(player:get_player_name(), "[Card Swipe] Items successfully bought.")
                         minetest.chat_send_player(owner, "[Card Swipe] Items successfully bought.")
                         accounts.credit[player:get_player_name()] = accounts.credit[player:get_player_name()] + tonumber(price)
                         accounts.balance[owner] = accounts.balance[owner] + tonumber(price)
                         save_account()
                    end
                    debit = 0
                    done = 0
               end
          end
     end
end)
