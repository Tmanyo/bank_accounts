-- Create privilege that allows players to use teller's computer.
minetest.register_privilege("bank_teller", {
     	description = "Qualified Bank Teller",
})

no_addition = {}
pos_data = {}
remove_currency = {}
teller_ones = {}
teller_fives = {}
teller_tens = {}
-- Register teller's computer node.
minetest.register_node("bank_accounts:teller_computer", {
     	description = "Bank Teller's Computer",
     	drawtype = "mesh",
     	mesh = "computer.obj",
     	paramtype = "light",
     	paramtype2 = "facedir",
     	light_source = 5,
     	tiles = {
          	{name="computer.png"},{name="computer_screen.png"},
     	},
     	groups = {cracky=3, crumbly=3, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
     	selection_box = {
          	type = "fixed",
          	fixed = {
               		{-.5,-.5,-.5,.5,.4,.2},
          	},
     	},
     	collision_box = {
          	type = "fixed",
          	fixed = {
               		{-.5,-.5,-.5,.5,.4,.2},
          	},
     	},
     	on_construct = function(pos)
          	local meta = minetest.get_meta(pos)
          	local inv = meta:get_inventory()
          	inv:set_size("ones", 1)
          	inv:set_size("fives", 1)
          	inv:set_size("tens", 1)
     	end,
     	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
          	pos_data = pos
          	if player:get_player_control().aux1 then
               		if minetest.check_player_privs(player:get_player_name(), {server=true}) == true then
                    		minetest.show_formspec(player:get_player_name(), "bank_accounts:admin_teller",
                         		"size[8,4]" ..
                         		"field[.5,.5;4,1;search;Search:;]" ..
                         		"button[4.5,.22;2,1;search_button;Search]" ..
                         		"label[.5,1.25;Player:                                    Seized:]")
               		else
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Insufficient privs.")
               		end
          	else
               		if minetest.check_player_privs(player:get_player_name(), {bank_teller=true}) == true then
                    		local meta = minetest.get_meta(pos)
                    		local list_name = "nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z
                    		minetest.show_formspec(player:get_player_name(), "bank_accounts:teller",
                         		"size[8,8]" ..
                         		"label[0,-.25;Deposit:]" ..
                         		"list[" .. list_name .. ";ones;0,.25;1,1]" ..
                         		"list[" .. list_name .. ";fives;1,.25;1,1]" ..
                         		"list[" .. list_name .. ";tens;2,.25;1,1]" ..
                         		"label[.5,1;$1]" ..
                         		"label[1.5,1;$5]" ..
                         		"label[2.5,1;$10]" ..
                         		"field[4,.5;4,1;playername;Player:;]" ..
                         		"field[.3,2.25;4,1;withdrawal;Withdraw:;]" ..
                         		"field[.3,3.25;4,1;credit_debt;Credit Payment:;]" ..
                         		"button[5,1;2,1;stats;View Account Stats]" ..
                         		"button[5,2;2,1;forgive;Forgive Credit]" ..
                         		"button[5,3;2,1;wipe;Wipe Account]" ..
                         		"button[5,4;2,1;reset_pin;Reset PIN]" ..
                         		"button[.5,5.5;2,1;refresh;Refresh]" ..
                         		"button_exit[3,5.5;2,1;exit;Cancel]" ..
                         		"button_exit[5,5.5;2,1;enter;Enter]" ..
                         		"list[current_player;main;0,7;8,1]")
               		end
          	end
     	end,
     	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
          	return count
     	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
          	local meta = minetest.get_meta(pos)
          	local inv = meta:get_inventory()
          	if listname == "ones" then
               		if stack:get_name() ~= "currency:minegeld" then
                    		local inventory = player:get_inventory()
                    		inventory:add_item("main", {name=stack:get_name(), count=stack:get_count()})
                    		remove_currency = 1
               		end
          	end
          	if listname == "fives" then
               		if stack:get_name() ~= "currency:minegeld_5" then
                    		local inventory = player:get_inventory()
                    		inventory:add_item("main", {name=stack:get_name(), count=stack:get_count()})
                    		remove_currency = 1
               		end
          	end
          	if listname == "tens" then
               		if stack:get_name() ~= "currency:minegeld_10" then
                    		local inventory = player:get_inventory()
                    		inventory:add_item("main", {name=stack:get_name(), count=stack:get_count()})
                    		remove_currency = 1
               		end
          	end
          	return 30000
     	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
          	return stack:get_count()
     	end,
     	on_metadata_inventory_put = function(pos, listname, index, stack, player)
          	local meta = minetest.get_meta(pos)
          	local inv = meta:get_inventory()
          	if listname == "ones" then
               		if remove_currency == 1 then
                    		inv:set_stack("ones", index, nil)
                    		remove_currency = 0
               		end
		        if stack:is_empty() == true then
                    		teller_ones = 0
               		elseif stack:get_count() == 1 then
		        	local inventory = player:get_inventory()
                    		inventory:add_item("main", {name=stack:get_name(), count=1})
                    		inv:set_stack("ones", index, nil)
                    		minetest.chat_send_player(player:get_player_name(), "[ATM] Must insert more than one Minegeld Note.")
               		else
                    		teller_ones = stack:get_count()
               		end
          	end
          	if listname == "fives" then
               		if remove_currency == 1 then
                    		inv:set_stack("fives", index, nil)
                    		remove_currency = 0
               		end
               		if stack:is_empty() == true then
                    		teller_fives = 0
               		elseif stack:get_count() == 1 then
                    		local inventory = player:get_inventory()
                    		inventory:add_item("main", {name=stack:get_name(), count=1})
                    		inv:set_stack("fives", index, nil)
                    		minetest.chat_send_player(player:get_player_name(), "[ATM] Must insert more than one Minegeld Note.")
               		else
                    		teller_fives = stack:get_count() * 5
               		end
          	end
          	if listname == "tens" then
               		if remove_currency == 1 then
                    		inv:set_stack("tens", index, nil)
                    		remove_currency = 0
               		end
               		if stack:is_empty() == true then
                    		teller_tens = 0
               		elseif stack:get_count() == 1 then
                    		local inventory = player:get_inventory()
                    		inventory:add_item("main", {name=stack:get_name(), count=1})
                    		inv:set_stack("tens", index, nil)
                    		minetest.chat_send_player(player:get_player_name(), "[ATM] Must insert more than one Minegeld Note.")
               		else
                    		teller_tens = stack:get_count() * 10
	                end
          	end
     	end,
})

function total_deposit(playername)
     	if tonumber(teller_ones) == nil then
          	teller_ones = 0
     	end
     	if tonumber(teller_fives) == nil then
          	teller_fives = 0
     	end
     	if tonumber(teller_tens) == nil then
          	teller_tens = 0
	end
     	accounts.balance[playername] = accounts.balance[playername] + tonumber(teller_ones) + tonumber(teller_fives) + tonumber(teller_tens)
     	if teller_ones and teller_fives and teller_tens == 0 then
          	no_addition = 1
     	end
end

function clear_currency(listname, index, stack, pos)
     	local pos = pos_data
     	local meta = minetest.get_meta(pos)
     	local inv = meta:get_inventory()
     	teller_ones = 0
     	inv:set_stack("ones", 1, nil)
     	teller_fives = 0
     	inv:set_stack("fives", 1, nil)
     	teller_tens = 0
     	inv:set_stack("tens", 1, nil)
end

accounts = read_account()

function admin_form_no_results(player)
     	minetest.show_formspec(player:get_player_name(), "bank_accounts:admin_teller",
          	"size[8,4]" ..
          	"field[.5,.5;4,1;search;Search:;]" ..
          	"button[4.5,.22;2,1;search_button;Search]" ..
          	"label[.5,1.25;Player:                                    Seized:]" ..
          	"label[3.5,1.75;No Results!]")
end

function admin_form_results(player, search_name, seized)
     	minetest.show_formspec(player:get_player_name(), "bank_accounts:admin_teller",
          	"size[8,4]" ..
          	"field[.5,.5;4,1;search;Search:;]" ..
          	"button[4.5,.22;2,1;search_button;Search]" ..
          	"label[.5,1.25;Player:                                    Seized:]" ..
          	"label[.5,1.75;" .. search_name .. "                                    " .. seized .. "]")
end

function stats_form(player, playername)
     	local pos = pos_data
     	local meta = minetest.get_meta(pos)
     	local list_name = "nodemeta:" .. pos.x .. "," .. pos.y .. "," .. pos.z
     	minetest.show_formspec(player:get_player_name(), "bank_accounts:teller",
          	"size[8,8]" ..
          	"label[0,-.25;Deposit:]" ..
          	"list[" .. list_name .. ";ones;0,.25;1,1]" ..
          	"list[" .. list_name .. ";fives;1,.25;1,1]" ..
          	"list[" .. list_name .. ";tens;2,.25;1,1]" ..
          	"label[.5,1;$1]" ..
          	"label[1.5,1;$5]" ..
          	"label[2.5,1;$10]" ..
          	"field[4,.5;4,1;playername;Player:;" .. playername .. "]" ..
          	"field[.3,2.25;4,1;withdrawal;Withdraw:;]" ..
          	"field[.3,3.25;4,1;credit_debt;Credit Payment:;]" ..
          	"label[.5,4;Balance: $" .. accounts.balance[playername] .. "]" ..
          	"label[.5,4.25;Credit Debt: $" .. accounts.credit[playername] .. "]" ..
          	"button[5,1;2,1;stats;View Account Stats]" ..
          	"button[5,2;2,1;forgive;Forgive Credit]" ..
          	"button[5,3;2,1;wipe;Wipe Account]" ..
          	"button[5,4;2,1;reset_pin;Reset PIN]" ..
          	"button[.5,5.5;2,1;refresh;Refresh]" ..
          	"button_exit[3,5.5;2,1;exit;Cancel]" ..
          	"button_exit[5,5.5;2,1;enter;Enter]" ..
          	"list[current_player;main;0,7;8,1]")
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
     	if formname == "bank_accounts:admin_teller" then
          	if fields.search_button then
               		if fields.search ~= "" then
                    		local search_name = fields.search
                    		if not accounts.balance[search_name] then
                         		admin_form_no_results(player)
                    		else
                         		local seized = {}
                         		if minetest.check_player_privs(search_name, {seized=true}) then
                              			seized = "No"
                         		else
                              			seized = "Yes"
                         		end
                         		admin_form_results(player, search_name, seized)
                    		end
               		else
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] No player name entered.")
               		end
          	end
     	end
     	local playername = fields.playername
     	if formname == "bank_accounts:teller" then
          	if fields.enter then
               		-- Check if player name was inputted.
               		if fields.playername == "" then
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Must enter player name.")
               		else
                    		-- Check if player has an account.
                    		if accounts.balance[playername] == nil then
                         		minetest.chat_send_player(player:get_player_name(), "[Bank] Invalid player name entered.")
                         		return false
                    		else
                         		-- Deposit money.
                         		total_deposit(playername)
                         		clear_currency(listname, index, stack, pos)
                         		save_account()
                         		-- Withdrawal money.
                         		if fields.withdrawal ~= ""  then
                              			if string.match(fields.withdrawal, "%a+") or string.match(fields.withdrawal, "%p+") then
                                   			minetest.chat_send_player(player:get_player_name(), "[Bank] Withdrawal field has an invalid input.")
                              			else
                                   			if tonumber(fields.withdrawal) > accounts.balance[playername] then
                                        			minetest.chat_send_player(player:get_player_name(), "[Bank] Player has insufficient funds.")
                                   			else
                                        			total_tens = math.floor(tonumber(fields.withdrawal) / 10)
                                        			total_fives = math.floor((tonumber(fields.withdrawal) - (total_tens * 10)) / 5)
                                        			total_ones = tonumber(fields.withdrawal) - ((total_fives * 5) + (total_tens * 10))
                                        			local inv = player:get_inventory()
                                        			inv:add_item("main", {name="currency:minegeld_10", count=total_tens})
                                        			inv:add_item("main", {name="currency:minegeld_5", count=total_fives})
                                        			inv:add_item("main", {name="currency:minegeld", count=total_ones})
                                        			accounts.balance[playername] = accounts.balance[playername] - tonumber(fields.withdrawal)
                                        			save_account()
                                        			minetest.chat_send_player(player:get_player_name(), "[Bank] Funds successfully withdrawn!")
                                   			end
                              			end
                         		end
                         		-- Pay off credit debt.
                         		if fields.credit_debt ~= "" then
                              			if string.match(fields.credit_debt, "%a+") or string.match(fields.credit_debt, "%p+") then
                                   			minetest.chat_send_player(player:get_player_name(), "[Bank] Credit Payment field has an invalid input.")
                              			else
                                   			if tonumber(fields.credit_debt) > accounts.credit[playername] then
                                        			minetest.chat_send_player(player:get_player_name(), "[Bank] Player does not have this much credit.")
                                   			else
                                        			if tonumber(fields.credit_debt) > accounts.balance[playername] then
                                             				minetest.chat_send_player(player:get_player_name(), "[Bank] Player has insufficient funds.")
                                        			else
                                             				minetest.chat_send_player(player:get_player_name(), "[Bank] Debt payment successfully paid!")
                                             				accounts.balance[playername] = accounts.balance[playername] - tonumber(fields.credit_debt)
                                             				accounts.credit[playername] = accounts.credit[playername] - tonumber(fields.credit_debt)
                                             				save_account()
                                        			end
                                   			end
                              			end
                         		end
                    		end
               		end
          	end
          	-- Forgive credit debt.
          	if fields.forgive then
               		if fields.playername == "" then
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Must enter player name.")
               		else
                    		if accounts.credit[playername] == 0 then
                         		minetest.chat_send_player(player:get_player_name(), "[Bank] Player has no credit debt.")
                    		else
                         		accounts.credit[playername] = 0
                         		save_account()
                         		minetest.chat_send_player(player:get_player_name(), "[Bank] Player's debt has been forgiven!")
                    		end
               		end
          	end
          	-- Set a player's account balance to 0.
          	if fields.wipe then
               		if fields.playername == "" then
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Must enter player name.")
               		else
                    		if accounts.balance[playername] == 0 then
                         		minetest.chat_send_player(player:get_player_name(), "[Bank] Player has no funds.")
                    		else
                         		accounts.balance[playername] = 0
                         		save_account()
                         		minetest.chat_send_player(player:get_player_name(), "[Bank] Account successfully wiped!")
                    		end
               		end
          	end
          	-- Reset a player's PIN.
          	if fields.reset_pin then
               		if fields.playername == "" then
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Must enter player name.")
               		else
                    		accounts.pin[playername] = 0
                    		save_account()
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Player's pin successfully reset!")
               		end
          	end
          	-- Rrefresh account stats.
          	if fields.refresh then
               		if not accounts.balance[playername] then
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Invalid player name entered.")
               		else
                    		stats_form(player, playername)
               		end
          	end
          	-- Show player's accounts specifications.
          	if fields.stats then
               		if not accounts.balance[playername] then
                    		minetest.chat_send_player(player:get_player_name(), "[Bank] Invalid player name entered.")
               		else
                    		stats_form(player, playername)
               		end
          	end
     	end
end)
