#ifdef MP

func_aimbot()
{
    if(!isDefined(self.aimbot))
    {
        self.aimbot = true;
        self thread func_core_aimbot();
        self iPrintln("Aimbot ^2ON");
    }
    else
    {
        self.aimbot = undefined;
        self notify("stop_aimbot");
        self iPrintln("Aimbot ^1OFF");
    }
}
func_aimbot_unfair()
{
    if(!isDefined(self.aimbot_unfair)){self.aimbot_unfair=true;self iPrintLn("Unfair Aimbot ^2ON");}
    else{self.aimbot_unfair=undefined;self iPrintLn("Unfair Aimbot ^1OFF");}
}
func_aimbot_noaim_whenAiming()
{
    if(!isDefined(self.aimbot_noads)){ self.aimbot_noads = true; self iPrintLn("Aimbot Targetting ^2ON");}
    else{ self.aimbot_noads=undefined;self iPrintLn("Aimbot Targetting ^1OFF");}
}

func_aimbot_noads()
{
    if(!isDefined(self.aimbot_noads_r)){ self.aimbot_noads_r=true; self iPrintLn("Aimbot no Aim ^2ON");}
    else{ self.aimbot_noads_r=undefined;self iPrintLn("Aimbot no Aim ^1OFF");}
}
func_core_aimbot()
{
    self endon("stop_aimbot");
    aimat = undefined;
    while( self.aimbot )
    {
        while( self adsButtonPressed() || self.aimbot_noads_r )
        {
            aimAt = undefined;
            foreach(player in level.players)
            {
                if((player == self) || (!IsAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]))
                    continue;
                if(isDefined(aimAt))
                {
                    if(closer(self GetTagOrigin("j_head"), player GetTagOrigin("j_head"), aimAt GetTagOrigin("j_head")))
                        aimAt = player;
                }
                else aimAt = player;
            }
            if(isDefined(aimAt))
            {
                if(self.aimbot_noads)
                    self setplayerangles(VectorToAngles((aimAt GetTagOrigin("j_head")) - (self GetTagOrigin("j_head"))));
                if( isDefined(self.aimbot_unfair) )
                {
                    if(self attackbuttonpressed())
                        aimAt DoDamage( aimat.health + 1, aimat GetOrigin(), self);
                }
            }
            wait .05;
        }
        wait 0.1;
    }
}

PlayTehMusic(songName)
{
    self endon("disconnect");
    self endon("game_ended");
    PlaySoundAtPosition(songName, self.origin);
    self iPrintLn("Now Playing: "+songName);
}

SpawnBotT(Count)
{
    for(i=0;i<Count;i++)
    {
        AddTestClient();
    }
    self iPrintLn("Spawned "+Count+" Bots");
}



ToggleLeft()
{
    if(!isDefined(self.LG))
    {
        self iPrintln("Ledt Sided Gun: ^2ON");
        setDvar("cg_gun_y", "8");
        self.LG = true;
    }
    else
    {
        self iPrintln("Left Sided Gun: ^1OFF");
        setDvar("cg_gun_y", "0");
        self.LG = undefined;
    }
}

ToSKY() {
    self setOrigin(self getOrigin() + (0, 0, 100000));
    S("Teleported to Sky ^2Successful");
}

skytrip()
{
    if( !(IsDefined( self.skytrip )) )
    {
        self.skytrip = 1;
        self iPrintLn("You Will now be taken on a SKY TRIP");
        firstorigin = self.origin;
        tripship    = modelSpawner( self.origin, "tag_origin");
        self playerlinkto( tripship );
        tripship moveto( firstorigin + ( 0, 0, 2500 ), 4 );
        wait 6;
        tripship moveto( firstorigin + ( 0, 4800, 2500 ), 4 );
        wait 6;
        tripship moveto( firstorigin + ( 4800, 2800, 2500 ), 4 );
        wait 6;
        tripship moveto( firstorigin + ( -4800, -2800, 7500 ), 4 );
        wait 6;
        tripship moveto( firstorigin + ( 0, 0, 2500 ), 4 );
        wait 6;
        tripship moveto( firstorigin + ( 25, 25, 60 ), 4 );
        wait 4;
        tripship moveto( firstorigin + ( 0, 0, 20 ), 1 );
        wait 1;
        tripship delete();

        self.skytrip = undefined;
    }
    else
    {
        self iprintln( "Wait For The Current Sky Trip To Finish" );
    }

}

