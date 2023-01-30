#ifdef MP
MenuSave()
{
    SaveDesgin = 
        SetMenuBool(self.menuSetting["MenuFreeze"]) +";"+
        SetMenuBool(self.menuSetting["MenuStealth"]) +";"+
        (self.menuSetting["BannerGradRainbow"] != "rainbow" ? 0 : "1") +";"+
        (self.menuSetting["ScrollerGradRainbow"] != "rainbow" ? 0 : "1") +";"+
        (self.menuSetting["BackgroundGradRainbow"] != "rainbow" ? 0 : "1") +";"+
        (self.menuSetting["BannerNoneRainbow"] != "rainbow" ? 0 : "1") +";"+
        round(self.menuSetting["ScrollerGradColor0"]) +";"+
        round(self.menuSetting["ScrollerGradColor1"]) +";"+
        round(self.menuSetting["ScrollerGradColor2"]) +";"+
        round(self.menuSetting["BackgroundGradColor0"]) +";"+
        round(self.menuSetting["BackgroundGradColor1"]) +";"+
        round(self.menuSetting["BackgroundGradColor2"]) +";"+
        round(self.menuSetting["BannerNoneColor0"]) +";"+
        round(self.menuSetting["BannerNoneColor1"]) +";"+
        round(self.menuSetting["BannerNoneColor2"]) +";"+
        round(self.menuSetting["BannerGradColor0"]) +";"+
        round(self.menuSetting["BannerGradColor1"]) +";"+
        round(self.menuSetting["BannerGradColor2"]) +";"+
        self.menuSetting["MenuX"] +";"+
        self.menuSetting["MenuY"] +";"+
        SetMenuBool(self.menuSetting["MenuGodmode"]) +";"+
        SetMenuBool(self.menuSetting["ShowClientINFO"]);
    
    setDvar(self getName() + "MenuDesign", SaveDesgin);
}

MenuLoad(Val)
{  
    if(!isdefined(self.menuSetting))
        self.menuSetting = [];
        
    MenuDefaults = strTok("0;1;1;1;0;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;1",";");
    
    if(!IsDefined(Val) || IsDefined(Val) && Val == 0)
    {
        
        if(GetDvarString(self getName() + "MenuDesign").size > 0)
        {
            dvar         = GetDvarString(self getName() + "MenuDesign"); 
            MenuDefaults = strTok(dvar, ";");
        }
    }
    
    self.menuSetting["MenuFreeze"] = GetMenuBool(MenuDefaults[0]);
    self.menuSetting["MenuGodmode"] = GetMenuBool(MenuDefaults[20]);
    self.menuSetting["MenuStealth"] = GetMenuBool(MenuDefaults[1]);
    self.menuSetting["ShowClientINFO"] = GetMenuBool(MenuDefaults[21]);
    
    self.menuSetting["ScrollerGradColor0"] = int(MenuDefaults[6]);
    self.menuSetting["ScrollerGradColor1"] = int(MenuDefaults[7]);
    self.menuSetting["ScrollerGradColor2"] = int(MenuDefaults[8]);
    
    self.menuSetting["BackgroundGradColor0"] = int(MenuDefaults[9]);
    self.menuSetting["BackgroundGradColor1"] = int(MenuDefaults[10]);
    self.menuSetting["BackgroundGradColor2"] = int(MenuDefaults[11]);
    
    self.menuSetting["BannerNoneColor0"] = int(MenuDefaults[12]);
    self.menuSetting["BannerNoneColor1"] = int(MenuDefaults[13]);
    self.menuSetting["BannerNoneColor2"] = int(MenuDefaults[14]);
    
    self.menuSetting["BannerGradColor0"] = int(MenuDefaults[15]);
    self.menuSetting["BannerGradColor1"] = int(MenuDefaults[16]);
    self.menuSetting["BannerGradColor2"] = int(MenuDefaults[17]);
    
    self.menuSetting["BannerGradRainbow"] = (MenuDefaults[2] == "1" ? "rainbow" : (GetFloatString(MenuDefaults[15]), GetFloatString(MenuDefaults[16]), GetFloatString(MenuDefaults[17])));
    self.menuSetting["ScrollerGradRainbow"] = (MenuDefaults[3] == "1" ? "rainbow" : (GetFloatString(MenuDefaults[6]), GetFloatString(MenuDefaults[7]), GetFloatString(MenuDefaults[8])));
    self.menuSetting["BackgroundGradRainbow"] = (MenuDefaults[4] == "1" ? "rainbow" : (GetFloatString(MenuDefaults[9]), GetFloatString(MenuDefaults[10]), GetFloatString(MenuDefaults[11])));
    self.menuSetting["BannerNoneRainbow"] = (MenuDefaults[5] == "1" ? "rainbow" : (GetFloatString(MenuDefaults[12]), GetFloatString(MenuDefaults[13]), GetFloatString(MenuDefaults[14])));
    
    self.menuSetting["MenuX"] = int(MenuDefaults[18]);
    self.menuSetting["MenuY"] = int(MenuDefaults[19]);
    
    if(IsDefined(Val) && Val == 1 || IsDefined(Val) && Val == 0)
    {
        self menuClose();
        waittillframeend;
        self menuOpen();
    }
}

