
core:add_ui_created_callback(
	function(context)
		if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
            
            mixer_enable_custom_faction("1558832144")
            mixer_change_lord_name("1558832144", "wh2_main_brt_cha_chill_king")
            mixer_add_starting_unit_list_for_faction("mixer_brt_uprising", {"wh_main_brt_inf_cute_snowmen_shield","wh_main_brt_inf_cute_snowmen_shield","wh_main_brt_inf_cute_snowmen_shield","wh_main_brt_inf_cute_snowmen_shield","wh_main_brt_inf_cute_snowmen_shield","wh_main_brt_inf_cute_snowmen_shield","wh_main_brt_inf_cute_snowmen_halb","wh_main_brt_inf_cute_snowmen_halb","wh_main_brt_inf_cute_snowmen_axe","wh_main_brt_inf_cute_snowmen_axe","wh_main_brt_inf_cute_snowmen_axe","wh_main_brt_inf_cute_snowmen_axe","wh_main_brt_inf_cute_snowmen_axe"})
			mixer_add_faction_to_major_faction_list("mixer_brt_uprising")
		end		
	end
)