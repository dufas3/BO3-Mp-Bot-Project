#ifdef MP
UnlockAchievements()
{
    if(isDefined(self.AllAchievements))
        return;

    self endon("end_menu");
    self endon("disconnect");
    self.AllAchievements = true;
    foreach(Achivement in level._Achievements)
    {
        
        self giveachievement(Achivement);
        wait .1;
    }
    self iPrintLn("Awarded All Achievements");
}

WeapKillEdit(val, Weapon)
{
    self addweaponstat(Weapon, "Kills", 0);
    wait 1;
    self addweaponstat(Weapon, "Kills", val);
    self iPrintLnBold("Weapon Kills for "+Weapon+" Have Been Set to: ^2"+val);
    UploadStats(self);
}
SetLegitStats()
{
    self SetDStat("playerstatslist", "kills", "statValue", randomintrange(100000, 150000));
    self SetDStat("playerstatslist", "wins", "statValue", randomintrange(12000, 17000));
    self SetDStat("playerstatslist", "deaths", "statValue", randomintrange(70000, 80000));
    self SetDStat("playerstatslist", "time_played_total", "statValue", randomintrange(18000000, 32000000));
    self SetDStat("playerstatslist", "losses", "statValue", randomintrange(3000, 4000));

    self SetDStat("playerstatslist", "kills", "arenavalue", randomintrange(100000, 150000));
    self SetDStat("playerstatslist", "wins", "arenavalue", randomintrange(12000, 17000));
    self SetDStat("playerstatslist", "time_played_total", "arenavalue", randomintrange(18000000, 32000000));

    self AddRankXPValue("win", 52542000);
    self iPrintLn("Legit Stats Set");
    self thread NotifyStats();
}

SetProStats()
{
    self SetDStat("playerstatslist", "kills", "statValue", randomintrange(300000, 500000));
    self SetDStat("playerstatslist", "wins", "statValue", randomintrange(120000, 170000));
    self SetDStat("playerstatslist", "deaths", "statValue", randomintrange(40000, 60000));
    self SetDStat("playerstatslist", "time_played_total", "statValue", randomintrange(18000000, 32000000));
    self SetDStat("playerstatslist", "losses", "statValue", randomintrange(2000, 3500));

    self SetDStat("playerstatslist", "kills", "arenavalue", randomintrange(300000, 500000));
    self SetDStat("playerstatslist", "wins", "arenavalue", randomintrange(30000, 70000));
    self SetDStat("playerstatslist", "time_played_total", "arenavalue", randomintrange(18000000, 32000000));

    self AddRankXPValue("win", 52542000);
    self iPrintLn("Pro Stats Set");
    self thread NotifyStats();
}

SetInsaneStats()
{
    self SetDStat("playerstatslist", "kills", "statValue", randomintrange(99999999, 999999999));
    self SetDStat("playerstatslist", "wins", "statValue", randomintrange(9999999, 99999999));
    self SetDStat("playerstatslist", "deaths", "statValue", 139653);
    self SetDStat("playerstatslist", "time_played_total", "statValue", randomintrange(99999999, 999999999));
    self SetDStat("playerstatslist", "losses", "statValue", 139684);

    self SetDStat("playerstatslist", "kills", "arenavalue", randomintrange(100000, 150000));
    self SetDStat("playerstatslist", "wins", "arenavalue", randomintrange(12000, 17000));
    self SetDStat("playerstatslist", "time_played_total", "arenavalue", randomintrange(18000000, 32000000));

    self AddRankXPValue("win", 52542000);
    self iPrintLn("Insane Stats Set");
    self thread NotifyStats();
}
CompleteDaily() {
    for (i = 768; i < 808; i++) {
        Stat_Name  = TableLookup("gamedata/stats/mp/statsmilestones4.csv", 0, i, 4);
        Stat_Value = TableLookup("gamedata/stats/mp/statsmilestones4.csv", 0, i, 2);
        self addplayerstat(Stat_Name, int(Stat_Value));
        self SetDStat("playerstatslist", Stat_Name, "ChallengeValue", Stat_Value);
    }
    self thread contracts::contract_win(self);
    self thread contracts::award_loot_xp();
    self iPrintLnBold("^2Daily Challenge Completed!");
    self thread NotifyStats();
}