GetMenuBool(String)
{
    return (String == "1" ? true : false);
}

SetMenuBool(variable)
{
    return (isdefined(variable) && int(variable) ? "1" : "0");
}

FreezeInMenu()
{
    self.menuSetting["MenuFreeze"] = !bool(self.menuSetting["MenuFreeze"]);
    self FreezeControls(self.menuSetting["MenuFreeze"] ? true : false);
}

MenuStealth()
{
    self.menuSetting["MenuStealth"] = !bool(self.menuSetting["MenuStealth"]);
}

MenuGodmode()
{
    self.menuSetting["MenuGodmode"] = !bool(self.menuSetting["MenuGodmode"]);
}

ShowClientINFO()
{
    self.menuSetting["ShowClientINFO"] = !bool(self.menuSetting["ShowClientINFO"]);
}

MoveMenu()
{
    self menuClose();
    
    MenuVisTemp = [];
    
    MenuVisTemp["BG"] = self createRectangle("TOPLEFT", "TOP", -425, 90, 170, int(8*15) + 45, (0,0,0), "white", 0, .6, true);
    MenuVisTemp["TITLE"] = self createText("default", 1.5, "CENTER", "TOP", -340, 105, 0, 1, "Menu Reposition", (1, 1, 1), true);
    MenuVisTemp["INFO0"] = self createText("default", 1.2, "CENTER", "CENTER", -340, -75, 0, 1, "Movement Controls", (1, 1, 1), true);
    MenuVisTemp["INFO1"] = self createText("default", 1, "CENTER", "CENTER", -340, -40, 0, 1, "UP - [{+attack}] DOWN - [{+speed_throw}]", (1, 1, 1), true);
    MenuVisTemp["INFO2"] = self createText("default", 1, "CENTER", "CENTER", -340, -30, 0, 1, "LEFT - [{+actionslot 4}] RIGHT - [{+actionslot 3}]", (1, 1, 1), true);
    MenuVisTemp["INFO3"] = self createText("default", 1, "CENTER", "CENTER", -340, 0, 0, 1, "CONFIRM PLACEMENT - [{+activate}]", (1, 1, 1), true);
    MenuVisTemp["INFO4"] = self createText("default", 1, "CENTER", "CENTER", -340, 10, 0, 1, "DISCARD CHANGES - [{+melee}]", (1, 1, 1), true);
    
    X = self.menuSetting["MenuX"];
    Y = self.menuSetting["MenuY"];
    
    while(self useButtonPressed())
        wait .05;
    
    while(!self meleeButtonPressed())
    {
        if(self attackButtonPressed())
        {
            Y += 10;
            foreach(HUD in MenuVisTemp)
                HUD.y += 10;
                
            wait .15;
        }
            
        if(self adsButtonPressed())
        {
            Y -= 10;
            foreach(HUD in MenuVisTemp)
                HUD.y -= 10;
                
            wait .15;
        }
       
        if(self ActionSlotThreeButtonPressed())
        {
            X += 10;
            foreach(HUD in MenuVisTemp)
                HUD.x += 10;
                
            wait .15;
        }
            
        if(self ActionSlotFourButtonPressed())
        {
            X -= 10;
            foreach(HUD in MenuVisTemp)
                HUD.x -= 10;
                
            wait .15;
        }
        
        if(self useButtonPressed())
        {
            self.menuSetting["MenuX"] = X;
            self.menuSetting["MenuY"] = Y;
            break;
        }
        
        wait .05;
    }
    
    while(self useButtonPressed() || self meleeButtonPressed())
        wait .05;
    
    self destroyAll(MenuVisTemp);
    self menuOpen();
}

