#if defined _zp_points_system_included
    #endinput
#endif

#define _zp_points_system_included

/**
 * Returns the amount of Points a player currently has.
 *
 * @param id    Player index.
 *
 * @return      The player's current Points.
 */
native zp_get_user_points(id);

/**
 * Sets a player's Points.
 *
 * @param id      Player index.
 * @param amount  New amount of Points.
 */
native zp_set_user_points(id, amount);

/**
 * Opens the Give Points menu.
 *
 * @param id    Admin player index.
 */
native show_menu_give_points(id);
