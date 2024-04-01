     
local function replace_starting_general()
    if cm:is_new_game() then
        
        -- Creating replacement for Karl Franz with a regular Empire General
        local general_faction_str = "mixer_brt_uprising";       -- faction key from factions table
        local general_unit_list = "wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_halb,wh_main_brt_inf_cute_snowmen_halb,wh_main_brt_inf_cute_snowmen_axe,wh_main_brt_inf_cute_snowmen_axe,wh_main_brt_inf_cute_snowmen_axe,wh_main_brt_inf_cute_snowmen_axe,wh_main_brt_inf_cute_snowmen_axe";   -- unit keys from main_units table
        local general_region_key = "wh3_main_combi_region_konquata";  -- Region key from campaign_map_regions table
        local general_x_pos = 377;          -- x pos location, get these with Modding Tools: CQI and Coordinates Export mod
        local general_y_pos = 757;          -- y pos location, get these with Modding Tools: CQI and Coordinates Export mod
        local general_type = "general";     -- agent type
        local general_subtype = "wh2_main_brt_cha_chill_king"; -- agent subtype
        local general_forename = "names_name_4589756701"; -- from local_en names table, Bernhoff the Butcher is now ruler of Reikland
        local general_clanname = "";                -- from local_en names table
        local general_surname = "names_name_4589756702";                 -- from local_en names table
        local general_othername = "";               -- from local_en names table
        local general_is_faction_leader = true;    -- bool for whether the general being replaced is the faction leader

        if cm:get_faction("mixer_brt_uprising"):is_human() then 
            if vfs.exists("db/land_units_tables/belisarians_chill_king_units_snowmen") then
				general_unit_list = "wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_shield,wh_main_brt_inf_cute_snowmen_axe,wh_main_brt_inf_cute_snowmen_axe,wh_main_brt_inf_cute_snowmen_halb,wh_main_brt_inf_cute_snowmen_halb,wh_main_brt_snow_elf_cavalry,wh_main_brt_snow_elf_cavalry,wh_main_brt_mon_ice_shard_drake";   -- unit keys from main_units table	
            else
                general_unit_list = "wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golems_greatswords,wh_main_brt_snow_golems_greatswords,wh_main_brt_snow_golems_spears,wh_main_brt_snow_golems_spears,wh_main_brt_snow_elf_cavalry,wh_main_brt_snow_elf_cavalry,wh_main_brt_mon_ice_shard_drake";   -- unit keys from main_units table
			end
        else
            general_unit_list = "wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golem_shields,wh_main_brt_snow_golems_greatswords,wh_main_brt_snow_golems_greatswords,wh_main_brt_snow_golems_greatswords,wh_main_brt_snow_golems_greatswords,wh_main_brt_snow_golems_spears,wh_main_brt_snow_golems_spears,wh_main_brt_snow_golems_spears,wh_main_brt_snow_golems_spears,wh_main_brt_snow_elf_cavalry,wh_main_brt_snow_elf_cavalry,wh_main_brt_snow_elf_cavalry,wh_main_brt_mon_ice_shard_drake,wh_main_brt_mon_ice_shard_drake,wh_main_brt_mon_ice_shard_drake";   -- unit keys from main_units table
        end;

        --cm:transfer_region_to_faction("wh2_main_albion_citadel_of_lead","mixer_brt_uprising");
        --cm:transfer_region_to_faction("wh2_main_albion_albion","mixer_brt_uprising");
        -- cm:transfer_region_to_faction("wh2_main_albion_isle_of_wights","mixer_brt_uprising");
        -- local region ="wh2_main_albion_isle_of_wights";        
        -- local region_interface = cm:get_region(region);
        -- local result_building = cm:region_slot_instantly_upgrade_building(region_interface:settlement():primary_slot(), building);
        -- cm:transfer_region_to_faction("wh2_main_albion_isle_of_wights","wh_dlc08_nor_vanaheimlings");
        -- cm:transfer_region_to_faction("wh2_main_albion_isle_of_wights","mixer_brt_uprising");
        -- cm:callback(function() cm:heal_garrison(cm:get_region(region):cqi()) end, 0.5);


        local faction_key = general_faction_str -- factions key
        local faction = cm:model():world():faction_by_key(faction_key); -- FACTION_SCRIPT_INTERFACE faction
        local unit_count = 1; -- card32 count
        local rcp = 20; -- float32 replenishment_chance_percentage
        local max_units = 1; -- int32 max_units
        local murpt = 0.1; -- float32 max_units_replenished_per_turn
        local xp_level = 0; -- card32 xp_level
        local frr = ""; -- (may be empty) String faction_restricted_record
        local srr = ""; -- (may be empty) String subculture_restricted_record
        local trr = ""; -- (may be empty) String tech_restricted_record
        

        cm:add_unit_to_faction_mercenary_pool(faction, "wh_pro04_brt_cav_mounted_yeomen_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
        cm:add_unit_to_faction_mercenary_pool(faction, "wh_pro04_brt_inf_foot_squires_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
        cm:add_unit_to_faction_mercenary_pool(faction, "wh_pro04_brt_cav_knights_of_the_realm_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
        cm:add_unit_to_faction_mercenary_pool(faction, "wh_pro04_brt_cav_knights_errant_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
        cm:add_unit_to_faction_mercenary_pool(faction, "wh_pro04_brt_inf_battle_pilgrims_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);
        cm:add_unit_to_faction_mercenary_pool(faction, "wh_pro04_brt_cav_questing_knights_ror_0", unit_count, rcp, max_units, murpt, xp_level, frr, srr, trr, true);




        -- end;
        local init_leader = cm:get_faction(general_faction_str):faction_leader()
        
        cm:create_force_with_general(
            general_faction_str,
            general_unit_list,
            general_region_key,
            general_x_pos,
            general_y_pos,
            general_type,
            general_subtype,
            general_forename,
            general_clanname,
            general_surname,
            general_othername,
            general_is_faction_leader,

            -- Generals created this way does not come with a trait
            function(cqi)
                local new_char_lookup = cm:char_lookup_str(cqi)
                cm:replenish_action_points(new_char_lookup, 100)
            end
        );
        
        

        cm:set_character_immortality("character_cqi:".. init_leader:command_queue_index(), false);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
        cm:kill_character(init_leader:command_queue_index(), true, true);
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 1);
        out("Killing original");
        
        
        
        
        cm:callback(function() cm:reset_shroud(faction) end, 5);
    end;
end;



cm:add_first_tick_callback(function()
    cm:callback(
        function() 
            replace_starting_general() 
        end, 3.3);
end);