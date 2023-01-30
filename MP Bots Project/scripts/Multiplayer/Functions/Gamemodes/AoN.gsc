#ifdef MP
AoNConn()
{
    self endon("mode_changed");
    foreach(player in level.players)
    {
        player thread onAONSpawned();
        player Suicide();
        level.ingraceperiod = 0;
        level.loadoutkillstreaksenabled = 0;
        level.disableweapondrop = 1;
    }
}

onAONSpawned()
{
    self endon("mode_changed");
    self endon("disconnect");
    level endon("game_ended");
    
    Spawned = true;
    
    level.ingraceperiod = 0;
    
    for(;;)
    {
        self waittill("spawned_player");
        self thread AON();
        self thread AoNClasses();
        self thread AONdoKills();
        self.pers["kills"] = 0;
        
        if(Spawned)
        {
            Spawned = false;
            self thread TW("Welcome, "+self.name+"! To All or Nothing");
        }
    }
}
AoNClasses()
{
    self endon("mode_changed");
    //Weap = self GetCurrentWeapon();
    //self TakeWeapon(Weap, 1);
    self TakeAllWeapons();
    wait 1;
    //Weap2 = self GetCurrentWeapon();
    //self TakeWeapon(Weap2, 1);
    self givewonder("pistol_burst");
    //self GiveWeapon("pistol_standard_mp", 0,0);
    self GiveMaxAmmo("pistol_burst");
    self iPrintLn("You Should now have a Pistol");
}

AON()
{
    self endon("mode_changed");
    self endon ("disconnect");
    self endon ("death");
    level endon("game_ended");
    
    self clearPerks();
    wait .05;
    
    self setperk("specialty_stalker");
    self setperk("specialty_longersprint");
    self setperk("specialty_fastreload");
    self setperk("specialty_fallheight");
    
    self thread doKillstreaksAoN(); 
    wait 1;
    
    while(self getCurrentWeapon() != "pistol_burst")
    {
        self switchToWeapon("pistol_burst");
        wait 0.1;
    }
    self.maxhealth = 100;
    self.health = self.maxhealth;
}
doKillstreaksAoN()
{
    self endon("mode_changed");
    self endon ("death");
    self endon ("disconnect");
    level endon("game_ended");
    self endon("Kills");

    for(;;)
    {
        if(self.pers["kills"] == 1)
        {
            self iPrintlnBold( "^5Unlocked ^2Scavenger!" );
            self setperk("specialty_scavenger");
            self notify("Kills");
        }
        if(self.pers["kills"] == 3)
        {
            self iPrintlnBold( "^5Unlocked ^2Quickdraw!" );
            self setperk("specialty_fastads");
            self setperk("specialty_fastequipmentuse");
            self notify("Kills");
        }
        if(self.pers["kills"] == 5)
        {
            self iPrintlnBold( "^5Unlocked ^2Steady Aim!" );
            self setperk("specialty_bulletaccuracy");
            self setperk("specialty_sprintrecovery");
            self notify("Kills");
        }
        if(self.pers["kills"] == 7)
        {
            self iPrintlnBold( "^5Unlocked ^3all perks!" );
            self setperk("specialty_armorpiercing");
            self setperk("specialty_armorvest");
            self setperk("specialty_bulletdamage");
            self setperk("specialty_bulletflinch");
            self setperk("specialty_bulletpenetration");
            self setperk("specialty_deadshot");
            self setperk("specialty_fastladderclimb");
            self setperk("specialty_fastmantle");
            self setperk("specialty_fastmeleerecovery");
            self setperk("specialty_fasttoss");
            self setperk("specialty_healthregen");
            self setperk("specialty_loudenemies");
            self setperk("specialty_marksman");
            self setperk("specialty_movefaster");
            self setperk("specialty_noname");
            self setperk("specialty_quieter");
            self setperk("specialty_reconnaissance");
            self notify("Kills");
        }
        wait 0.05;
    }
}

AONdoKills()
{
    self endon("mode_changed");
    self endon("death");
    level endon("game_ended");
    self.PreviousKills = self.pers["kills"];
    for(;;)
    {
        if(self.pers["kills"] > self.PreviousKills)
        {
            self.PreviousKills = self.pers["kills"];
            self thread doKillstreaksAoN();
        }
        wait .1;
    }
}

doTehWelcomeAoN(Text1, Text2, Glow, Icon, Duration)
{
    Welcome=spawnstruct();
    Welcome.titleText=Text1;
    Welcome.notifyText=Text2;
    Welcome.iconName=Icon;
    Welcome.glowColor=Glow;
    Welcome.duration=Duration;
    Welcome.font="default";
    Welcome.hideWhenInMenu = false;
    Welcome.archived = true;
    self SW(Welcome);
}
#endif