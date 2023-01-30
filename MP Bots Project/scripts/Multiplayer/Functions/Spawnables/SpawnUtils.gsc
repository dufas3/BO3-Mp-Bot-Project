#ifdef MP

spawnSM(origin,model,angles)
{
   bog = spawn("script_model",origin);
   bog setModel(model);
   bog.angles = angles;
   wait .05;
   return bog;
}

SpawnPlayFx(Fx,pos,ID,Delay,DelayFx)
{  
    if(getentarray().size <= 2000)

    {

        if(!isDefined(pos))

            pos = (0,0,0);

        if(isDefined(Delay))

            wait Delay;

           

        if(ID == "Loop")

            level.SpawnedFx[level.SpawnedFx.size] = PlayLoopedFX(level._effect[Fx], DelayFx, (self.origin + (pos)));

        if(ID == "Normal")

            level.SpawnedFx[level.SpawnedFx.size] = spawnFx(level._effect[Fx], (self.origin + (pos)));

        triggerFx(level.SpawnedFx[level.SpawnedFx.size-1]);

    }  

}

modelSpawner(origin, model, angles, time)
{
    if(isDefined(time))
        wait time;
    obj = spawn("script_model", origin);
    obj setModel(model);
    obj solid();
    model solid();
    if(isDefined(angles))
        obj.angles = angles;
    if(getentarray().size >= 2000)
    {
        self iPrintLnBold("^1Error^7: Please delete some other structures");
        obj delete();
    }
    return obj;
}

createRoll( divide )
{

    roll = self getPlayerAngles()[1];

    wait 0.05;

    return (((roll-self getPlayerAngles()[1])*-6) / divide);

}

calcDistance(speed,origin,moveTo)
{

    return (distance(origin, moveTo) / speed);

}

spawnTrig(origin,width,height,cursorHint,string)
{

    trig = spawn("trigger_radius", origin, 1, width, height);

    trig setCursorHint(cursorHint, trig);

    trig setHintString( string );

    trig setvisibletoall();

    return trig;

}

rotateentyaw()
{
    level endon( "game_ended" );
    level endon( "Destroy_Merry" );
    level endon( "change_Speed_Merry" );
    while( IsDefined( self ) )
    {
        self rotateyaw( 360, level.speedmerry );
        wait level.speedmerry;
    }

}

deletemultiplearrays( a1, a2, a3, a4, a5, a6 )
{
    if( IsDefined( a1 ) )
    {
        array_delete( a1 );
    }
    if( IsDefined( a2 ) )
    {
        array_delete( a2 );
    }
    if( IsDefined( a3 ) )
    {
        array_delete( a3 );
    }
    if( IsDefined( a4 ) )
    {
        array_delete( a4 );
    }
    if( IsDefined( a5 ) )
    {
        array_delete( a5 );
    }
    if( IsDefined( a6 ) )
    {
        array_delete( a6 );
    }

}

applymultiplephysics( a1, a2, a3, a4, a5, a6 )
{
    if( IsDefined( a1 ) )
    {
        array_physics( a1 );
    }
    if( IsDefined( a2 ) )
    {
        array_physics( a2 );
    }
    if( IsDefined( a3 ) )
    {
        array_physics( a3 );
    }
    if( IsDefined( a4 ) )
    {
        array_physics( a4 );
    }
    if( IsDefined( a5 ) )
    {
        array_physics( a5 );
    }
    if( IsDefined( a6 ) )
    {
        array_physics( a6 );
    }

}
array_delete( id )
{
    foreach( model in id )
    {
        model delete();
    }

}

array_physics( id )
{
    foreach( model in id )
    {
        model thread delayedfall( 5 );
    }

}

S(Message)
{
    self iPrintLnBold(Message);
}

delayedfall( num, num1 )
{
    if( IsDefined( num1 ) )
    {
        wait num1;
    }
    if( IsDefined( self ) )
    {
        self physicslaunch();
    }
    wait num;
    if( IsDefined( self ) )
    {
        self delete();
    }

}

showhintstring( string, org, range )
{
    if( IsDefined( self.hintnotify ) )
    {
    }//createText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
    self.hintnotify = self createText( "objective", 1.6, "CENTER", "BOTTOM", 1,( 1, 1, 1 ), 1, (0,0,0), 1, string);
    while( distance2d( org, self.origin ) <= range )
    {
        if( self meleebuttonpressed() && IsDefined( self.riding ) )
        {
            break;
            break;
        }
        else
        {
            if( self usebuttonpressed() && !(IsDefined( self.riding )) )
            {
                break;
            }
        }
        wait 0.05;
    }
    self.hintnotify destroy();

}

ride_destroy2(args)
{
        if (args == "merrynuke")
        {
            self thread ride_destroy("merry", "applyMultiplePhysics", "Destroy_Merry");
        }
        else if (args == "merrydestroy")
        {
            self thread ride_destroy("merry", "deleteMultipleArrays", "Destroy_Merry");
        }
        else if (args == "ferrisnuke")
        {
            self thread ride_destroy("ferris", "applyMultiplePhysics", "Destroy_Ferris");
        }
        else if (args == "ferrisdestroy")
        {
            self thread ride_destroy("ferris", "deleteMultipleArrays", "Destroy_Ferris");
        }
        else if (args == "skybn")
        {
            self thread ride_destroy("skyb", "applyMultiplePhysics", "Destroy_Skybase");
        }
        else if (args == "skybd")
        {
            self thread ride_destroy("skyb", "deleteMultipleArrays", "Destroy_Skybase");
        }
        else if(args == "clawn")
        {
            self thread ride_destroy("claw", "applyMultiplePhysics", "Destroy_Claw");
        }
        else if (args == "clawd")
        {
            self thread ride_destroy("claw", "deleteMultipleArrays", "Destroy_Claw");
        }
}

