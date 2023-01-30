#ifdef MP
spawn_ferris( error )
{
    if( !(IsDefined( level.ferris_spawned )) )
    {
        level.ferris_spawned = 1;

        self thread ferriswheel();
        self iPrintLnBold("Ferris Wheel Spawned");
    }
    else
    {
        self iPrintLnBold( "^1Error^7: The " + ( error + " has already been spawned." ) );
    }

}

ferriswheel()
{
    level endon( "Destroy_Ferris" );
    level endon( "game_ended" );
    self endon( "disconnect" );
    level.ferrisorg = self.origin;
    level.speed = 0;
    level.ferrislegs = [];
    level.ferrisseats = [];
    level.ferris = [];
    level.ferrisattach = modelSpawner( level.ferrisorg + ( 0, 0, 420 ), "tag_origin" );
    level.ferrislink = modelSpawner( level.ferrisorg + ( 0, 0, 40 ), "tag_origin" );
    time = 0.05;
    a = 0;
    while( a < 2 )
    {
        e = 0;
        while( e < 30 )
        {
            level.ferris[level.ferris.size] = modelSpawner( level.ferrisorg + ( ( -50 + a * 100, 0, 420 ) + ( 0, sin( e * 12 ) * 330, cos( e * 12 ) * 330 ) ), "wpn_t7_care_package_world", ( 0, 0, e * -12 ), time );
            e++;
        }
        a++;
    }
    a = 0;
    while( a < 2 )
    {
        b = 0;
        while( b < 5 )
        {
            e = 0;
            while( e < 15 )
            {
                level.ferris[level.ferris.size] = modelSpawner( level.ferrisorg + ( ( -50 + a * 100, 0, 420 ) + ( 0, sin( e * 24 ) * ( 40 + ( b * 65 ) ), cos( e * 24 ) * ( 40 + ( b * 65 ) ) ) ), "wpn_t7_care_package_world", ( 0, 0, e * -24 - 90 ), time );
                e++;
            }
            b++;
        }
        a++;
    }
    e = 0;
    while( e < 15 )
    {
        level.ferrisseats[level.ferrisseats.size] = modelSpawner( level.ferrisorg + ( ( 0, 0, 420 ) + ( 0, sin( e * 24 ) * 330, cos( e * 24 ) * 330 ) ), "wpn_t7_care_package_world", ( e * 24, 90, 0 ), time );
        e++;
    }
    e = 0;
    while( e < 3 )
    {
        level.ferrislegs[level.ferrislegs.size] = modelSpawner( level.ferrisorg + ( 82 - e * 82, 0, 420 ), "wpn_t7_care_package_world", ( 0, 90, 0 ), 0.1 );
        e++;
    }
    e = 0;
    while( e < 2 )
    {
        a = 0;
        while( a < 8 )
        {
            level.ferrislegs[level.ferrislegs.size] = modelSpawner( level.ferrisorg + ( ( -100 + e * 200, -220, 0 ) + ( 0, a * 28, a * 60 ) ), "wpn_t7_care_package_world", ( 0, 90, 65 ), time );
            a++;
        }
        e++;
    }
    e = 0;
    while( e < 2 )
    {
        a = 0;
        while( a < 8 )
        {
            level.ferrislegs[level.ferrislegs.size] = modelSpawner( level.ferrisorg + ( ( -100 + e * 200, 220, 0 ) + ( 0, a * -28, a * 60 ) ), "wpn_t7_care_package_world", ( 0, 90, -65 ), time );
            a++;
        }
        e++;
    }
    foreach( model in level.ferris )
    {
        model linkto( level.ferrisattach );
    }
    foreach( model in level.ferrisseats )
    {
        model linkto( level.ferrisattach );
    }
    level.ferrisattach thread ferrisrotate( 1 );
    level.ferrislink thread monitorseatsystem( level.ferrisseats, "Ferris", 200, 40, "The Ferris Wheel", "Ferris", "Destroy_Ferris" );

}

ferrisrotate( speed )
{
    self thread doferrisrotate( speed );

}

resetferrisspeed()
{
    level.speed = 0;
    self thread doferrisrotate( 1 );

}

doferrisrotate( speed )
{
    level endon( "Destroy_Ferris" );
    level.speed = level.speed + speed;
    if( level.speed >= 15 )
    {
        level.speed = 15;
    }
    if( level.speed <= -15 )
    {
        level.speed = -15;
    }
    self S( level.speed );
    while( 1 )
    {
        a = 0;
        while( a < 360 )
        {
            self rotateto( ( 0, self.angles[ 1], a ), 0.2 );
            wait 0.05;
            a = a + level.speed;
        }
        a = 360;
        while( a < 0 )
        {
            self rotateto( ( 0, self.angles[ 1], a ), 0.2 );
            wait 0.05;
            a = a - level.speed;
        }
        wait 0.05;
    }

}

seat2anglefix( seat )
{
    while( IsDefined( level.ferris_spawned ) && IsDefined( self ) )
    {
        a = 0;
        while( a < 360 )
        {
            self.angles = ( 0, 90, 0 );
            self moveto( seat.origin + ( 0, 0, 10 ), 0.1 );
            wait 0.05;
            a = a + level.speed;
        }
        wait 0.05;
    }
    self delete();

}
#endif