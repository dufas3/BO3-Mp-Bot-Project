#ifdef MP
Build_TheClaw()
{
    if(!isDefined(level.TheClawSpawned))
    {
            self thread Build_TheClaw2();
            self S("Spawning The Claw");
            level.TheClawSpawned = true;
            level.BuildSpaceFull = 1;
    }
    else
    {
        self S("^1ERROR^7 Entity Limit Reached");   
    }
}

Build_TheClaw2()
{

    level endon("Destroy_Claw");

    level.clawOrg = self.origin;

    pos = level.clawOrg+(0,15,460);

   

    level.ClawSeats = [];

    level.claw = [];

    level.legs = [];

   

    level.attach = modelSpawner(level.clawOrg+(0,55,60),"tag_origin");

    level.ClawLink = modelSpawner(pos,"tag_origin");

   

    for(e=0;e<2;e++) for(a=0;a<8;a++)

        level.legs[level.legs.size] = modelSpawner(level.clawOrg + (-220,-145+e*320,0) + (a*28,0,a*60),"wpn_t7_care_package_world",(25,0,90),.1);

    for(e=0;e<2;e++) for(a=0;a<8;a++)

        level.legs[level.legs.size] = modelSpawner(level.clawOrg + (220,-145+e*320,0) + (a*-28,0,a*60),"wpn_t7_care_package_world",(-25,0,90),.1);

    for(a=0;a<5;a++) for(e=0;e<8;e++)

        level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,-125+a*70,460) + (sin(-90+e*45)*25, 0, sin(e*45)*25), "wpn_t7_care_package_world", ((e*45),180,0),.1);

    for(a=0;a<8;a++) for(e=0;e<6;e++)

        level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,15,460) + (cos(a*45)*30,sin(a*45)*30, e*-70), "wpn_t7_care_package_world", (0,(a*45)+90,90),.1);

    level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,15, 60), "wpn_t7_care_package_world", (0,90,90),.1);  

    for(a=0;a<2;a++) for(e=0;e<12;e++)

        level.claw[level.claw.size] = modelSpawner(level.clawOrg + (0,15,100) + (cos(e*30)*40+a*55,sin(e*30)*40+a*55, -70), "wpn_t7_care_package_world", (0,(e*30)+-90+a*90,0),.1);

    for(e=0;e<12;e++) level.ClawSeats[level.ClawSeats.size] = modelSpawner(level.clawOrg + (0,15,95) + (cos(e*30)*95,sin(e*30)*95, -70), "wpn_t7_care_package_world", Undefined,.1);

   

    foreach(model in level.claw)

        model linkTo(level.ClawLink);

    foreach(model in level.ClawSeats)

        model linkTo(level.ClawLink);

   

    level.ClawLink thread ClawMovements();

    level.attach thread monitorPlayersClaw( level.ClawSeats );

}


ClawMovements()
{

    level endon("Destroy_Claw");

    for(a=0;a>=-40;a-=2)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .1;

    }

    for(a=a;a<=60;a+=3)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .1;

    }

    for(a=a;a>=-80;a-=3)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .05;

    }

    for(a=a;a<=100;a+=4)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .05;

    }

    while(true)

    {

        for(a=a;a>=-105;a-=5)

        {

            self rotateTo((a,self.angles[1],0),.5);

            wait .05;

        }

        for(a=a;a<=105;a+=5)

        {

            self rotateTo((a,self.angles[1],0),.5);

            wait .05;

        }

        wait .05;

    }

}

PlayerRideAngles(i)
{
    level endon("Destroy_Claw");
    while (isDefined(i.riding))
    {
        for(a=0;a>=-40;a-=2)

    {

        i rotateTo((a,self.angles[1],0),.5);

        wait .1;

    }

    for(a=a;a<=60;a+=3)

    {

        i rotateTo((a,self.angles[1],0),.5);

        wait .1;

    }

    for(a=a;a>=-80;a-=3)

    {

        i rotateTo((a,self.angles[1],0),.5);

        wait .05;

    }

    for(a=a;a<=100;a+=4)

    {

        i rotateTo((a,self.angles[1],0),.5);

        wait .05;

    }

    while(true)

    {

        for(a=a;a>=-105;a-=5)

        {

            i rotateTo((a,self.angles[1],0),.5);

            wait .05;

        }

        for(a=a;a<=105;a+=5)

        {

            i rotateTo((a,self.angles[1],0),.5);

            wait .05;

        }

        wait .05;

    }
}
}
monitorPlayersClaw(Array)
{

    level endon("Destroy_Claw");

    level.ClawTrig = spawnTrig(self.origin,150,80,"HINT_NOICON","Press &&1 To Enter / Exit The Claw!");

    while(isDefined(self))

    {

        level.ClawTrig waittill("trigger",i);

        if(i useButtonPressed() && !i.riding)

        {

            RandSeat = RandomIntRange( 0, 13 );

            if(!RandSeat.occupied)

            {

                i setStance("stand");

                i.riding = true;

                i playerLinkToDelta(Array[RandSeat]);

                i thread playerExitClaw(RandSeat);
                i thread PlayerRideAngles(i);

                RandSeat.occupied = true;

            }

        }

    }

}

