--[[
------------------------------------------
-- Initialization script, anything that --
-- doesn't belong in the faction script --
-- or the manager will go here, such as --
-- listeners and what not               --
------------------------------------------

-- refernces some stuff that will be used ALL over

-- local mm = get_module_manager()
-- local UniversalLog = mm:get_module_by_name("log")

local draconic_faction = "mixer_brt_uprising";
local sun_cost = 25
local pooled_resource_key = "eternal_ice";
local draconic_faction_cqi  = 0 ;
local grand_spells_effect_bundle_key = {	"wh2_ability_enable_freeze_beam",
                            "wh2_ability_enable_eternal_winter",
                            "wh2_ability_enable_gates_of_avalon"
};
local grand_spells_ability_key = {	"wh2_main_army_abilities_freeze_beam",
                            "wh2_main_army_abilities_eternal_winter",
                            "wh2_main_army_abilities_gates_of_avalon"
};


----------------------
-- Helper Functions --
----------------------

--v function() --> number
local function calculate_post_battle_np()

    local player --: string

    -- enemy faction key
    local enemy_faction --: string

    if cm:pending_battle_cache_faction_is_defender(draconic_faction) then
        player = "defender"
    elseif cm:pending_battle_cache_faction_is_attacker(draconic_faction) then
        player = "attacker"
    else        
        return 0
    end
    -- mm:log("+++post battle_02")
    if not player then
        -- mm:log("POST-BATTLE: Faction not found in battle, despite being cached! Investigate?")
        return 0
    end

    if player == "defender" then
        local this_char_cqi, this_mf_cqi, this_faction = cm:pending_battle_cache_get_attacker(1)
        enemy_faction = this_faction
    elseif player == "attacker" then
        local this_char_cqi, this_mf_cqi, this_faction = cm:pending_battle_cache_get_defender(1)
        enemy_faction = this_faction
    end

    local attacker_won = cm:pending_battle_cache_attacker_victory()
    local attacker_value = cm:pending_battle_cache_attacker_value()

    local defender_won = cm:pending_battle_cache_defender_victory()
    local defender_value = cm:pending_battle_cache_defender_value()
    if not attacker_won and not defender_won then
        -- draw or retreat or flee, do nothing
        -- mm:log("POST-BATTLE: Both sides lost battle; not tracking NP change!")
        return 0
    end
    -- return portion of lost soldiers + bonus if battle was lost

    local np_result
    if player == "attacker" then 
        local kill_ratio = cm:model():pending_battle():percentage_of_attacker_killed()
        np_result = (attacker_value * kill_ratio) / 1000
        if np_result >= 25 then 
            np_result = 25 
        end
        if defender_won then 
            np_result = np_result + 3
        end
        -- mm:log("+++ attacker value"..attacker_value.."].")
        -- mm:log("+++ np_result"..np_result.."].")

    elseif player == "defender" then
        local kill_ratio = cm:model():pending_battle():percentage_of_defender_killed()
        np_result = (defender_value * kill_ratio) / 1000
        if np_result >= 25 then 
            np_result = 25 
        end
        if attacker_won then 
            np_result = np_result + 3
        end
        -- mm:log("+++ defender_value"..defender_value.."].")
        -- mm:log("+++ np_result"..np_result.."].")
    end

    np_result = math.floor(np_result)
    return np_result
end

function get_eternal_ice()
    -- get amount of pooled resource
    local faction = cm:get_faction(draconic_faction)
    local pr = faction:pooled_resource(pooled_resource_key)
    return pr:value()
end


local function update_grand_spells_availability()
    local nuke_resource_amount  = get_eternal_ice()
	if nuke_resource_amount < sun_cost then
		--resource is bellow cost remove spell
        cm:remove_effect_bundle(grand_spells_effect_bundle_key[1], draconic_faction);
	else
		--resource is above cost unlock spell
        cm:apply_effect_bundle(grand_spells_effect_bundle_key[1], draconic_faction, 0)
    end
    if nuke_resource_amount < (sun_cost * 2) then
		--resource is bellow cost remove spell
        cm:remove_effect_bundle(grand_spells_effect_bundle_key[2], draconic_faction);
	else
		--resource is above cost unlock spell
        cm:apply_effect_bundle(grand_spells_effect_bundle_key[2], draconic_faction, 0);
    end
    if nuke_resource_amount < (sun_cost * 3) then
		--resource is bellow cost remove spell
        cm:remove_effect_bundle(grand_spells_effect_bundle_key[3], draconic_faction);
	else
		--resource is above cost unlock spell
        cm:apply_effect_bundle(grand_spells_effect_bundle_key[3], draconic_faction, 0);
	end
end

-------------------------------------------------
-- functionality for the NP icon on the topbar --
-------------------------------------------------
-- local faction_key = "wh2_main_grn_burning_tide";

local function add_pr_uic()
    local parent = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "topbar_list_parent")

    local uic
    local pooled_resource_key = "eternal_ice"
  	local pooled_resource_icon = "ui/eternal_ice/Belisarian_eternal_ice_summarybutt.png"
  
  	-- link max value to factor key
      local factors_list = {
        [100] = "eternal_ice_buildings", 
        [101] = "eternal_ice_chars",
        [102] = "eternal_ice_battles",
        [103] = "eternal_ice_units",
        [104] = "eternal_ice_spells"
    } 

    local function create_uic()
        uic = core:get_or_create_component(pooled_resource_key.."_"..draconic_faction, "ui/vandy_lib/pooled_resources/dy_canopic_jars", parent)
        local dummy = core:get_or_create_component("script_dummy", "ui/campaign ui/script_dummy")

        dummy:Adopt(uic:Address())

        -- -- remove all other children of the parent bar, except for the treasury, so the new PR will be to the right of the treasury holder
        -- for i = 0, parent:ChildCount() - 1 do
        --     local child = UIComponent(parent:Find(i))
        --     if child:Id() ~= "treasury_holder" then
        --         dummy:Adopt(child:Address())
        --     end
        -- end
        
        -- add the PR component!
        parent:Adopt(uic:Address())
    
        -- -- give the topbar the babies back
        -- for i = 0, dummy:ChildCount() - 1 do
        --     local child = UIComponent(dummy:Find(i))
        --     parent:Adopt(child:Address())
        -- end
    
        uic:SetInteractive(true)
        uic:SetVisible(true)
    
        local uic_icon = find_uicomponent(uic, "icon")
        uic_icon:SetImagePath(pooled_resource_icon)
        
        uic:SetTooltipText('{{tt:ui/campaign ui/tooltip_pooled_resource_breakdown}}', true)
    end

    local function check_value()
        if uic then
            local pr_obj = cm:get_faction(draconic_faction):pooled_resource(pooled_resource_key)
            local val = pr_obj:value()
            uic:SetStateText(tostring(val))
        end
    end

    if cm:whose_turn_is_it() == draconic_faction then
        create_uic()
        check_value()
    end

    local function adjust_tooltip()
        local tooltip = find_uicomponent(core:get_ui_root(), "tooltip_pooled_resource_breakdown")
        tooltip:SetVisible(true)

        print_all_uicomponent_children(tooltip)
    
        local list_parent = find_uicomponent(tooltip, "list_parent")
    
        local title_uic = find_uicomponent(list_parent, "dy_heading_textbox")
        local desc_uic = find_uicomponent(list_parent, "instructions")
    
        local loc_header = "pooled_resources"
        title_uic:SetStateText(effect.get_localised_string(loc_header.."_display_name_"..pooled_resource_key))
        desc_uic:SetStateText(effect.get_localised_string(loc_header.."_description_"..pooled_resource_key))
    
        local positive_list = find_uicomponent(list_parent, "positive_list")
        positive_list:SetVisible(true)
        local positive_list_header = find_uicomponent(positive_list, "list_header")
        positive_list_header:SetStateText(effect.get_localised_string(loc_header.."_positive_factors_display_name_"..pooled_resource_key))
    
        local negative_list = find_uicomponent(list_parent, "negative_list")
        negative_list:SetVisible(true)
        local negative_list_header = find_uicomponent(negative_list, "list_header")
        negative_list_header:SetStateText(effect.get_localised_string(loc_header.."_negative_factors_display_name_"..pooled_resource_key))

        local faction_obj = cm:get_faction(draconic_faction)
        local pr_obj = faction_obj:pooled_resource(pooled_resource_key)
        local factors_list_obj = pr_obj:factors()
    
        local factors = {} 
        local diff = 0
    
        for i = 0, factors_list_obj:num_items() - 1 do
            local factor = factors_list_obj:item_at(i)
            for num, key in pairs(factors_list) do
                if factor:maximum_value() == num then
                    factors[key] = factor:value()
                    break
                end
            end
            diff = diff + factor:value() -- adds/subtracts to set the "Change This turn" number
        end

        local total = find_child_uicomponent(list_parent, "change_this_turn")
        local total_val = find_child_uicomponent(total, "dy_value")
        if diff < 0 then
            total_val:SetState('0')
        elseif diff == 0 then
            total_val:SetState('1')
        elseif diff > 0 then
            total_val:SetState('2')
        end

        total_val:SetStateText(tostring(diff))

        --v function(key: string, parent: CA_UIC)
        local function new_factor(key, parent)
            local uic_path = "ui/vandy_lib/pooled_resources/"
            local state = ""

            if parent:Id() == "positive_list" then
                uic_path = uic_path .. "positive_list_entry"
                state = "positive"
            elseif parent:Id() == "negative_list" then
                uic_path = uic_path .. "negative_list_entry"
                state = "negative"
            end

            local factor_list = find_uicomponent(parent, "factor_list")

            local factor_entry = core:get_or_create_component(pooled_resource_key..key, uic_path, factor_list)
            factor_list:Adopt(factor_entry:Address())

            factor_entry:SetStateText(effect.get_localised_string("pooled_resource_factors_display_name_"..state.."_"..key))

            local value = factors[key]
            local value_uic = find_uicomponent(factor_entry, "dy_value")

            if state == "positive" then
                -- defaults to grey
                value_uic:SetState('0')
                if value > 0 then
                    value_uic:SetState('1') -- make green
                elseif value < 0 then
                    value_uic:SetState('2') -- make red
                end
            elseif state == "negative" then
                value_uic:SetState('0')
            end

            value_uic:SetStateText(tostring(value))
        end

        for key, value in pairs(factors) do
            if value >= 0 then
                -- positive path
                new_factor(key, positive_list)
            elseif value < 0 then
                -- negative path
                new_factor(key, negative_list)
            end
        end
    end

    core:add_listener(
        pooled_resource_key.."_hovered_on",
        "ComponentMouseOn",
        function(context)
            return uic == UIComponent(context.component)
        end,
        function(context)
            cm:callback(function()
                adjust_tooltip()
            end, 0.1)
        end,
        true
    )

    core:add_listener(
        pooled_resource_key.."_value_changed",
        "PooledResourceEffectChangedEvent",
        function(context)
            return context:faction():name() == draconic_faction and context:resource():key() == pooled_resource_key and context:faction():is_human() and cm:whose_turn_is_it() == faction_key
        end,
        function(context)
            cm:callback(function()
                check_value()
            end, 0.5);            
        end,
        true
    )

    core:add_listener(
        pooled_resource_key.."_turn_start",
        "FactionTurnStart",
        function(context)
            return context:faction():name() == draconic_faction and context:faction():is_human()
        end,
        function(context)            
            cm:callback(function()
                create_uic()
                check_value()
            end, 0.5);
        end,
        true
    )
    

    core:add_listener(
        pooled_resource_key.."_faction_turn_end",
        "FactionTurnStart",
        function(context)
            return context:faction():name() ~= draconic_faction and cm:get_faction(draconic_faction):is_human()
        end,
        function(context)
            cm:callback(function()
                uic:SetVisible(false)
            end, 0.5);
        end,
        true
    )
end

-- you need to call the function above to start everything! This is added when the UI is first created, very early on
-- core:add_ui_created_callback(function() 
--     -- Only trigger the script if the "local" player is the targeted faction
--     if cm:get_local_faction_name(true) == draconic_faction then
-- 		add_pr_uic() 
-- 	end
--   end)

------------------------------------------
-- run every game creation or game load --
------------------------------------------
function dragon_queen_init_listeners()
    local ok, err = pcall(function()
        
        core:add_listener(
            "grand_spells_availability",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == draconic_faction --and context:faction():is_human()
            end,
            function(context)
                cm:callback(function()
                    update_grand_spells_availability()
                end, 0.5);
            end,
            true
        )

        core:add_listener(
            "grand_spells_on_resource_change",
            "PooledResourceEffectChangedEvent",
            function(context)
                return context:faction():name() == draconic_faction and context:resource():key() == pooled_resource_key 
            end,
            function(context)            
                cm:callback(function()
                    update_grand_spells_availability()
                end, 0.5);
            end,
            true
        )

        -- core:add_listener(
        --     "queen_battle_units_lost",
        --     "BattleCompleted",
        --     function(context)
        --         return cm:pending_battle_cache_faction_is_involved(draconic_faction)
        --     end,
        --     function(context)
        --         local np_result = calculate_post_battle_np()
        --         if np_result == 0 then
        --             -- issue!
        --             return
        --         end
        --         cm:faction_add_pooled_resource(draconic_faction, "eternal_ice", "eternal_ice_battles", np_result)
        --         -- create_uic()
        --         -- check_value()
        --     end,
        --     true
        -- )

        core:add_listener(
            "queen_battle_grand_spells_used",
            "BattleCompleted",
            true,
            function(context)                
                -- mm:log("+++ np reduced spell_02")
                if cm:pending_battle_cache_faction_is_involved(draconic_faction) and 
                        (cm:model():pending_battle():get_how_many_times_ability_has_been_used_in_battle(draconic_faction_cqi, grand_spells_ability_key[1]) > 0) then                
                    cm:faction_add_pooled_resource(draconic_faction, "eternal_ice", "eternal_ice_spells", - sun_cost)
                    -- mm:log("+++ np reduced spell_02")
                end
                if cm:pending_battle_cache_faction_is_involved(draconic_faction) and 
                        (cm:model():pending_battle():get_how_many_times_ability_has_been_used_in_battle(draconic_faction_cqi, grand_spells_ability_key[2]) > 0) then                
                    cm:faction_add_pooled_resource(draconic_faction, "eternal_ice", "eternal_ice_spells", - sun_cost)
                    -- mm:log("+++ np reduced spell_03")
                end
                if cm:pending_battle_cache_faction_is_involved(draconic_faction) and 
                        (cm:model():pending_battle():get_how_many_times_ability_has_been_used_in_battle(draconic_faction_cqi, grand_spells_ability_key[3]) > 0) then                
                    cm:faction_add_pooled_resource(draconic_faction, "eternal_ice", "eternal_ice_spells", - sun_cost)
                -- mm:log("+++ np reduced spell_03")
                end
                -- mm:log("+++ np reduced spell_04")
            end,
            true
        )

    end)
end
--------------------------
--------------------------
-- start initialization --
--------------------------
cm:add_first_tick_callback(function()
    cm:callback(
        function()
            -- all the stuff that has to be done on Liche turnstart will also be done here, for loading games
            draconic_faction_cqi = cm:model():world():faction_by_key(draconic_faction):command_queue_index()
            dragon_queen_init_listeners()            
            -- UI stuff

            if cm:get_local_faction_name(true) == draconic_faction then   
                add_pr_uic()
                update_grand_spells_availability()                
            end
    end, 3.2);
end);
--]]