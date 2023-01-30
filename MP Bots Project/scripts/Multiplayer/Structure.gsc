#ifdef MP
menuOptions()
{
    /*
        Add SubMenu
            - self addOpt("Example Menu 1", ::newMenu, "EG1");
            - self addMenu("EG1", "Example Menu 1");
            
        addOpt(option, function, p1, p2, p3, p4, p5, p6)
        addToggleOpt(option, function, toggle, p1, p2, p3, p4, p5, p6)
        addOptSlider(option, strTok, function, toggle, autofunc, p1, p2, p3)
        addSlider(option, value, min, max, inc, function, toggle, autofunc, p1, p2, p3)
        
        
        Example Are Below
    */
    switch(self getCurrentMenu())
    {
        case "main":
            self addMenu("main", "Main Menu");
            self addOpt("Bots Menu", ::newMenu, "Bots", 3);
            break;
        case "Bots":
            self addMenu("Bots", "Bots Menu");
            self addSlider("Spawn Bots", 1,1,7,1, ::SpawnBotT, undefined, undefined);
            break;
            
        default:
            self ClientOptions();
            break;
    }
}

ClientOptions()
{
    player = self.SavePInfo;
    Name   = player getName();
    switch(self getCurrentMenu())
    {
    }
}
#endif