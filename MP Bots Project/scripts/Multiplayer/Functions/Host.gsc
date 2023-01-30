KickAllPlayers()
{
    foreach(player in level.players)
    {
        if(!player isHost()){
            Kick(player GetEntityNumber());
        }
    }
    self iPrintLn("All Players Except Host Kicked");
}

PrintBribeCount()
{
    BribeCount = GetDvarInt("loot_bribeCrate");
    self iPrintLn(BribeCount);
}

TestAddCrate(Amount)
{
    CurrentCrateCount = self GetDStat("loot_bribeCrate");
    RewardCount       = GetDvarInt("loot_bribeCrate", 1);
    self setDStat("loot_bribeCrate", CurrentCrateCount + RewardCount);
    self iPrintLn("Game Will end in 5 seconds, so be ready!");
    wait 5;
    ExitLevel(0);
}