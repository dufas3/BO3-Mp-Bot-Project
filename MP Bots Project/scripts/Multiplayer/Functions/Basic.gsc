#ifdef MP
BeginInfiniteAmmo()
{
    self endon("stop_ammo");
    self endon("game_ended");
    
    for(;;)
    {
        weapon_Ammo = self GetCurrentWeapon();
        self waittill("weapon_fired");
        self SetWeaponAmmoClip(weapon_Ammo, 999);
        self SetWeaponAmmoStock(weapon_Ammo, 999);
    }
}

InfiniteAmmo()
{
    if(!isDefined(self.Ammo))
    {
        self.Ammo = true;
        self thread BeginInfiniteAmmo();
        self iPrintLnBold("Infinite Ammo ^2Enabled");
    }
    else
    {
        self.Ammo = undefined;
        self notify("stop_ammo");
        self iPrintLnBold("Infinite Ammo ^1Disabled");
    }
}

Godmode()
{
    self.godmode = !bool(self.godmode);
    if(self.godmode)
        self EnableInvulnerability();
    else
        self DisableInvulnerability();
}
    
NoClip()
{
    if(!isDefined(self.noclip))
    {
        self thread func_activeNC();
        self.noclip = true;
        self iPrintln("No Clip ^2ON");
        self iPrintln("Press [{+attack}] To Fly");
    }
    else
    {
        self notify("func_noclip_stop");
        self.noclip = undefined;
        self iPrintln("No Clip ^1OFF");
    }
}
func_activeNC()
{
    self endon("func_noclip_stop");
    self.Fly = 0;
    UFO = spawn("script_model",self.origin);
    for(;;)
    {
        if(self AttackButtonPressed())
        {
            self playerLinkTo(UFO);
            self.Fly = 1;
        }
        else
        {
            self unlink();
            self.Fly = 0;
        }
        if(self.Fly == 1)
        {
            Fly = self.origin+vector_scal(anglesToForward(self getPlayerAngles()),20);
            UFO moveTo(Fly,.01);
        }
        wait .001;
    }
}

vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

ThirdPerson()
{
    if(!isDefined(self.thirdPerson))
    {
        self SetClientThirdPerson( 1 );
        self SetClientThirdPersonAngle( 354 );
        self iPrintLn("Third Person Mode ^2ON");
        self.thirdPerson = true;
    }
    else
    {
        self SetClientThirdPerson( 0 );
        self SetClientThirdPersonAngle( 0 );
        self iPrintLn("Third Person Mode ^1OFF");
        self.thirdPerson = undefined;
    }
}

AllPerks()
{
    perks = strtok("specialty_flakjacket,specialty_nottargetedbyairsupport,specialty_gpsjammer,specialty_stunprotection,specialty_showenemyequipment,specialty_nottargetedbyaitank,specialty_immunecounteruav,specialty_sprintfire,specialty_fastweaponswitch,specialty_scavenger,specialty_jetquiet,specialty_loudenemies,specialty_quieter", ",");
    foreach( perk in perks )
        self setperk( perk );
    S("All Perks ^2Given");
    self.AllPerks = true;
}

func_doGivePerk(perk)
{
    if(self HasPerk(perk))
    {
        S("^1You already have this perk!");
        return;
    }
    self setperk( perk );
    S(perk+" ^2Given");
}

teleportWithSelector(player)
{
    currentWeapon = self GetCurrentWeapon();
    self beginLocationSelection("map_mortar_selector");
 
    self DisableOffhandWeapons();
    self GiveWeapon(GetWeapon("killstreak_remote_turret"));
    self SwitchToWeapon(GetWeapon("killstreak_remote_turret"));

    self.selectingLocation = true;
    location = self func_waittill_confirm_location();

    if ( !isdefined( location ) )
    {
        self IPrintLn("^1Not able to get any origin!");
        return false;
    }

    player SetOrigin( location );
    self EndLocationSelection();
    self EnableOffhandWeapons();
    self SwitchToWeapon(currentWeapon);
    self.selectingLocation = undefined;

    self iprintln("You teleported ^2"+player.name);
}
func_waittill_confirm_location()
{
    self endon( "emp_jammed" );
    self endon( "emp_grenaded" );

    self waittill( "confirm_location", location );
 
    return location;
}
#endif