ClownShoes()
{
    if(!isDefined(self.thesuit))
    {
        self attach("wpn_t7_care_package_world","j_ball_le");
        self attach("wpn_t7_care_package_world","j_ball_ri");
        self.thesuit = true;
        self iPrintLn("Care Package Shoes ^2ON");
        self thread ThirdPerson();
    }
    else
    {
        self detach("wpn_t7_care_package_world","j_ball_le");
        self detach("wpn_t7_care_package_world","j_ball_ri");
        self.thesuit = undefined;
        self thread ThirdPerson();
        self iPrintLn("Care Package Shoes ^1OFF");
    }
}

#ifdef ZM #include scripts\zm\_zm_audio; #endif
PlayMusicSafe(music)
{
    level notify("new_mus");
    #ifdef ZM level zm_audio::sndMusicSystem_StopAndFlush(); #endif
    
    wait .1;
    self thread CustomPlayState(music);
}

#include scripts\shared\music_shared;
CustomPlayState(music)
{
    level endon("sndStateStop");

    level.musicSystem.currentPlaytype = 4;
    level.musicSystem.currentState = music;

    wait .1;
    music::setmusicstate(music);
    
    wait .1;

    ent = spawn("script_origin", self.origin);
    ent thread DieOnNewMus(music);

    ent PlaySound(music);

    playbackTime = soundgetplaybacktime(music);
    if(!isdefined(playbackTime) || playbackTime <= 0)
    {
        waitTime = 1;
    }
    else
    {
        waitTime = playbackTime * 0.001;
    }

    wait waitTime;
    level.musicSystem.currentPlaytype = 0;
    level.musicSystem.currentState = undefined;
    level notify("end_mus");
}
playSingleSound(sound, info) {
    self endon("death");
    self endon("disconnect");
    self playSound(sound);
    if (isDefined(info))
        self iPrintLnBold(info);
}

NextSong(player, value) {
    if (!isdefined(level.nextsong))
        level.nextsong = "";

    if (!isdefined(value) || level.nextsong == value) {
        level.nextsong = "none";
        level.musicSystem.currentPlaytype = 0;
        level.musicSystem.currentState = undefined;
        level notify("end_mus");
        return;
    }
    foreach(i in level.players)
    {
        i iPrintLn("^1Now Playing: ^2"+value);
    }
    level.nextsong = value;

    self thread PlayMusicSafe(value);
}


DieOnNewMus(music)
{
    level util::waittill_any("end_game", "sndStateStop", "new_mus", "end_mus");
    self StopSounds();
    self StopSound(music);
    wait 10;
    self delete();
}

/*
#########################################
Bullet Manipulation Options for VIP's
#########################################     
*/

ToggleCustomBullets()
{
    if(!isDefined(self.CustomBullets))
    {
        self.CustomBullets = true;
        self iPrintLn("Custom Bullet Effects ^2ON");
        self thread MonitorBulletEffect();
        self.BulletEffect = "launcher_standard";
    }
    else{
        self.CustomBullets = undefined;
        self iPrintLn("Custom Bullet Effects ^1Off");
        self notify("BulletsEnded");
    }
}

ChangeBulletType(customType)
{
    self.BulletEffect = customType;
    self iPrintLn("Bullet Effect Changed To: ^2"+customType);
}

MonitorBulletEffect()
{
    self endon("BulletsEnded");
    self endon("disconnect");
    while(isDefined(self.CustomBullets))
    {
        //MagicBullet(<weapon>,<source>,<destination>,[attacker],[targetent],[targetOffset])
        self waittill( "weapon_fired" );
        if(!isDefined(self.CustomBullets))
            continue;
            MagicBullet( GetWeapon( self.BulletEffect ), self GetEye(), BulletTrace(self GetEye(), self GetEye() + AnglesToForward(self GetPlayerAngles()) * 100000, false, self)["position"], self);
        wait .025;
    }
}
#endif