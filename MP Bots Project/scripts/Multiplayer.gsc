#ifdef MP
#include scripts\codescripts\struct;
#include scripts\shared\callbacks_shared;
#include scripts\shared\system_shared;
#include scripts\shared\rank_shared;
#include scripts\shared\math_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\_oob;
#include scripts\mp\bots\_bot;
#include scripts\mp\bots\_bot_combat;
#include scripts\mp\teams\_teams;
#include scripts\shared\bots\_bot;
#include scripts\shared\bots\_bot_combat;
#include scripts\shared\bots\bot_buttons;
#include scripts\shared\bots\bot_traversals;
#include scripts\shared\array_shared;
#include scripts\shared\music_shared;
#include scripts\shared\flag_shared;
#include scripts\shared\callbacks_shared;
#include scripts\shared\system_shared;
#include scripts\shared\persistence_shared;
#include scripts\mp\gametypes\_hud_message;
#include scripts\mp\gametypes\_globallogic;
#include scripts\mp\gametypes\_globallogic_player;
#include scripts\mp\killstreaks\_killstreaks;
#include scripts\mp\gametypes\_globallogic_score;
#include scripts\mp\gametypes\_globallogic_ui;
#include scripts\mp\gametypes\_globallogic_utils;
#include scripts\mp\_scoreevents;
#include scripts\mp\_contracts;
#include scripts\mp\_gamerep;
#namespace infinityloader;

//required
autoexec __init__system__()
{
    system::register("infinityloader", ::__init__, undefined, undefined);
}

//required
__init__()
{
    callback::on_start_gametype(::init);
    callback::on_connect(::onPlayerConnect);
    callback::on_spawned(::onPlayerSpawned);
}

init()
{
    do_online();

}

onPlayerConnect()
{
    level._Models        = StrTok("defaultvehicle;defaultactor;wpn_t7_care_package_world;",";");
    level.AllClientOpts  = StrTok("GodMode;Unlimited Ammo;All Perks;Freeze / Unfreeze;", ";");
    level.AllClientFuncs = StrTok("AllGod;AllAmmo;AllCPerks;FreezeAll;",";");
    level._WeaponsMP     = StrTok("ar_standard;ar_accurate;ar_cqb;ar_damage;ar_longburst;ar_marksman;ar_fastburst;smg_standard;smg_versatile;smg_capacity;smg_fastfire;smg_burst;smg_longrange;shotgun_pump;shotgun_semiauto;shotgun_fullauto;shotgun_precision;lmg_light;lmg_cqb;lmg_slowfire;lmg_heavy;sniper_fastsemi;sniper_fastbolt;sniper_chargeshot;sniper_powerbolt;pistol_standard;pistol_burst;pistol_fullauto;launcher_standard;launcher_lockonly;knife;knife_loadout",";");
    level.songName       = strTok("Samantha's Lullaby;Dead Ended;Blood of Stalingrad;King of the Hill;Samantha's Sorrow;Damned;Damned 100AE;Damned 3;The Gift;Archangel;Dead Again;The Gift;WTF;Aether;Blood Red Moon;Death Bell;Desolation;High Noon;Mask Walk;Ouest Noir;Richtofen's Delight;Samantha's Desire;Short Arm of the Law;Buried (Theme);Undone;Revelations;A Rising Power;One Way Out;Flesh and Bone;Crypt;Samantha's Journey;Remember Forever;The End Is Near;Nightmare;Not Ready To Die;Shepherd of Fire;Platform of Dreams;Legendary;Skulls of the Damned;Arachnophobia;Betrayal;Zetsubou No Shima;Through The Trees;Snake Skin Boots;Cold Hard Cash;Snake Skin Boots (Instrumental);Lullaby For a Dead Man;The One;Beauty Of Annihilation;115;Abra Cadavre;Pareidolia;Coming Home;Carrion;We All Fall Down;Always Running;Where Are We Going;Archangel;Beauty Of Annihilation (Giant Mix);Damned 3;", ";");
    level.Songs          = strTok("mus_samanthas_lullaby_magicmix_intro;mus_dead_ended_intro;mus_blood_of_stalingrad_intro;mus_king_of_the_hill_intro;mus_samanthas_sorrow_intro;mus_damned_intro;mus_damned_2_intro;mus_damned_25_intro;mus_the_gift_intro;mus_archangel_theatrical_mix_intro;mus_dead_again_theatrical_mix_intro;mus_the_gift_theatrical_intro;mus_wtf_intro;mus_aether_intro;mus_blood_red_moon_intro;mus_death_bell_intro;mus_desolation_intro;mus_high_noon_intro;mus_maskwalk_intro;mus_quest_noir_intro;mus_richtofans_delight_intro;mus_samanthas_desire_intro;mus_short_arm_of_the_law_intro;mus_theme_from_buried_intro;mus_undone_intro;mus_revelations_intro;mus_a_rising_power_intro;mus_one_way_out_intro;mus_flesh_and_bone_intro;mus_crypt_intro;mus_sam_journey_intro;mus_remember_forever_intro;mus_the_end_is_near_intro;mus_nightmare_intro;mus_not_ready_to_die_intro;mus_shepherd_of_fire_intro;mus_platform_of_dreams_intro;mus_legendary_intro;mus_skulls_of_the_damned_intro;mus_arachnophobia_intro;mus_betrayal_intro;mus_zetsubou_no_shima_intro;mus_through_the_trees_intro;mus_snake_skin_boots_intro;mus_cold_hard_cash_intro;mus_snake_skin_intrumental_intro;mus_lullaby_for_a_dead_man_intro;mus_the_one_intro;mus_beauty_of_annihilation_intro;mus_115_intro;mus_abra_cadavre_intro;mus_pareidolia_intro;mus_coming_home_intro;mus_carrion_intro;mus_we_all_fall_down_intro;mus_always_running_intro;mus_where_are_we_going_intro;mus_archangel_intro;mus_beauty_the_giant_mix_intro;mus_zm_lobby_intro;", ";");
}

onPlayerSpawned()
{
    if(self IsHost())
    {
        self thread initializeSetup(5, self);
    }
    else
    {
        self.access = 0;
    }
    SetDvar("sv_cheats",1);
    }
    
#endif