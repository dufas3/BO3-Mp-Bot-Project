#ifdef MP

UnlockAll()
{
    self thread grab_stats_from_table();
}

grab_stats_from_table()
{
    if( self getDstat( "playerstatslist", "rank", "statValue" ) < 54 )
    {
        self SetDStat( "playerstatslist", "rankxp", "statValue", 1457200 );
        self SetDStat( "playerstatslist", "rank", "statValue", 54 );
        self SetDStat( "playerstatslist", "plevel", "StatValue", 10 );
        iPrintLn( self.name, " Stats has been set, please leave the game and rejoin" );
        return;
    }

    sort_stats_from_table("mp_statstable", 0, 256, 9, 2, 3 );
    sort_stats_from_table( "statsmilestones1", 1, 239 );
    sort_stats_from_table( "statsmilestones2", 256, 483 );
    sort_stats_from_table( "statsmilestones3", 512, 767 );
    sort_stats_from_table( "statsmilestones4", 768, 929 );
    sort_stats_from_table( "statsmilestones5", 1024, 1494 );
    sort_stats_from_table( "statsmilestones6", 1500, 1515 ); 

    self unlock_all_challenges();
    self addplayerstat("score", 5000000);

    self setDstat("afteractionreportstats", "lobbypopup", "none");
    self iPrintLn("Unlock All ^2Completed");
}
sort_stats_from_table( table, sIndex, eIndex, value_column = 2, type_column = 3, name_column = 4, split_column = 13 )
{
    if( !isDefined( level.custom_stats ) )
        level.custom_stats = [];
    level.custom_stats[ table ] = [];
    previous = "";

    for(value=sIndex;value<eIndex+1;value++)
    {
        stat         = spawnStruct();
        stat.value   = int( tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, value_column ) );
        stat.type    = tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, type_column );
        stat.name    = tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, name_column );
        stat.index   = int( tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, 0 ) );
        
        split = tableLookup( "gamedata/stats/mp/" + table + ".csv", 0, value, split_column );
        if( isDefined( split ) && split != "" )       
            stat.split = split;

        if( previous.type != stat.type || previous.name != stat.name || previous.value > stat.value )
        {
            if( isDefined( previous ) && previous != "" )
            {
                if( previous.type != "" && previous.name != "" && previous.value > 0 )
                    level.custom_stats[ table ][ level.custom_stats[ table ].size ] = previous;
            }
        }
        previous = stat;
    }
}

