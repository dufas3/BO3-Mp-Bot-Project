#ifdef MP
EditJumpHeight(Val)
{
    SetJumpHeight(Val);
    self SetClientDvar("jump_height", Val);
    self iPrintLn("Jump Height Set To: ^2"+Val);
}

EditGravity(Val)
{
    SetGravity(Val);
    self SetClientDvar("g_gravity", Val);
    self iPrintLn("Gravity Set To: ^2"+Val);
}

EditGameSpeed(Val)
{
    self SetClientDvar("g_speed", Val);
    self iPrintLn("Game Speed Set To: ^2"+Val);
}

EditTimescale(Val)
{
    self SetClientDvar("com_timescale", Val);
    self iPrintLn("Timescale Set To: ^2"+Val);
}

EditFOV(Val)
{
    self SetClientDvar("cg_fov_default", Val);
    self iPrintLn("FOV Set To: ^2"+Val);
}

EditGunX(Val)
{
    self SetClientDvar("cg_gun_x", Val);
    self iPrintLn("Gun X Coords Set To: ^2"+Val);
}

EditGunY(Val)
{
    self SetClientDvar("cg_gun_y", Val);
    self iPrintLn("Gun Y Coords To: ^2"+Val);
}

EditGunZ(Val)
{
    self SetClientDvar("cg_gun_z", Val);
    self iPrintLn("Gun Z Coords To: ^2"+Val);
}
PrintGametype()
{
    CurrentGameMode = GetDvarString("ui_gametype");
    self iPrintLn(CurrentGameMode);
}

Endgame()
{
    level notify("game_ended");
    self iPrintLnBold(level.hostname+" Ended the Game");
}
ChangeGametype(gametype)
{
    if(level.gametype == gametype)
        return self iprintln("Gametype is already ^5"+ gametype);

    level.gametype = gametype;
    setDvar("ui_gametype", gametype);
    setDvar("g_gametype", gametype);
    setDvar("ls_gametype", gametype);
    setDvar("party_gametype", gametype);
    self iPrintLn("GameMode is being changed to: ^2"+gametype);
    wait 3;
    map_restart(true);
}
SetClientDvar(Dvar, Val)
{
    for(i=0;i<GetPlayers().size;i++)
    {
        SetDvar(Dvar,Val);
    }
}

initCampKill()
{
    if(!isDefined(level.campKillOn))
    {
        foreach(player in level.players)
        {
            player thread doCampKill();
            level.campKillOn = true;
        }
        self iPrintLn("Anti-Camp ^2Enabled");
    }
    else
    {
        foreach(player in level.players)
        {
            player notify("stop_campKill");
            player notify("stop_noCamp");
            level.campKillOn = undefined;
        }
        self iPrintLn("Anti-Camp ^1Disabled");
    }
}

doCampKill()
{
    self endon("disconnect");
    self endon("stop_campKill");
    for(;;)
    {
        self.OldOrigin = self.origin;
        wait 10;
        self.NewOrigin = self.origin;
        
        if(Distance(self.OldOrigin, self.NewOrigin) < 20)
        {
            if(!isDefined(self.CampKillStart))
            {
                self.CampKillStart = 1;
                self iPrintlnbold("^1" + self.name + "^1, stop camping in 10 Seconds!");
                self thread nextOriginCamp();
            }
        }
    }
}
countCampSet(time, patt)
{
    self.NewOrigin = self.origin;
    if(patt == 0)
    {
        if(Distance(self.OldOrigin, self.NewOrigin) < 20)
            self iPrintlnBold("^1" + self.name + "^1, Stop Camping or Face Death " + time + " Seconds!");
        else
        {
            self.CampKillStart = undefined;
            self notify("stop_noCamp");
        }
    }
    else if(patt == 1)
    {
        if(Distance(self.OldOrigin, self.NewOrigin) < 20)
        {
            self suicide();
            iPrintlnBold("^1" + self.name + " ^2Got Killed Due To Camping.");
        }
        else
        {
            self.CampKillStart = undefined;
            self notify("stop_noCamp");
        }
        wait 3;
        self.CampKillStart = undefined;
        self notify("stop_noCamp");
    }
}
nextOriginCamp()
{
    self endon("stop_noCamp");
    for(;;)
    {
        wait 1;
        self countCampSet("9", 0);
        wait 1;
        self countCampSet("8", 0);
        wait 1;
        self countCampSet("7", 0);
        wait 1;
        self countCampSet("6", 0);
        wait 1;
        self countCampSet("5", 0);
        wait 1;
        self countCampSet("4", 0);
        wait 1;
        self countCampSet("3", 0);
        wait 1;
        self countCampSet("2", 0);
        wait 1;
        self countCampSet("1", 0);
        wait 1;
        self countCampSet("", 1);
    }
}
UnlimitedGameTimer()
{
    if(!isDefined(level.GameTime)){
        level.GameTime = true;
    self thread pauseTimer2(1);
    self iPrintln("Infinite Game : ^2ON");
}
else{
    level.GameTime = undefined;
    self thread resumeTimer2();
    self iPrintLn("Infinite Game ^1Off");
}
}

pauseTimer2(pausePlayableTimer)
{
    if(!isdefined(pausePlayableTimer))
    {
        pausePlayableTimer = 0;
    }
    level.playableTimerStopped = pausePlayableTimer;
    if(level.timerStopped)
    {
        return;
    }
    level.timerStopped = 1;
    level.timerPauseTime = GetTime();
}

resumeTimer2()
{
    if(!level.timerStopped)
    {
        return;
    }
    level.timerStopped = 0;
    level.playableTimerStopped = 0;
    level.discardTime = level.discardTime + GetTime() - level.timerPauseTime;
}
#endif