playerExitClaw(seat,info)
{

    level endon("Destroy_Claw");

    while(isDefined(seat))

    {

        if(self meleeButtonPressed()) break;

        wait .05;

    }

    info destroy();

    self allowSprint(true);

    self allowProne(true);

    seat.occupied = undefined;

    self unlink();

    self setStance("stand");

    wait 1;

    self.riding = undefined;

}
/*
Build_TheClaw()
{
    if (level.BuildSpaceFull == 1)
    {
        self S("[^1ERROR]^4You Already have a Spawnable in place.");
    }
    else
    {
            self thread Build_TheClaw2();
            self S("Spawning The Claw");
            level.BuildSpaceFull = 1;
            level.TheClawSpawned = true;
    }
}

Build_TheClaw2()

{

    level endon("Destroy_Claw");

    level.clawOrg = self.origin;

    pos = level.clawOrg+(0,15,460);

    

    level.ClawSeats = [];

    level.claw = [];

    level.legs = [];

    

    level.attach = modelSpawner(level.clawOrg+(0,55,60),"tag_origin");

    level.ClawLink = modelSpawner(pos,"tag_origin");
e               = 0;
    while( e < 2 )
    {
        a = 0;
        while( a < 8 )
        {
            level.legs[level.legs.size] = modelSpawner( level.claworg + ( ( -220, -145 + e * 320, 0 ) + ( a * 28, 0, a * 60 ) ), "wpn_t7_care_package_world", ( 25, 0, 90 ), 0.1 );
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
            level.legs[level.legs.size] = modelSpawner( level.claworg + ( ( 220, -145 + e * 320, 0 ) + ( a * -28, 0, a * 60 ) ), "wpn_t7_care_package_world", ( -25, 0, 90 ), 0.1 );
            a++;
        }
        e++;
    }
    a = 0;
    while( a < 5 )
    {
        e = 0;
        while( e < 8 )
        {
            level.claw[level.claw.size] = modelSpawner( level.claworg + ( ( 0, -125 + a * 70, 460 ) + ( sin( -90 + e * 45 ) * 25, 0, sin( e * 45 ) * 25 ) ), "wpn_t7_care_package_world", ( e * 45, 180, 0 ), 0.1 );
            e++;
        }
        a++;
    }
    a = 0;
    while( a < 8 )
    {
        e = 0;
        while( e < 6 )
        {
            level.claw[level.claw.size] = modelSpawner( level.claworg + ( ( 0, 15, 460 ) + ( cos( a * 45 ) * 30, sin( a * 45 ) * 30, e * -70 ) ), "wpn_t7_care_package_world", ( 0, a * 45 + 90, 90 ), 0.1 );
            e++;
        }
        a++;
    }
    level.claw[level.claw.size] = modelSpawner( level.claworg + ( 0, 15, 60 ), "wpn_t7_care_package_world", ( 0, 90, 90 ), 0.1 );
    a = 0;
    while( a < 2 )
    {
        e = 0;
        while( e < 12 )
        {
            level.claw[level.claw.size] = modelSpawner( level.claworg + ( ( 0, 15, 100 ) + ( cos( e * 30 ) * ( 40 + ( a * 55 ) ), sin( e * 30 ) * ( 40 + ( a * 55 ) ), -70 ) ), "wpn_t7_care_package_world", ( 0, e * 30 + ( -90 + a * 90 ), 0 ), 0.1 );
            e++;
        }
        a++;
    }
    e = 0;
    while( e < 12 )
    {
        level.clawseats[level.clawseats.size] = modelSpawner( level.claworg + ( ( 0, 15, 95 ) + ( cos( e * 30 ) * 95, sin( e * 30 ) * 95, -60 ) ), "tag_origin", undefined, 0.1 );
        e++;
    }
    foreach(model in level.claw)

        model linkTo(level.ClawLink);

    foreach(model in level.clawseats)

        model linkTo(level.ClawLink);

    

    level.ClawLink thread ClawMovements();
    level.attach thread monitorseatsystem( level.clawseats, "Claw", 200, 30, "The Claw", "Claw", "Destroy_Claw" );

}


ClawMovements()
{
    level endon( "Destroy_Claw" );
    a = 0;
    while( a >= -40 )
    {
        self rotateto( ( a, self.angles[ 1], 0 ), 0.5 );
        wait 0.1;
        a = a - 2;
    }
    a = a;
    while( a <= 60 )
    {
        self rotateto( ( a, self.angles[ 1], 0 ), 0.5 );
        wait 0.1;
        a = a + 3;
    }
    a = a;
    while( a >= -80 )
    {
        self rotateto( ( a, self.angles[ 1], 0 ), 0.5 );
        wait 0.05;
        a = a - 3;
    }
    a = a;
    while( a <= 100 )
    {
        self rotateto( ( a, self.angles[ 1], 0 ), 0.5 );
        wait 0.05;
        a = a + 4;
    }
    while( true )
    {
        a = a;
        while( a >= -105 )
        {
            self rotateto( ( a, self.angles[ 1], 0 ), 0.5 );
            wait 0.05;
            a = a - 5;
        }
        a = a;
        while( a <= 105 )
        {
            self rotateto( ( a, self.angles[ 1], 0 ), 0.5 );
            wait 0.05;
            a = a + 5;
        }
        wait 0.05;
    }

}

PlayerRideAngles(seat)
{
    level endon("Destroy_Claw");
    while (isDefined(self.riding))
    {
        for(a=0;a>=-40;a-=2)

    {

        seat rotateTo((a,self.angles[1],0),.5);

        wait .1;

    }

    for(a=a;a<=60;a+=3)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .1;

    }

    for(a=a;a>=-80;a-=3)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .05;

    }

    for(a=a;a<=100;a+=4)

    {

        self rotateTo((a,self.angles[1],0),.5);

        wait .05;

    }

    while(true)

    {

        for(a=a;a>=-105;a-=5)

        {

            self rotateTo((a,self.angles[1],0),.5);

            wait .05;

        }

        for(a=a;a<=105;a+=5)

        {

            self rotateTo((a,self.angles[1],0),.5);

            wait .05;

        }

        wait .05;

    }
}
}

*/
#endif