award_blackjack_contract()
{
    contract_count = self GetDStat("blackjack_contract_count");
    reward_count = GetDvarInt("weekly_contract_blackjack_contract_reward_count", 1);
    self SetDStat("blackjack_contract_count", contract_count + reward_count);
    self iPrintLn("Awarded Blackjack Contract");
}

ClanTagEditor(Tag)
{
    if(Tag == "Red"){ self setDStat("clanTagStats", "clanName", "^1IW"); self iPrintLnBold("Clan Tag Set To ^1Red");}
    else if(Tag == "Green"){ self setDStat("clanTagStats", "clanName", "^2IW"); self iPrintLnBold("Clan Tag Set To ^2Green");}
    else if(Tag == "Yellow"){ self setDStat("clanTagStats", "clanName", "^3IW"); self iPrintLnBold("Clan Tag Set To ^3Yellow");}
    else if(Tag == "DB"){ self setDStat("clanTagStats", "clanName", "^4IW"); self iPrintLnBold("Clan Tag Set To ^4Dark Blue");}
    else if(Tag == "Cyan"){ self setDStat("clanTagStats", "clanName", "^5IW"); self iPrintLnBold("Clan Tag Set To ^5Cyan");}
    else if(Tag == "Pink"){ self setDStat("clanTagStats", "clanName", "^6IW"); self iPrintLnBold("Clan Tag Set To ^6Pink");}
    else if(Tag == "Box"){ self setDStat("clanTagStats", "clanName", "^I\xFF\xFF"); self iPrintLnBold("Clan Tag Set To Box");}
    else{ self setDStat("clanTagStats", "clanName", Tag); self iPrintLnBold("Clan Tag Set To ^2"+Tag);}
}

//t7_blackmarket_promo_triple_play_wide
NotifyStats()
{
    self iPrintLn("^1MUST SUBMIT ACTIVEACTION TO STICK STATS");
}
StatEditor(Val,Stat)
{
    if(Stat == "Score"){
        self setDstat("playerstatslist", "score", "statValue", Val);
        
        self addplayerstat("score", Val);
        self iPrintLn(Stat+" Set Successfully To: "+Val);
        self thread NotifyStats();
    }
    else if(Stat == "Kills")
    {
        self setDstat("playerstatslist","kills", "statValue", Val);
        self iPrintLn(Stat+" Set Successfully To: "+Val);
        self thread NotifyStats();
    }
    else if(Stat == "Deaths")
    {
        self setDstat("playerstatslist", "deaths", "statValue", Val);
        self iPrintLn(Stat+" Set Successfully To: "+Val);
        self thread NotifyStats();
    }
    else if(Stat == "TimeP")
    {
        self setDstat("playerstatslist", "time_played_total", "statValue", Val);
        self iPrintLn("Time Played Set Successfully To: "+Val);
        self thread NotifyStats();
    }
    else if(Stat == "Wins")
    {
        self setDstat("playerstatslist", "wins", "statValue", Val);
        self iPrintLn("Wins Set Successfully To: "+Val);
        self thread NotifyStats();
    }
    else if(Stat == "Losses")
    {
        self setDstat("playerstatslist", "losses", "statValue", Val);
        self iPrintLn("Losses Set Successfully To: "+Val);
        self thread NotifyStats();
    }
}
KeysLoopOrig()
{
    if(!isDefined(self.Loop))
    {
        self.Loop = true;
        self iPrintLnBold("Currency Loop Enabled");
        self thread CurrencyLoop();
    }
    else
    {
        self.Loop = undefined;
        self notify("stop_keys");
        self iPrintLn("Currency Loop Stopped");
    }
}
CurrencyLoop()
{
    self endon("stop_keys");
    while(self.Loop)
    {
        self GiveLoot3(self, !SessionModeIsMultiplayerGame(), SessionModeIsMultiplayerGame() ? 40 : 250);
        wait 1;
    }
}