unlock_all_challenges()
{
    self endon("disconnect");

    tables       = [];
    stats        = ["kills", "kills_ability", "kills_weapon", "multikill_ability", "multikill_weapon", "kill_one_game_ability", "kill_one_game_weapon", "challenge1", "challenge2", "challenge3", "challenge4", "challenge5"];
    heroes       = ["heroes_mercenary", "heroes_outrider", "heroes_technomancer", "heroes_battery", "heroes_enforcer", "heroes_trapper", "heroes_reaper", "heroes_spectre", "heroes_firebreak"];
    hero_weapons = ["HERO_MINIGUN", "HERO_LIGHTNINGGUN", "HERO_GRAVITYSPIKES", "HERO_ARMBLADE", "HERO_ANNIHILATOR", "HERO_PINEAPPLEGUN", "HERO_BOWLAUNCHER", "HERO_CHEMICALGELGUN", "HERO_FLAMETHROWER"];
    weapons      = ["smg_fastfire", "lmg_heavy", "ar_standard", "pistol_burst", "sniper_fastbolt", "shotgun_fullauto"];
    
    for(i=1;i<6;i++)
    {
        self SetDStat("prestigetokens", i, "tokentype", "prestige_extra_cac", 1);
        self SetDStat("prestigetokens", i, "tokenspent", 1);
    }

    _setStats = 0;
    for(table=1;table<7;table++)
    {
        iPrintLnBold("statsmilestones" + table + " ", level.custom_stats[ "statsmilestones" + table ].size);
        foreach( stat in level.custom_stats[ "statsmilestones" + table ] )
        {
            iPrintLn( stat.type, " ^1", stat.name, " ^2", stat.value );
            if( stat.name == "" || stat.type == "" || stat.value == 0 ) //saftey
                continue;

            switch( stat.type )
            {
                case "global":
                    self setDStat("playerstatslist", stat.name, "statValue", stat.value);
                    self setDStat("playerstatslist", stat.name, "challengevalue", stat.value);
                    _setStats += 2;
                break;

                case "gamemode":
                    foreach( gametype in strTok(stat.split, " ") )
                    {
                        self SetDStat("PlayerStatsByGameType", gametype, stat.name, "StatValue", stat.value);
                        self setDStat("PlayerStatsByGameType", gametype, stat.name, "challengevalue", stat.value);
                        _setStats += 2;
                    }
                break;

                case "group":
                    foreach( group_name in strTok(stat.split, " ") )
                    {
                        self setDStat("groupstats", group_name, "stats", stat.name, "challengevalue", stat.value);
                        _setStats += 1;
                    }
                break;

                case "killstreak":
                    foreach(streak_name in strTok(stat.split + " killstreak_autoturret killstreak_helicopter_gunner", " ") )
                    {
                        self addWeaponStat(level.killstreaks[ GetSubStr( streak_name, 11 ) ].weapon, stat.name, stat.value);
                        _setStats += 1;
                    }
                break;

                case isWeapon_category( stat.type ):
                    foreach( weapon in strTok(stat.split, " ") )
                    {               
                        self addWeaponStat( GetWeapon( weapon ), stat.name, stat.value ); 
                        self addRankXp("kill", GetWeapon( weapon ), undefined, undefined, 1, stat.value * 2 );
                        wait .2;
                        
                        index = GetBaseWeaponItemIndex( GetWeapon( weapon ) );
                        if(self getdstat("itemstats", index, "plevel") != 15)
                        {
                            self setdstat("itemstats", index, "plevel", 15);
                            for(i = 0; i < 3; i++)
                                self setdstat("itemstats", index, "isproversionunlocked", i, 1);
                        }
                        _setStats += 8;
                    }
                break;

                case "attachment":
                    foreach( attachment in strTok(stat.split, " ") )
                    {
                        self SetDStat("attachments", attachment, "stats", stat.name, "statValue", stat.value);
                        self SetDStat("attachments", attachment, "stats", stat.name, "challengeValue", stat.value);
                        for(i = 1; i < 8; i++)
                        {
                            self SetDStat("attachments", attachment, "stats", "challenge" + i, "statValue", stat.value);
                            self SetDStat("attachments", attachment, "stats", "challenge" + i, "challengeValue", stat.value);
                        }
                        _setStats += 20;
                    }
                break;

                case "specialist":
                    foreach( specialist in strTok(stat.split, " ") )
                    {
                        self SetDStat("specialiststats", getIndexFromName( specialist, heroes ), "stats", stat.name, "statValue", stat.value);
                        self SetDStat("specialiststats", getIndexFromName( specialist, heroes ), "stats", stat.name, "challengeValue", stat.value);
                        _setStats += 2;
                    }
                    foreach( hero_weapon in hero_weapons )
                    {
                        self addWeaponStat(GetWeapon( hero_weapon ), stat.name, stat.value);
                        self addweaponstat(GetWeapon( hero_weapon ), "used", stat.value);
                        _setStats += 2;
                    }
                break;

                case "hero":
                    break; 

                case "bonuscard":
                    for(e=178;e<188;e++)
                    {
                        self setdstat("itemstats", e, "stats", stat.name, "statvalue", 300);
                        self setdstat("itemstats", e, "stats", stat.name, "challengevalue", 300);
                        _setStats += 2;
                    }
                break; 

                default:
                    self iPrintLn( "Unknown Data Type: ", stat.type );
                break;
            }

            if( _setStats > 170 )
            {
                _setStats = 0;
                uploadStats( self );
                iPrintLnBold("Moving to next Stat");
                wait .2;
            }
            wait .1;
        }
        uploadStats( self );
        wait 1;
    }
}

getIndexFromName( string, array )
{
    foreach(index, name in array)
    {
        if( name == string )
            return index;
    }
    return undefined;
}

isWeapon_category( weapon )
{
    return isSubStr( weapon, "weapon_" ) ? weapon : "  ";
}

#endif
