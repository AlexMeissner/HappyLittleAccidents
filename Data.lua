-- Instance IDs: https://wow.gamepedia.com/InstanceID
local data =
{
    -- De Other Side
    -- Spell IDs: https://www.wowhead.com/guides/de-other-side-shadowlands-dungeon-strategy-guide
    [2291] = 
    {
        -- Trash
        [328729] = { Tag="Environment" }, -- Dark Lotus
        [328707] = { Tag="Cast" }, -- Scribe
        [333729] = { Tag="Frontal" }, -- Trollguard
        [333250] = { Tag="Environment" }, -- Reaver
        [334076] = { Tag="Cast" }, -- Shadowcore
        [334051] = { Tag="Knockback", HasAggro = false }, -- Erupting Darkness
        [323544] = { Tag="Cast" }, -- Blood Nova
        [323569] = { Tag="Environment" }, -- Spilled Essence
        [332705] = { Tag="Cast" }, -- Smite
        [332608] = { Tag="Cast" }, -- Lightning Discharge
        [332605] = { Tag="CC" }, -- Hex
        [332672] = { Tag="Proximity" }, -- Bladestorm
        [342869] = { Tag="Proximity" }, -- Enraged Mask
        [333790] = { Tag="Proximity" }, -- Enraged Mask
        [331933] = { Tag="LoS" }, -- Haywire
        [331846] = { Tag="Dodge" }, -- W-00F
        [332196] = { Tag="Cast" }, -- Discharge
        [332157] = { Tag="Proximity" }, -- Spinning Up
        -- Volatile Capacitor [???] = { Tag="???" }, -- Volatile Capacitor
        [331381] = { Tag="Cast" }, -- Lubricate
        [332234] = { Tag="Cast" }, -- Essential Oil
        [340026] = { Tag="Proximity" }, -- Wailing Grief
    },
    
    -- Halls of Atonment
    -- Spell IDs: https://www.wowhead.com/guides/halls-of-atonement-shadowlands-dungeon-strategy-guide
    [2287] = 
    {
        -- Trash
        [325523] = { Tag="Frontal" }, -- Deadly Thrust
        [325799] = { Tag="Dodge" }, -- Rapid Fire
        [338003] = { Tag="Cast" }, -- Wicked Bolt
        [325876] = { Tag="Proximity" }, -- Curse of Obliteration
        [325700] = { Tag="Cast" }, -- Collect Sins
        [325701] = { Tag="Cast" }, -- Siphon Life
        [326409] = { Tag="Proximity" }, -- Thrash
        [326438] = { Tag="Dodge" }, -- Sin Quake
        [326623] = { Tag="Proximity" }, -- Reaping Strike
        [326607] = { Tag="Cast" }, -- Turn to Stone
        [326771] = { Tag="Cast" }, -- Stone Watcher
        [326997] = { Tag="Frontal" }, -- Powerful Swipe
        [326829] = { Tag="Cast" }, -- Wicked Bolt
        [346866] = { Tag="Frontal" }, -- Stone Breathe

        -- Halkias, the Sin-Stained Goliath

        -- Echelon

        -- Aleez Adjudicator Aleez

        -- Lord Chamerlain
    },
    
    -- Mists of Tirna Scithe
    [2290] = 
    {

    },
    
    -- Plaguefall
    [2289] = 
    {
        
    },
    
    -- Sanguine Depth
    [2284] = 
    {
        
    },
    
    -- Spires of Ascension
    [2285] = 
    {

    },
    
    -- The Necrotic Wake
    [2286] = 
    {            
        [320596] = { IsTarget = false }, -- Heaving Retch
    },
    
    -- Theater of Pain
    [2293] = 
    {

    },

    -- Castle Nathria
    [2296] =
    {
        -- Shriekwing
        [343005] = { IsTarget = false }, -- Blind Swipe
        [330712] = { }, -- Earsplitting Shriek
        [343022] = { }, -- Echoing Sonar

        -- Huntsman Altimor
        [334404] = { IsTarget = false }, -- Spreadshot
        [334708] = { }, -- Deathly Roar
        
        -- Sung King's Salvation
        -- TODO
        
        -- Artificer Xy'mox
        [329256] = { }, -- Rift Blast
        [327414] = { }, -- Possession

        -- Hungering Destroyer
        -- %

        -- Lady Inerva Darkvein
        -- TODO

        -- The Council of Blood
        -- TODO: Got hit by dancer
        [327610] = { HasAggro = false }, -- Evasive Lunge
        [337110] = { }, -- Dreadbolt Volley
        [330848] = { }, -- Wrong Moves

        -- Sludgefist
        -- TODO
        [332572] = { }, -- Falling Rubble
        [335295] = { }, -- Shattering Chain

        -- Stone Legion Generals
        -- TODO

        -- Sire Denathrius
        -- TODO

        -- The Council of Blood
        
        [337110] = { }, -- Dreadbolt Volley
    },
}

function GetADMData()
    return data
end