MenuToggleRainbow(HUD)
{
    if(HUD == "Banner")
    {
        self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneRainbow" : "GradRainbow")] = (IsString(self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneRainbow" : "GradRainbow")]) ? 0 : "rainbow");
 
        if(!IsString(self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneRainbow" : "GradRainbow")]))
        {
            for(e=0;e<3;e++)
                self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneColor" : "GradColor") + e] = level.rainbowColour[e];
                
            self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneRainbow" : "GradRainbow")] = "rainbow";
        }
        
        if(IsString(self.menuSetting["BannerNoneRainbow"]))
            self.menu["UI"]["BGTitle"] thread doRainbow(true);
            
        if(IsString(self.menuSetting["BannerGradRainbow"]))
            self.menu["UI"]["BGTitle_Grad"] thread doRainbow(true);
    } 
    else
    {
        self.menuSetting[HUD + "GradRainbow"] = (IsString(self.menuSetting[HUD + "GradRainbow"]) ? 0 : "rainbow");
  
        if(!IsString(self.menuSetting[HUD + "GradRainbow"]))
        {
            for(e=0;e<3;e++)
                self.menuSetting[HUD + "GradColor" + e] = level.rainbowColour[e];
                
            self.menuSetting[HUD + "GradRainbow"] = "rainbow";
        }
        
        if(IsString(self.menuSetting["ScrollerGradRainbow"]))
            self.menu["UI"]["SCROLL"] thread doRainbow(true);
            
        if(IsString(self.menuSetting["BackgroundGradRainbow"]))
            self.menu["UI"]["OPT_BG"] thread doRainbow(true);
    }
}

MenuPreSetCol(Val,HUD,Bool)
{
    Size    = (HUD == "Banner" ? 1 : 0);
    SizeMax = (HUD == "Banner" ? 4 : 3);
    menu    = self getCurrentMenu();
    
    if(!IsDefined(Bool))
    {
        RGB = GetPresetColours(Val);
        for(e=Size;e<SizeMax;e++)
            if(IsDefined(self.sliders[menu + "_" + e]))
                self.sliders[menu + "_" + e] = undefined;
    }
    else
    {
        for(e=Size;e<SizeMax;e++)
            if(!IsDefined(self.sliders[menu+"_"+e]))
                self.sliders[menu + "_" + e] = 0;
        
        RGB = (HUD == "Banner" ? (self.sliders[menu + "_1"] / 255, self.sliders[menu + "_2"] / 255, self.sliders[menu+"_3"] / 255) : (self.sliders[menu + "_0"] / 255, self.sliders[menu + "_1"] / 255, self.sliders[menu + "_2"] / 255));
    }
   
    if(HUD == "Background")
    {
        self.menu["UI"]["OPT_BG"] notify("StopRainbow");
        self.menu["UI"]["OPT_BG"] thread fadeToColor(RGB, .5);
    }
        
    if(HUD == "Scroller")
    {
        self.menu["UI"]["SCROLL"] notify("StopRainbow");
        self.menu["UI"]["SCROLL"] thread fadeToColor(RGB, .5);
    }
        
    if(HUD == "Banner")
    {
        SliderCheck = self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneRainbow" : "GradRainbow")];
        
        if(bool(self.menuSetting["HUDEdit"]))
        {
            self.menu["UI"]["BGTitle"] notify("StopRainbow");
            self.menu["UI"]["BGTitle"] thread fadeToColor(RGB, .3);
        }
        else
        {
            self.menu["UI"]["BGTitle_Grad"] notify("StopRainbow");
            self.menu["UI"]["BGTitle_Grad"] thread fadeToColor(RGB, .3);
        }
        
        for(e=0;e<3;e++)
            self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneColor" : "GradColor") + e] = RGB[e];
            
        self.menuSetting[HUD + (bool(self.menuSetting["HUDEdit"]) ? "NoneRainbow" : "GradRainbow")] = (RGB[0],RGB[1],RGB[2]);
            
        return;
    }
    
    for(e=0;e<3;e++)
        self.menuSetting[HUD + "GradColor" + e] = RGB[e];
        
    self.menuSetting[HUD + "GradRainbow"] = (RGB[0],RGB[1],RGB[2]);
}

#endif