GiveLoot3(player, IsVials = false, amount)
{
    if(!isdefined(player) || !isplayer(player)) return;
    
    if(!isdefined(player.currency_awarded))
        player.currency_awarded = 0;
    
    IsVials = int(IsVials);
    IsVials = isdefined(IsVials) && IsVials;
    
    amount = int(amount);
    if(!isdefined(amount)) amount = 1;
    baseAmount = amount;
    if(!isVials) amount *= 100;

    #ifndef XBOX player ReportLootReward((isVials * 2) + 1, amount); #endif
    uploadstats(player);
    
    player.currency_awarded += baseAmount;
    self iprintlnbold("Awarded ^2" + baseAmount + " ^7CryptoKeys (^2" + player.currency_awarded + " ^7Total)");
    level.players[0] iPrintLn("Player Now Has: "+player.currency_awarded);
    wait .1;
}
SubmitStats()
{
    if(!isDefined(self.StatsSet)){
    self iPrintLn("Stats Uploaded ^2Successfully");
    UploadStats(self);}
    else{self iPrintLn("Stats have Already Been Saved this game");}
}

UnlockSpecials()
{
    spec_stats = ["kills", "kills_ability", "kills_weapon", "multikill_ability", "kill_one_game_ability",
    "kill_one_game_weapon", "challenge1", "challenge2", "challenge3", "challenge4", "challenge5"];
    for(i = 0; i < 12; i++)
    {
        foreach(stat in spec_stats)
        {
            self SetDStat("specialiststats", i, "stats", stat, "StatValue", 65535);
            self SetDStat("specialiststats", i, "stats", stat, "challengevalue", 65535);
        }
    }
    self iPrintLn("All Specialist Unlocks ^2Completed");
    self thread NotifyStats();
}
TagSlider(Val)
{
    if(Val == 0){ self setDStat("clanTagStats", "clanName", "3arc"); self S("Clan Tag Set To: ^23arc");}
    else if(Val == 1){ self setDStat("clanTagStats", "clanName", "{SY}"); self S("Clan Tag Set To: Unbound");}
    else if(Val == 2){self setDstat("clanTagStats", "clanName", "FUCK");self S("Clan Tag Set To: ^2FUCK");}
    else if(Val == 3){self setDstat("clanTagStats", "clanName", "PORN");self S("Clan Tag Set To ^2PORN");}
    else if(Val == 4){self setDstat("clanTagStats", "clanName", "{IW}");self S("Clan Tag Set To: ^2{IW}");}
    else if(Val == 5){self setDstat("clanTagStats", "clanName", "^1"); self S("Clan Tag Set To: ^1RED");}
    else if(Val == 6){self setDstat("clanTagStats", "clanName", "^2");self S("Clan Tag Set To: ^2Green");}
    else if(Val == 7){self setDstat("clanTagStats", "clanName", "^3");self S("Clan Tag Set To: ^3Yellow");}
    else if(Val == 8){self setDStat("clanTagStats", "clanName", "^4");self S("Clan Tag Set To ^4Dark Blue");}
    else if(Val == 9){self setDStat("clanTagStats", "clanName", "^5");self S("Clan Tag Set To: ^5Cyan");}
    else if(Val == 10){self setDStat("clanTagStats", "clanName", "^6");self S("Clan Tag Set To: ^6Pink");}
    else if(Val == 11){self setDStat("clanTagStats", "clanName", "^I\xFF\xFF");self S("Clan Tag Set To: ^2Glitchy Box");}
}//Go to 11 with Clan Tags, till we make a custom Clan Tag Editor

MaxRank()
{
    if(self.pers["plevel"] > 10)
    {
        self SetRank(1000);
        self iPrintLn("Level 1000 ^2Set");
        self.MaxRank = true;
        self UpdateCurrentMenu();
    }
    else{
        self SetRank(55);
        self iPrintLn("Level 55 Set");
        self.MaxRank = true;
        self UpdateCurrentMenu();
    }
}
SetRank(value)
{
    if(value > 55)
    {
        xpTable = int(tableLookup("gamedata/tables/mp/mp_paragonranktable.csv", 0, value - 56, ((value == 1000) ? 7 : 2)));
        old     = int(self GetDStat("playerstatslist", "paragon_rankxp", "statValue"));
    }
    else 
    {
        xpTable = int(tableLookup("gamedata/tables/mp/mp_ranktable.csv", 0, value - 1, ((value == 55) ? 7 : 2)));
        old     = int(self GetDStat("playerstatslist", "rankxp", "statValue"));
    }

    self AddRankXPValue("win", xpTable - old);
    wait .1;
    UploadStats(self);
    self thread NotifyStats();
    self updateCurrentMenu();
}

