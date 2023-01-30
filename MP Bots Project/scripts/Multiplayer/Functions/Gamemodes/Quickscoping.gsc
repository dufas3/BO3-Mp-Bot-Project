#ifdef MP
onQuickScopeConnect()
{
    self endon("mode_changed");
    level endon("game_ended");

    for(;;)
    {
        level waittill("connected", player);
        player thread onQuickScopeSpawned();
        level.ingraceperiod = 0;
        level.loadoutkillstreaksenabled = 0;
    }
}

QSClass()
{
    
    if(!isDefined(self.sniper))
    {
                //Weap = self GetCurrentWeapon();
                //self TakeWeapon(Weap, 1);
                //wait 1;
                //Weap2 = self GetCurrentWeapon();
                //self TakeWeapon(Weap2, 1);
                //wait 1;
                //self givewonder("sniper_fastbolt");
                ////self GiveWeapon("pistol_standard_mp", 0,0);
                //self GiveMaxAmmo("sniper_fastbolt");
        self.sniper = true;
            //rdamn       = RandomIntRange(0,45);
        self TakeAllWeapons();
        wait .05;
        self givewonder("sniper_fastbolt");
    }
    else if(self.sniper==true)
    {
               // Weap = self GetCurrentWeapon();
                //self TakeWeapon(Weap, 1);
                //wait 1;
            //Weap2 = self GetCurrentWeapon();
            //self TakeWeapon(Weap2, 1);
            //wait 1;
            //self givewonder("sniper_heavybolt");
            //self GiveWeapon("pistol_standard_mp", 0,0);
            //self GiveMaxAmmo("sniper_heavybolt");
        self.sniper = undefined;
        self TakeAllWeapons();
        wait .05;
        self givewonder("sniper_powerbolt");
            //self giveweapon("hatchet_mp");
            //self setWeaponAmmoStock("hatchet_mp",2);
    }
    self iPrintLn("Class Given");
}
award_weapon(weapon)
{
    self TakeAllWeapons();
        self GiveWeapon(weapon);
        self givemaxammo(weapon);
        self switchtoweapon(weapon);
 self iPrintLnBold("Weapon ^2Given^7!");
}

TW(message)
{
    self hud_message::hintMessage(message);
}

SW(message)
{
    self hud_message::notifyMessage(message);
}
onQuickScopeSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    self endon("mode_changed");
    while(level.inPrematchPeriod)
    {
        wait 1;
    }
    wait .5;
    Spawnedfirst = true;
    
    level.ingraceperiod = 0;
    level.disableweapondrop = 1;
    
    for(;;)
    {
        self waittill("spawned_player");
        self.maxhealth=65;
        self.health=65;
        self thread QSClass();
        self setclientuivisibilityflag("g_compassShowEnemies",1);
        
        if(Spawnedfirst)
        {
            Spawnedfirst = false;
            self thread TW("^1Synergy's Quickscope Lobby'");
        }

        self thread xScope();
        self thread runControllerMonitor();
         
        self clearperks();
        self setperk("specialty_additionalprimaryweapon");
        self setperk("specialty_armorpiercing");
        self setperk("specialty_armorvest");
        self setperk("specialty_bulletaccuracy");
        self setperk("specialty_bulletdamage");
        self setperk("specialty_bulletflinch");
        self setperk("specialty_bulletpenetration");
        self setperk("specialty_deadshot");
        self setperk("specialty_delayexplosive");
        self setperk("specialty_detectexplosive");
        self setperk("specialty_disarmexplosive");
        self setperk("specialty_explosivedamage");
        self setperk("specialty_extraammo");
        self setperk("specialty_fallheight");
        self setperk("specialty_fastads");
        self setperk("specialty_fastequipmentuse");
        self setperk("specialty_fastladderclimb");
        self setperk("specialty_fastmantle");
        self setperk("specialty_fastmeleerecovery");
        self setperk("specialty_fastreload");
        self setperk("specialty_fasttoss");
        self setperk("specialty_fireproof");
        self setperk("specialty_flakjacket");
        self setperk("specialty_flashprotection");
        self setperk("specialty_grenadepulldeath");
        self setperk("specialty_healthregen");
        self setperk("specialty_holdbreath");
        self setperk("specialty_immunecounteruav");
        self setperk("specialty_immuneemp");
        self setperk("specialty_immunemms");
        self setperk("specialty_immunenvthermal");
        self setperk("specialty_immunerangefinder");
        self setperk("specialty_longersprint");
        self setperk("specialty_loudenemies");
        self setperk("specialty_marksman");
        self setperk("specialty_movefaster");
        self setperk("specialty_noname");
        self setperk("specialty_nottargetedbyairsupport");
        self setperk("specialty_nokillstreakreticle");
        self setperk("specialty_nottargettedbysentry");
        self setperk("specialty_pin_back");
        self setperk("specialty_proximityprotection");
        self setperk("specialty_quickrevive");
        self setperk("specialty_quieter");
        self setperk("specialty_reconnaissance");
        self setperk("specialty_rof");
        self setperk("specialty_showenemyequipment");
        self setperk("specialty_stunprotection");
        self setperk("specialty_shellshock");
        self setperk("specialty_sprintrecovery");
        self setperk("specialty_twogrenades");
        self setperk("specialty_twoprimaries");
        self setperk("specialty_unlimitedsprint");
    }
}

xScope()
{
    self endon("mode_changed");
    self endon("disconnect");
    self endon("death");
    self endon("game_ended");

    for(;;)
    {
        if(self AdsButtonPressed())
        {
            wait 0.4;
            self allowADS(0);
            wait 0.2;
            self allowADS(1);
        }
        wait 0.3;
    }
}

runControllerMonitor()
{
    self endon("mode_changed");
    level endon("game_ended");
    self endon("disconnect");
    self endon("death");

    for(;;)
    {
        if(self meleeButtonPressed())
        {
            self iPrintlnBold( "^0NO ^1f***ING ^0KNIFING^1!^0!^1!" );
            wait 0.25;
        }
        wait 0.05;
    }
}

Monitorbitch()
{
    foreach (player in level.players)
    {
        player thread onQuickScopeSpawned();
        player Suicide();
        wait 2;
        
    }
}
#endif