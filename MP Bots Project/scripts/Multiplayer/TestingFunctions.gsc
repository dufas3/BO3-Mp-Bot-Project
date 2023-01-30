
#ifdef MP
ToggleTest()
{
    self.toggle = !bool(self.toggle);
}

LevelToggleTest()
{
    level.levelToggle = !bool(level.levelToggle);
}

TextSlider(Val)
{
    if(Val != 0)
        self.TextSlider = true;
    else
        self.TextSlider = undefined;
}

ValSlider(Val)
{
    if(Val != 0)
        self.ValSlider = true;
    else
        self.ValSlider = undefined;
}
    
FastRestartFix()
{
    map_restart(false);
}

#endif