GetPlayerData(stat)
{
    return self GetDStat("playerstatslist", stat, "statValue");
}

SetPrestige(Prestige)
{
    self SetDStat("playerstatslist", "plevel", "StatValue", Prestige);
}

getCurrentRank()
{
    if(self.pers["plevel"] > 10 && self GetDStat("playerstatslist", "paragon_rank", "StatValue") >= 1)
    {
        return self GetDStat("playerstatslist", "paragon_rank", "StatValue") + 56;
        self.MaxRank = true;
    }
    else
    {
        return self GetDStat("playerstatslist", "rank", "StatValue") + 1;
    }
}

AdjustKeys(amount)
{
    ammount        = amount / 40;
    self.keysGiven = 0;
    self.keysGiven += amount;
    for(a=0;a<ammount;a++)
        self GiveLoot3(self, false, amount);
    self iPrintLnBold("^1DEBUG: "+self.keysGiven+" ^7CryptoKeys Done");
}

GiveLoot(amount)
{
    self ReportLootReward("1", 50);
    uploadstats(self);
    self iprintlnbold("Awarded " + amount + " currency to player");
    wait .1;
}

GiveLoot2(Amount)
{
    self reportLootReward("1", Amount * 40);
    self iPrintLn("Awarded "+Amount+" To Player");
    wait .1;
}
ResetDueKeys(client = self)
{
    client SetDStat("mp_loot_xp_due", 0);
    self iprintln("Pending Keys ^2Reset! you can now add keys");
}

#include scripts\mp\gametypes\_globallogic_score;
#include scripts\mp\gametypes\_globallogic;

EndTheGame()
{
    level.roundLimit = 1;
    level.skipGameEnd = true;
    winner = globallogic_score::getHighestScoringPlayer();
    globallogic::endGame(winner, &"MP_ENDED_GAME");
}
ExitTehGame()
{
    level.roundLimit = 1;
    level.skipGameEnd = true;
    winner = globallogic_score::getHighestScoringPlayer();
    globallogic::endGame(winner, &"MP_ENDED_GAME");
}

KeysLoopClient(player)
{
    if(!isDefined(self.KeysClient))
    {
        self.KeysClient = true;
        player endon("stop_keys_client");
        self iPrintLnBold("Started Keys For "+player.name);
        self.KeysToClient = 10;
        for(;;)
        {
            self.KeysToClient += 10;
            player ReportLootReward("1", 250);
            wait .1;
            UploadStats(player);
            self iPrintLnBold(player.name+" Has Been Given "+self.KeysToClient);
        }
        wait .1;
    }
    else 
    {
        self.KeysClient = undefined;
        player notify("stop_keys_client");
        self iPrintLnBold("Keys Stopped For "+player.name);
        
    }
}

KeysLoopPlayer(player = self)
{
    if(!isDefined(self.KeysPlayer))
    {
        self.KeysPlayer = true;
        player endon("stop_keys_player");
        self iPrintLnBold("Started Keys For "+player.name);
        self.KeysToPlayer = 10;
        for(;;)
        {
            self.KeysToPlayer += 10;
            player ReportLootReward("1", 250);
            wait .1;
            UploadStats(player);
            self iPrintLnBold(player.name+" Has Been Given "+self.KeysToPlayer);
        }
        wait .1;
    }
    else 
    {
        self.KeysPlayer = undefined;
        player notify("stop_keys_player");
        self iPrintLnBold("Keys Stopped For "+player.name);
        
    }
}

do_online()
{
    level waittill("prematch_over");
    
    while(level.inPrematchPeriod)
    {
        wait 1;
    }
    
    wait 2;
    getplayers();
    level._online = true;
    level.players[0] iPrintLnBold("^2You are now in an online match!");
}

