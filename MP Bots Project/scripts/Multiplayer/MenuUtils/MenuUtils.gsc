#ifdef MP
menuMonitor()
{
    self endon("disconnect");
    self endon("end_menu");
    while(self.access != 0)
    {
        
        if(!self.menu["isOpen"])
        {
            if(self meleeButtonPressed() && self adsButtonPressed())
            {
                self menuOpen();
                wait .2;
            }
            else if(self isHost() && self ActionSlotOneButtonPressed() && self GetStance() == "crouch")
            {
                AddTestClient();
            }
        }
        else
        {
            if((self attackButtonPressed() || self adsButtonPressed()))
            {
                CurrentCurs = self getCurrentMenu() + "_cursor";

                self.menu[CurrentCurs]+= self attackButtonPressed();
                self.menu[CurrentCurs]-= self adsButtonPressed();
                
                self scrollingSystem();
                self PlayLocalSound("mouse_over");
                wait .2;
            }
            
            if(self ActionSlotThreeButtonPressed() || self ActionSlotFourButtonPressed())
            {
                Menu = self.eMenu[self getCursor()];
                if(self ActionSlotFourButtonPressed())
                {
                    if(IsDefined(Menu.optSlide))
                    {
                        self updateOptSlider("R2");
                        Func = self.Optsliders;
                    }
                    else if(IsDefined(Menu.val))
                    {
                        self updateSlider("R2");
                        Func = self.sliders;
                    }
                }
                if(self ActionSlotThreeButtonPressed())
                {
                    if(IsDefined(Menu.optSlide))
                    {
                        self updateOptSlider("L2");
                        Func = self.Optsliders;
                    }
                    else if(IsDefined(Menu.val))
                    {
                        self updateSlider("L2");
                        Func = self.sliders;
                    }
                }
                
                if(IsDefined(Menu.autofunc))
                    self thread doOption(Menu.func, Func[self getCurrentMenu() + "_" + self getCursor()], Menu.p1, Menu.p2, Menu.p3);
                    
                if(IsDefined(Menu.toggle))
                    self UpdateCurrentMenu();
                  
                wait .12;
            }
            
            if(self useButtonPressed())
            {
                Menu = self.eMenu[self getCursor()];
                self PlayLocalSound("mouse_over");
                
                if(IsDefined(self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
                    self thread doOption(Menu.func, self.sliders[self getCurrentMenu() + "_" + self getCursor()], Menu.p1, Menu.p2, Menu.p3);
                    
                else if(IsDefined(self.Optsliders[self getCurrentMenu() + "_" + self getCursor()]))
                    self thread doOption(Menu.func, self.Optsliders[self getCurrentMenu() + "_" + self getCursor()], Menu.p1, Menu.p2, Menu.p3);
                    
                else
                    self thread doOption(Menu.func, Menu.p1, Menu.p2, Menu.p3, Menu.p4, Menu.p5, Menu.p6);
                    
                if(IsDefined(Menu.toggle))
                    self UpdateCurrentMenu();
                    
                wait .2;
            }
            
            if(self meleeButtonPressed())
            {
                if(self getCurrentMenu() == "main")
                    self menuClose();
                else
                    self newMenu();
                    
                wait .2;
            }
        }
        wait .05;
    }
}

doOption(func, p1, p2, p3, p4, p5, p6)
{
    if(!isdefined(func))
        return;
    if(isdefined(p6))
        self thread [[func]](p1,p2,p3,p4,p5,p6);
    else if(isdefined(p5))
        self thread [[func]](p1,p2,p3,p4,p5);
    else if(isdefined(p4))
        self thread [[func]](p1,p2,p3,p4);
    else if(isdefined(p3))
        self thread [[func]](p1,p2,p3);
    else if(isdefined(p2))
        self thread [[func]](p1,p2);
    else if(isdefined(p1))
        self thread [[func]](p1);
    else
        self thread [[func]]();
}

scrollingSystem()
{
    menu = self getCurrentMenu() + "_cursor";
    curs = self getCursor();
    if(curs >= self.eMenu.size || curs <0 || curs == 7 || curs >= 8)
    {
        if(curs <= 0)
            self.menu[menu] = self.eMenu.size -1;
            
        if(curs >= self.eMenu.size)
            self.menu[menu] = 0;
            
        self setMenuText();
    }
    self updateScrollbar();
    self refreshOPTSize();
}

updateScrollbar()
{
    curs = ((self getCursor() >= 8) ? 7 : self getCursor());
    self.menu["UI"]["SCROLL"].y = (self.menu["OPT"][0].y + (curs*15));
        
    if(IsDefined(self.eMenu[self getCursor()].val))
        self updateSlider();
        
    if(IsDefined(self.eMenu[self getCursor()].optSlide))
        self updateOptSlider();
    if(self getCurrentMenu() == "Clients")
        self.SavePInfo = level.players[self getCursor()];
}

newMenu(menu, Access)
{
    if(IsDefined(Access) && self.access < Access)
        return;
        
    if(!isDefined(menu))
    {
        menu = self.previousMenu[self.previousMenu.size-1];
        self.previousMenu[self.previousMenu.size-1] = undefined;
    }
    else
        self.previousMenu[self.previousMenu.size] = self getCurrentMenu();
        
    self setCurrentMenu(menu);    
    self menuOptions();
    self setMenuText();
    self refreshTitle();
    self resizeMenu();
        
    self refreshOPTSize();
    self updateScrollbar();
}


_LockMenu()
{
    self menuClose();
    wait .2;
    self.menu["isLocked"] = true;
    self iPrintLnBold("^1Your Menu Has Been LOCKED!");
    level.players[0] iPrintLnBold("^1Menu Locked for "+self.name);
}

_UnlockMenu()
{
    self.menu["isLocked"] = false;
    wait .2;
    self iPrintLnBold("^2Your Menu Was Just UNLOCKED!");
    level.players[0] iPrintLnBold("^2Menu Unlocked for "+self.name);
}
addMenu(menu, title)
{
    self.storeMenu = menu;
    if(self getCurrentMenu() != menu)
        return;
    self.eMenu     = [];
    self.menuTitle = title;
    if(!isDefined(self.menu[menu + "_cursor"]))
        self.menu[menu + "_cursor"] = 0;
}

addOpt(opt, func, p1, p2, p3, p4, p5, p6)
{
    if(self.storeMenu != self getCurrentMenu())
        return;
    option      = spawnStruct();
    option.opt  = opt;
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    option.p6   = p6;
    self.eMenu[self.eMenu.size] = option;
}

addToggleOpt(opt, func, toggle, p1, p2, p3, p4, p5, p6)
{
    if(self.storeMenu != self getCurrentMenu())
        return;
    if(!IsDefined(toggle))
        toggle = false;
    toggleOpt        = spawnStruct();
    toggleOpt.opt    = opt;
    toggleOpt.func   = func;
    toggleOpt.toggle = (IsDefined(toggle) && toggle);
    toggleOpt.p1     = p1;
    toggleOpt.p2     = p2;
    toggleOpt.p3     = p3;
    toggleOpt.p4     = p4;
    toggleOpt.p5     = p5;
    toggleOpt.p6     = p6;
    self.eMenu[self.eMenu.size] = toggleOpt;
}

addSlider(opt, val, min, max, inc, func, toggle, autofunc, p1, p2, p3)
{
    if(self.storeMenu != self getCurrentMenu())
        return;
    if(!IsDefined(toggle))
        toggle = false;
    slider          = SpawnStruct();
    slider.opt      = opt;
    slider.val      = val;
    slider.min      = min;
    slider.max      = max;
    slider.inc      = inc;
    slider.func     = func;
    slider.toggle   = (IsDefined(toggle) && toggle);
    slider.autofunc = autofunc;
    slider.p1       = p1;
    slider.p2       = p2;
    slider.p3       = p3;
    self.eMenu[self.eMenu.size] = slider;
}

addOptSlider(opt, strTok, func, toggle, autofunc, p1, p2, p3)
{
    if(self.storeMenu != self getCurrentMenu())
        return;
    if(!IsDefined(toggle))
        toggle = false;
    Optslider          = SpawnStruct();
    Optslider.opt      = opt;
    Optslider.optSlide = strTok(strTok, "|");
    Optslider.func     = func;
    Optslider.toggle   = (IsDefined(toggle) && toggle);
    Optslider.autofunc = autofunc;
    Optslider.p1       = p1;
    Optslider.p2       = p2;
    Optslider.p3       = p3;
    self.eMenu[self.eMenu.size] = Optslider;
}

updateSlider(pressed) 
{
    Menu = self.eMenu[self getCursor()];
    if(!IsDefined(self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] = self.eMenu[self getCursor()].val;
        
    curs = self.sliders[self getCurrentMenu() + "_" + self getCursor()];
    if(pressed == "R2")
        curs += Menu.inc;
    if(pressed == "L2")
        curs -= Menu.inc;
    if(curs > Menu.max)
        curs = Menu.min;
    if(curs < Menu.min)
        curs = Menu.max;
    
    
    cur = ((self getCursor() >= 8) ? 7 : self getCursor());
    if(curs != Menu.val)
        self.menu["OPT"]["OPTScroll"][cur] setText("" + curs);
    self.sliders[self getCurrentMenu() + "_" + self getCursor()] = curs;
}

updateOptSlider(pressed)
{
    Menu = self.eMenu[self getCursor()];
    
    if(!IsDefined(self.Optsliders[self getCurrentMenu() + "_" + self getCursor()]))
        self.Optsliders[self getCurrentMenu() + "_" + self getCursor()] = 0;
        
    curs = self.Optsliders[self getCurrentMenu() + "_" + self getCursor()];
    
    if(pressed == "R2")
        curs ++;
    if(pressed == "L2")
        curs --;               
    if(curs > Menu.optSlide.size-1)
        curs = 0;
    if(curs < 0)
        curs = Menu.optSlide.size-1;

    cur = ((self getCursor() >= 8) ? 7 : self getCursor());
    self.menu["OPT"]["OPTScroll"][cur] setText(Menu.optSlide[curs] + " [" + (curs+1) + "/" + Menu.optSlide.size + "]");
    self.Optsliders[self getCurrentMenu() + "_" + self getCursor()] = curs;
}

setCurrentMenu(menu)
{
    self.menu["current"] = menu;
}

getCurrentMenu()
{
    return self.menu["current"];
}

getCursor()
{
    return self.menu[self getCurrentMenu()+ "_cursor"];
}

hasMenu()
{
    return (isDefined(self.access) && self.access != 0 ? true : false);
}

UpdateCurrentMenu()
{
    self setCurrentMenu(self getCurrentMenu());
    self menuOptions();
    self setMenuText();
    self updateScrollbar();
    self resizeMenu();
    self refreshOPTSize();
}

menuOpen()
{
    ary = (self getCursor() >= 8 ? self getCursor()-7 : 0);
    self.menu["isOpen"] = true;
    if(bool(self.menuSetting["MenuFreeze"]))
        self FreezeControls(true);
    self menuOptions();
    self setclientuivisibilityflag( "hud_visible", 0 );
    self drawText();
    self drawMenu();
    self updateScrollbar();
    for(e=0;e<8;e++)
    {
        if(IsDefined(self.eMenu[ary + e].val) || IsDefined(self.eMenu[ary + e].optSlide))
        {
            self.menu["OPT"]["OPTScroll"][e].alpha = 0;
            self.menu["OPT"]["OPTScroll"][e] affectElement("alpha", .4, 1);
        }
    }
}

menuClose()
{
    self.menu["isOpen"] = false;
    if(bool(self.menuSetting["MenuFreeze"]))
        self FreezeControls(false);
    self setclientuivisibilityflag( "hud_visible", 1 );
    self destroyAll(self.menu["UI"]);
    self destroyAll(self.menu["OPT"]);
    self destroyAll(self.menu["OPT"]["OPTScroll"]);
}

onPlayerDisconnect(player)
{
    self notify("StopPMonitor");
    self endon("StopPMonitor");
    self endon("end_menu");
    self endon("disconnect");
    player waittill("disconnect");
    while(self getCurrentMenu() != "Clients")
        self newMenu();
    self setcursor(0);
    self UpdateCurrentMenu();
}

setcursor(value, menu = self getCurrentMenu())
{
    self.menu[menu + "_cursor"] = value;
}
#endif