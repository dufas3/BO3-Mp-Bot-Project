#ifdef MP
SetCustomGametype(Gametype)
{
    if(isDefined(Gametype) && self isHost())
    {
        if(Gametype == "QSNS")
        {
            
            self notify("mode_changed");
            wait 1;
            level.CustomGametype = "QSNS";
            self iPrintLn("Changing Gamemode to QSNS");
            self menuClose();
            wait 2;
            level thread onQuickScopeConnect();
            level.ingraceperiod = 0;
            level thread Monitorbitch();
        }
        else if(Gametype == "AoN")
        {
            self notify("mode_changed");
            wait 1;
            level.CustomGametype = "AoN";
            self iPrintLn("Changing Gamemode to All or Nothing");
            self menuClose();
            wait 2;
            level.ingraceperiod = 0;
            level thread AoNConn();
        }
    }
}

givewonder(Weapon_Name)
 {
    Weapon5 = self GetCurrentWeapon();
    self TakeWeapon(Weapon5);
    Weapon4 = GetWeapon(Weapon_Name);
    self GiveWeapon(Weapon4);
    self SwitchToWeapon(Weapon4);
 }
#endif