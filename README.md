# [ZP] Packs Shop

A persistent Points system for Zombie Plague X.
This plugin gives players Points for killing zombies and humans. Players can use their Points in other systems, such as the Packs Shop, while admins can give Points to players through commands or an in-game menu.
Player Points are automatically saved and loaded using FVault, allowing them to persist between reconnects

## Plugin Information

  - **Name**: [ZP] Points System
  - **Version**: 1.0
  - **Author**: DadoDz
  - **Game**: Counter-Strike 1.6
  - **Mod**: Zombie Plague

## Requirements

- AMX Mod X **1.9+**
- Zombie Plague Mod
- FVault

## Installation
1. Place ```zp_points_system.sma``` in: ```addons/amxmodx/scripting/```
2. Compile it with your AMXX compiler.
3. Place the compiled ```.amxx``` file in: ```addons/amxmodx/plugins/```
4. Add this line to your plugins.ini: ```zp_points_system.amxx```
5. Restart your server.

## Points Rewards

### Killing a Zombie

| **Player Rank** | **Points** |
|-----------------|------------|
| Player          | 1          |
| VIP             | 2          |
| SVIP            | 2          |

### Killing a Human

| **Player Rank** | **Points** |
|-----------------|------------|
| Player          | 2          |
| VIP             | 3          |
| SVIP            | 4          |

## Commands

### Console Command
```zp_points <target> <amount>``` ---> Gives Points to a specific player.

## Notice
> This plugin was created specifically for Zombie Plague X and is designed to work with other systems that use Points as a currency.
> The Points System can be used by other plugins, such as shops, rewards, ranking systems, and other custom gameplay systems.