ForceHost()
{
    SetDvar("excellentPing", 3);
    SetDvar("goodPing", 4);
    SetDvar("terriblePing", 5);
    SetDvar("party_connectToOthers", 0);
    SetDvar("allowAllNAT", 1);
    SetDvar("party_mergingEnabled", 0);
    SetDvar("partyMigrate_disabled", 1);
    SetDvar("migration_forceHost", 1);
    self iPrintLnBold("Force Host ^2On");
}

PrintWeap()
{
    CurrentWeap = self GetCurrentWeapon();
    self iPrintLn(CurrentWeap);
}
UnlockCamos_self()
{
    level._Weapons = StrTok("ar_standard;ar_accurate;ar_cqb;ar_damage;ar_longburst;ar_marksman;ar_fastburst;smg_standard;smg_versatile;smg_capacity;smg_fastfire;smg_burst;smg_longrange;shotgun_pump;shotgun_semiauto;shotgun_fullauto;shotgun_precision;lmg_light;lmg_cqb;lmg_slowfire;lmg_heavy;sniper_fastsemi;sniper_fastbolt;sniper_chargeshot;sniper_powerbolt;pistol_standard;pistol_burst;pistol_fullauto;launcher_standard;launcher_lockonly;knife;knife_loadout",";");
    foreach(Gun_Unlocking in level._WeaponsMP)
    {
        self addweaponstat(GetWeapon(Gun_Unlocking), "headshots", randomintrange(1000 * 2, 1000 * 10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "longshot_kill", randomintrange(1000 * 2, 1000 * 10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "noAttKills", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "noPerkKills", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "loadedKills", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "multikill_2", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "killstreak_5", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "destroyed_aircraft", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "direct_hit_kills", randomintrange(1000*2,1000*10));
        self addweaponstat(GetWeapon(Gun_Unlocking), "revenge_kill", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "kill_enemy_one_bullet_sniper", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "destroy_5_killstreak_vehicle", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "backstabber_kill", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "kill_enemy_with_their_weapon", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "kill_enemy_when_injured", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "destroy_aitank_or_setinel", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "destroyed_aircraft_under20s", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "destroy_2_killstreaks_rapidly", randomintrange(1000*2,1000*10));         
        self addweaponStat(GetWeapon(Gun_Unlocking), "destroy_turret", randomintrange(1000*2,1000*10));
        self addweaponStat(GetWeapon(Gun_Unlocking), "kill_enemy_one_bullet_shotgun", randomintrange(1000*2,1000*10));
        index = GetBaseWeaponItemIndex(GetWeapon(Gun_Unlocking));
        self setdstat("itemstats", index, "plevel", 15);
        for(i = 0; i < 3; i++)
            self setdstat("itemstats", index, "isproversionunlocked", i, 1);
        wait 1;
    }
    self iPrintLnBold("^2All Camos Unlocked!");
    self thread NotifyStats();
}
MaxWeaponLevels_self()
{
    level._Weapons = StrTok("ar_standard;ar_accurate;ar_cqb;ar_damage;ar_longburst;ar_marksman;ar_fastburst;smg_standard;smg_versatile;smg_capacity;smg_fastfire;smg_burst;smg_longrange;shotgun_pump;shotgun_semiauto;shotgun_fullauto;shotgun_precision;lmg_light;lmg_cqb;lmg_slowfire;lmg_heavy;sniper_fastsemi;sniper_fastbolt;sniper_chargeshot;sniper_powerbolt;pistol_standard;pistol_burst;pistol_fullauto;launcher_standard;launcher_lockonly;knife;knife_loadout",";");
    foreach(Gun_MaxLevel in level._WeaponsMP)
    {
        self addweaponstat(GetWeapon(Gun_MaxLevel), "kills", randomintrange(1000 * 2, 1000 * 10));
        self AddRankXp("kill", GetWeapon(Gun_MaxLevel), 0, 0, true, 100000);
        wait .5;
    }
    self iPrintLnBold("^2Weapons Max Level!");
    self thread NotifyStats();
}
#endif