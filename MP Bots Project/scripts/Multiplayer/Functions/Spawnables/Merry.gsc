#ifdef MP
spawn_merry( error )
{
    if( !(IsDefined( level.merry_spawned )) )
    {
        level.merry_spawned = 1;
        foreach( player in level.players )
        {
            player iPrintLnBold("Merry Go Round Spawned");
        }
        self thread merrygoround();
    }
    else
    {
        self S( "^1Error^7: The " + ( error + " has already been spawned." ) );
    }

}

merrygoround()
{
    level endon( "game_ended" );
    self endon( "disconnect" );
    level endon( "Destroy_Merry" );
    level.speedmerry           = 6;
    level.merrygoround         = [];
    level.merrygoroundseats    = [];
    level.merrygoroundseattags = [];
    level.merrygoroundlights   = [];
    level.merrygoroundmove     = modelspawner( self.origin + ( ( +50, 0, 35 ) + anglestoforward( self getplayerangles() ) * 20 ), "tag_origin" );
    sizes                      = strtok( "0;55;93;131;169", ";" );
    sizesseats                 = strtok( "93;139;93;139;93;139;93;139;93;139", ";" );
    sizeslights                = strtok( "93;131;93;131;93;131;93;131;93;131", ";" );
    num                        = 0;
    time                       = 0.05;
    e                          = 0;
    while( e < 3 )
    {
        i = 0;
        while( i < 6 )
        {
            level.merrygoround[level.merrygoround.size] = modelspawner( level.merrygoroundmove.origin + ( cos( i * 60 ) * 20, sin( i * 60 ) * 20, e * 70 ), "wpn_t7_care_package_world", ( 0, i * 60 + 90, 90 ), time );
            i++;
        }
        e++;
    }
    z = 0;
    while( z < 2 )
    {
        e = 0;
        while( e < 5 )
        {
            i = 0;
            while( i < 6 * e )
            {
                level.merrygoround[level.merrygoround.size] = modelspawner( level.merrygoroundmove.origin + ( cos( i * ( 360 / ( 6 * e ) ) ) * int( sizes[ e] ), sin( i * ( 360 / ( 6 * e ) ) ) * int( sizes[ e] ), -20 + 190 * z ), "wpn_t7_care_package_world", ( 0, i * ( 360 / ( 6 * e ) ) + 0, 0 ), time );
                level.merrygoround[ level.merrygoround.size - 1] linkto( level.merrygoroundmove );
                i++;
            }
            e++;
        }
        z++;
    }
    e = 0;
    while( e < 10 )
    {
        level.merrygoroundlights[e] = modelspawner( level.merrygoroundmove.origin + ( cos( e * 36 ) * int( sizeslights[ e] ), sin( e * 36 ) * int( sizeslights[ e] ), 146 ), "tag_origin", ( 0, e * 36 + 0, 0 ), time );
        level.merrygoroundlights[e + 10] = modelspawner( level.merrygoroundmove.origin + ( cos( e * 36 ) * 169, sin( e * 36 ) * 169, 146 ), "tag_origin", ( 0, e * 36 + 0, 0 ), time );
        playfxontag( level._effect[ "green"], level.merrygoroundlights[ e], "tag_origin" );
        playfxontag( level._effect[ "red"], level.merrygoroundlights[ e + 10], "tag_origin" );
        level.merrygoroundseats[level.merrygoroundseats.size] = modelspawner( level.merrygoroundmove.origin + ( cos( e * 36 ) * int( sizesseats[ e] ), sin( e * 36 ) * int( sizesseats[ e] ), 20 ), "wpn_t7_care_package_world", ( 0, e * 36 + 0, 0 ), time );
        level.merrygoroundseattags[level.merrygoroundseattags.size] = modelspawner( level.merrygoroundmove.origin + ( 0, 0, 20 ), "tag_origin", ( 0, e * 36 + 0, 0 ), time );
        level.merrygoroundseats[ level.merrygoroundseats.size - 1] linkto( level.merrygoroundseattags[ level.merrygoroundseattags.size - 1] );
        e++;
    }
    level.merrygoroundmove thread rotateentyaw();
    foreach( seattag in level.merrygoroundseattags )
    {
        seattag thread movemerryseats();
        seattag thread rotateentyaw();
        level.merrygoroundseats[ num] linkto( seattag );
        level.merrygoroundlights[ num] linkto( level.merrygoroundmove );
        level.merrygoroundlights[ num + 10] linkto( level.merrygoroundmove );
        num++;
    }
    level.merrygoroundmove thread monitorseatsystem( level.merrygoroundseats, "Merry", 200, 30, "The Merry Go Round", "Merry", "Destroy_Merry" );

}

movemerryseats( seat )
{
    level endon( "game_ended" );
    level endon( "Destroy_Merry" );
    while( IsDefined( self ) )
    {
        randnum = randomfloatrange( 1, 3 );
        self movez( 65, randnum, 0.4, 0.4 );
        wait randnum;
        randnum = randomfloatrange( 1, 3 );
        self movez( -65, randnum, 0.4, 0.4 );
        wait randnum;
    }

}

merryrotate( speed )
{
    level.speedmerry = level.speedmerry + speed;
    if( level.speedmerry >= 10 )
    {
        level.speedmerry = 10;
    }
    if( level.speedmerry <= 1 )
    {
        level.speedmerry = 1;
    }
    self S( level.speedmerry );
    level notify( "change_Speed_Merry" );
    foreach( seattag in level.merrygoroundseattags )
    {
        seattag thread rotateentyaw();
    }
    level.merrygoroundmove thread rotateentyaw();

}

resetmerryspeed()
{
    level.speedmerry = 6;

}

#endif