ride_destroy(obj, arg2, notify1)
{
    if( IsDefined( level.coasterbuilt ) || IsDefined( level.merry_spawned ) || IsDefined( level.ferris_spawned )|| IsDefined( level.TheClawSpawned) )
    {
        level notify( notify1 );
        if( obj == "ferris" )
        {
            level.ferris_spawned = undefined;
            level.BuildSpaceFull = 0;
            level.ferristrig delete();
            level.ferrisattach delete();
            level.ridetriggers[ "Ferris"] delete();
            if( arg2 == "deleteMultipleArrays" )
            {
                self thread deletemultiplearrays( level.Ferris, level.FerrisSeats, level.FerrisLegs );
            }
            else
            {
                self thread applymultiplephysics( level.Ferris, level.FerrisSeats, level.FerrisLegs );
            }
        }
        else
        {
            if( obj == "merry" )
            {
                level.merry_spawned = undefined;
                level.merrygoroundmove delete();
                level.BuildSpaceFull = 0;
                level.ridetriggers[ "Merry"] delete();
                if( arg2 == "deleteMultipleArrays" )
                {
                    self thread deletemultiplearrays( level.merrygoround, level.merrygoroundseats, level.merrygoroundseattags, level.merrygoroundlights );
                }
                else
                {
                    self thread applymultiplephysics( level.merrygoround, level.merrygoroundseats, level.merrygoroundseattags, level.merrygoroundlights );
                }
            }
            else
            {
                if (obj == "claw")
                {
                    level.TheClawSpawned = undefined;
                    level.BuildSpaceFull = 0;
                    if (arg2 == "deleteMultipleArrays")
                    {
                        self thread deletemultiplearrays( level.clawseats, level.claw, level.legs );
                    }
                    else
                    {
                        self thread applymultiplephysics( level.clawseats, level.claw, level.legs );
                    }
                }
            }
        }
        foreach( player in level.players )
        {
            player unlink();
            if( IsDefined( player.seatoccupied ) )
            {
                player.seatoccupied = undefined;
            }
            if( IsDefined( player.riding ) )
            {
                player.riding = undefined;
            }
            if( !(IsDefined( player.godmode )) )
            {
                player disableinvulnerability();
            }
            player editmovements( 1 );
        }
    }
    else
    {
        self S( "^1Error^7: Ride has not been spawned to destroy." );
    }
}

monitorseatsystem( array, trigname, width, height, msg, ride, endon0 )
{
    level endon( "game_ended" );
    level endon( endon0 );
    if( !(IsDefined( level.ridetriggers )) )
    {
        level.ridetriggers = [];
    }
    level.ridetriggers[trigname] = spawnTrig(self.origin,150,80,"HINT_NOICON","Press [{+usereload}] To Ride "+msg+"!");
    while( IsDefined( self ) )
    {
        level.ridetriggers[ trigname] waittill( "trigger", player );
        if( player usebuttonpressed() && !IsDefined( player.riding) )
        {
            closest = ArrayGetClosest( player.origin, array );
            if( IsDefined( closest.seatoccupied ) )
            {
                
            }
            player.riding  = 1;
            player.saveorg = player.origin;
            if( ride == "Ferris" )
            {
                seat = modelSpawner( closest.origin - anglestoright( self.angles ) * 22, "script_origin", ( 0, 90, 0 ) );
                seat thread seat2anglefix( closest );
                player playerlinktodelta( seat );
            }
            else
            {
                player playerlinkto( closest );
                player.riding = 1;
            }
            if( !(IsDefined( player.godmode )) )
            {
                player enableinvulnerability();
            }
            if( IsDefined( player.hintnotify ) )
            {
                player.hintnotify destroy();
            }
            wait 0.1;
            player thread exitride( msg, closest, seat, endon0, level.ridetriggers[ trigname] );
        }
    }
}

exitride( msg, closest, seat, endon0, trig )
{
    level endon( "game_ended" );
    level endon( endon0 );
    self thread showhintstring( "Press [{+melee}] To Exit Ride " + ( msg + "!" ), self.origin, self.origin );
    while( IsDefined( self.riding ) )
    {
        if( self meleebuttonpressed() )
        {
            self unlink();
            self editmovements( 1 );
            self setorigin( self.saveorg );
            if( !(IsDefined( self.godmode )) )
            {
                self disableinvulnerability();
            }
            self setstance( "stand" );
            wait 0.25;
            if( IsDefined( seat ) )
            {
                seat delete();
            }
            closest.seatoccupied = undefined;
            self.riding = undefined;
        }
        wait 0.05;
    }

}

editmovements( num )
{
    self allowcrouch( num );
    self allowsprint( num );
    self allowprone( num );
    self allowjump( num );

}
#endif