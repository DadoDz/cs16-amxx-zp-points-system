#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fvault>
#include <zombie_plague_x/zombie_plague_x>
#include <zombie_plague_x/zp_user_system>
#include <zombie_plague_x/add_commas>

#define PLUGIN  "[ZP] Points System"
#define VERSION "1.0"
#define AUTHOR  "DadoDz"

#define SAVE "zpx_save_points"
#define LOG_FILE "zpx_give_points.log"
#define LOG_FILEM "zpx_give_points_menu.log"

new g_points[33];
new g_playername[33][32];
new bool:g_loaded[33];
new g_GivePoints[33];

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);

	RegisterHam(Ham_Killed, "player", "fw_PlayerKilled")

	register_concmd("zp_points", "cmd_points", _, "<target> <amount> - Give someone Points", 0)
	register_concmd("POINTS_AMOUNT", "GivePoints")
}

public client_putinserver(id)
{
	get_user_name(id, g_playername[id], charsmax(g_playername[]));

	g_points[id] = 0;

	if (!is_user_bot(id) && !is_user_hltv(id))
		LoadPlayerPoints(id);
}

public client_disconnected(id)
{
	if (!is_user_bot(id) && !is_user_hltv(id))
		SavePlayerPoints(id);

	g_loaded[id] = false;
	g_points[id] = 0;
}

public plugin_natives()
{
	register_native("zp_get_user_points", "native_get_user_points", 1)
	register_native("zp_set_user_points", "native_set_user_points", 1)
	register_native("show_menu_give_points", "show_menu_give_points", 1);
}

public cmd_points(id, level, cid)
{
	if (!HasCommandAccess(id, read_flags("w")))
		return PLUGIN_HANDLED;
	
	static arg[32], amount[16], szPoints[32], admin_rank[32], player, points;
	read_argv(1, arg, charsmax(arg))
	read_argv(2, amount, charsmax(amount))
	
	player = cmd_target(id, arg, CMDTARGET_ALLOW_SELF)
	if (!player) return PLUGIN_HANDLED;
	
	points = str_to_num(amount);
	if (points < 1) return PLUGIN_HANDLED;
	
	add_commas(points, szPoints, charsmax(szPoints));
	get_admin_rank_name(id, admin_rank, charsmax(admin_rank))

	g_points[player] += points;

	client_print_color(0, print_team_default, "^04[^01ZP^04]^01 %s^03 %s^01 gave^04 %s^01 Points to^03 %s^04.", admin_rank, g_playername[id], szPoints, g_playername[player])
	log_to_file(LOG_FILE, "%s: %s Gave %s Points to %s", admin_rank, g_playername[id], szPoints, g_playername[player])
	return PLUGIN_HANDLED;
}

// Ham Player Killed Forward
public fw_PlayerKilled(victim, attacker, shouldgib)
{
	if (zp_get_user_zombie(attacker))
	{
		if (is_user_vip(attacker) || is_user_svip(attacker))
			g_points[attacker] += 2;
		else
			g_points[attacker] += 1;
	}
	else
	{
		if (is_user_svip(attacker))
			g_points[attacker] += 4;
		else if (is_user_vip(attacker))
			g_points[attacker] += 3;
		else
			g_points[attacker] += 2;
	}

	SavePlayerPoints(attacker);
}

public SavePlayerPoints(id)
{
	if(is_user_bot(id) || is_user_hltv(id) || !g_loaded[id])
		return;
        
	new szDataHolder[160];
	formatex(szDataHolder, charsmax(szDataHolder), "%i", g_points[id]);
	fvault_set_data(SAVE, g_playername[id], szDataHolder);   
}

public LoadPlayerPoints(id)
{
	if (!g_playername[id][0])
		return;
        
	new szDataHolder[160], szPoints[15];

	if (fvault_get_data(SAVE, g_playername[id], szDataHolder, charsmax(szDataHolder)))
	{
		parse(szDataHolder, szPoints, charsmax(szPoints));
		g_points[id] = str_to_num(szPoints);
	}
	else
		g_points[id] = 0;

	g_loaded[id] = true;
}


public show_menu_give_points(id)
{	
	static pmenu, menu[128], info[2], PointsString[16];
	
	format(menu, charsmax(menu), "\y•  \wGive\y Points\r Menu  \y•\d")
	pmenu = menu_create(menu, "pmenu_handler_gpoints");

	for (new player = 0; player < get_maxplayers(); player++)
	{	
		if (!is_user_connected(player))
			continue;

		add_commas(g_points[player], PointsString, charsmax(PointsString));
		formatex(menu, charsmax(menu), "\r•  \w%s \r[\dPoints\w: \y%s\r]", g_playername[player], PointsString)

		info[0] = player;
		info[1] = 0;

		menu_additem(pmenu, menu, info);
	}

	menu_display(id, pmenu, 0);
}

public pmenu_handler_gpoints(id, pmenu, item)
{	
	if (item == MENU_EXIT)
		return;

	new player, access, info[2];
	menu_item_getinfo(pmenu, item, access, info, charsmax(info), _, _, access);
	player = info[0];

	if (!is_user_connected(player))
		return;

	client_cmd(id, "messagemode POINTS_AMOUNT");
	g_GivePoints[id] = player
	menu_destroy(pmenu);
}

public GivePoints(id)
{
	new playerid, points, szAmount[32], szPoints[32], admin_rank[32];

	read_argv(1, szAmount, charsmax(szAmount));
	points = str_to_num(szAmount);
	playerid = g_GivePoints[id]

	if (!is_user_connected(playerid))
		return;

	if (points <= 0)
	{
		client_print_color(id, print_team_default, "^x04[^x01ZP^x04]^x01 Invalid value of^x03 points^x01 to give!")
		return;
	}

	add_commas(points, szPoints, charsmax(szPoints));
	get_admin_rank_name(id, admin_rank, charsmax(admin_rank))

	g_points[playerid] += points;

	client_print_color(0, print_team_default, "^04[^01ZP^04]^01 %s^03 %s^01 gave^04 %s^01 Points to^03 %s^04.", admin_rank, g_playername[id], szPoints, g_playername[playerid])
	log_to_file(LOG_FILEM, "%s: %s Gave %s Points to %s", admin_rank, g_playername[id], szPoints, g_playername[playerid])
}

public native_get_user_points(id) return g_points[id];

public native_set_user_points(id, amount)
{
	g_points[id] = amount;
	SavePlayerPoints(id);
}
