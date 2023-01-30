#ifdef MP
ClientHandler(Val, Func, player)
{
    if(Func == "God")
    {
        player thread Godmode();
    }
    else if(Func == "Keys")
    {
        player thread GiveLoot3(self, false, Val);
    }
    else if(Func == "Ammo")
    {
        player thread InfiniteAmmo();
    }
    else if(Func == "TP")
    {
        player thread ThirdPerson();
    }
    else if(Func == "Perks")
    {
        player thread AllPerks();
    }
    else if(Func == "Prestige")
    {
        player SetDStat("playerstatslist", "plevel", "StatValue", Val);
    }
    else if (Func == "Unlocks")
    {
        player thread UnlockAll();
    }
    else if(Func == "Camos")
    {
        player thread UnlockCamos_self();
    }
    else if(Func == "Weapons")
    {
        player thread MaxWeaponLevels_self();
    }
    else if(Func == "Cheevos")
    {
        player thread UnlockAchievements();
    }
    else if(Func == "Heros")
    {
        player thread UnlockSpecials();
    }
    else if (Func == "Rank")
    {
        player thread SetRank(Val);
    }
    else if(Func == "L55")
    {
        player thread SetRank(55);
    }
    else if(Func == "Kick")
    {
        if(!player IsHost())
        {
            kick(player GetEntityNumber());
        }
        else{
            self iPrintLn("Host Cannot Be Kicked"); level.players[0] iPrintLn(self.name+" Tried To Kick You");
        }
    }
    else if(Func == "Ban")
    {
         if(!player IsHost())
        {
            ban(player GetEntityNumber());
        }
        else{
            self iPrintLn("Host Cannot Be Banned"); level.players[0] iPrintLn(self.name+" Tried To Ban You");
        }
    }
    else if(Func == "KLoop")
    {
        player thread KeysLoopOrig();
    }
    else if(Func == "KeysL")
    {
        player thread GiveLoot2(Val);
    }
    else if(Func == "Lock")
    {
        player thread _LockMenu();
    }
    else if(Func == "Unlock")
    {
        player thread _UnlockMenu();
    }
}

FreezePlayer(player)
{
    if(!isDefined(player.frozen))
    {
        player FreezeControls(true);
        player.frozen = true;
        player iPrintLnBold("Your Controls Have Been ^1Frozen!");
    }
    else
    {
        player FreezeControls(false);
        player.frozen = undefined;
        player iPrintLnBold("Your controls have been ^2Unfrozen");
    }
}


TagSliderCli(Val, player)
{
    if(Val == 0){ player setDStat("clanTagStats", "clanName", "3arc"); player S("Clan Tag Set To: ^23arc");}
    else if(Val == 1){ player setDStat("clanTagStats", "clanName", "{SY}"); player S("Clan Tag Set To: Unbound");}
    else if(Val == 2){player setDstat("clanTagStats", "clanName", "FUCK");player S("Clan Tag Set To: ^2FUCK");}
    else if(Val == 3){player setDstat("clanTagStats", "clanName", "PORN");player S("Clan Tag Set To ^2PORN");}
    else if(Val == 4){player setDstat("clanTagStats", "clanName", "{IW}");player S("Clan Tag Set To: ^2{IW}");}
    else if(Val == 5){player setDstat("clanTagStats", "clanName", "^1"); player S("Clan Tag Set To: ^1RED");}
    else if(Val == 6){player setDstat("clanTagStats", "clanName", "^2");player S("Clan Tag Set To: ^2Green");}
    else if(Val == 7){player setDstat("clanTagStats", "clanName", "^3");player S("Clan Tag Set To: ^3Yellow");}
    else if(Val == 8){player setDStat("clanTagStats", "clanName", "^4");player S("Clan Tag Set To ^4Dark Blue");}
    else if(Val == 9){player setDStat("clanTagStats", "clanName", "^5");player S("Clan Tag Set To: ^5Cyan");}
    else if(Val == 10){player setDStat("clanTagStats", "clanName", "^6");player S("Clan Tag Set To: ^6Pink");}
    else if(Val == 11){player setDStat("clanTagStats", "clanName", "^I\xFF\xFF");player S("Clan Tag Set To: ^2Glitchy Box");}
}//Go to 11 with Clan Tags, till we make a custom Clan Tag Editor

ClanTagCli(Tag, player)
{
    if(Tag == "Red"){ player setDStat("clanTagStats", "clanName", "^1IW"); player iPrintLnBold("Clan Tag Set To ^1Red");}
    else if(Tag == "Green"){ player setDStat("clanTagStats", "clanName", "^2IW"); player iPrintLnBold("Clan Tag Set To ^2Green");}
    else if(Tag == "Yellow"){ player setDStat("clanTagStats", "clanName", "^3IW"); player iPrintLnBold("Clan Tag Set To ^3Yellow");}
    else if(Tag == "DB"){ player setDStat("clanTagStats", "clanName", "^4IW"); player iPrintLnBold("Clan Tag Set To ^4Dark Blue");}
    else if(Tag == "Cyan"){ player setDStat("clanTagStats", "clanName", "^5IW"); player iPrintLnBold("Clan Tag Set To ^5Cyan");}
    else if(Tag == "Pink"){ player setDStat("clanTagStats", "clanName", "^6IW"); player iPrintLnBold("Clan Tag Set To ^6Pink");}
    else if(Tag == "Box"){ player setDStat("clanTagStats", "clanName", "^I\xFF\xFF"); player iPrintLnBold("Clan Tag Set To Box");}
    else{ player setDStat("clanTagStats", "clanName", Tag); player iPrintLnBold("Clan Tag Set To ^2"+Tag);}
}

ClientPrestige(Val, player)
{
    player SetDStat("playerstatslist", "plevel", "StatValue", Val);
    level.players[0] iPrintLn(player.name+" Has Been Set To Prestige: "+val);
    player iPrintLn("Prestige Set To: "+Val);
}
AllHandler(Func)
{
    if(Func == "AllGod")
    {
        foreach(Client in level.players)
        {
            Client thread Godmode();
        }
    }
    else if(Func == "AllAmmo")
    {
        foreach(client in level.players)
        {
            client thread InfiniteAmmo();
        }
    }
    else if(Func == "AllCPerks")
    {
        foreach(client in level.players)
        {
            client thread AllPerks();
        }
    }
    else if(Func == "FreezeAll")
    {
        foreach(client in level.players)
        {
            client thread FreezeAll();
        }
    }
}

FreezeAll()
{
    if(!isDefined(self.frozen))
            {
                self FreezeControls(true);
                self iPrintLn("Controls have been ^1FROZEN");
                self.frozen = true;
            }
            else
            {
                self freezecontrols(false);
                self iPrintLn("Controls have been ^2UnFrozen");
                self.frozen = undefined;
            }
}
    #endif