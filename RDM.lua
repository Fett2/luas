-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Composure
--              [ CTRL+- ]          Light Arts/Addendum: White
--              [ CTRL+= ]          Dark Arts/Addendum: Black
--              [ CTRL+; ]          Celerity/Alacrity
--              [ ALT+[ ]           Accesion/Manifestation
--              [ ALT+; ]           Penury/Parsimony
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+Q ]           Temper
--              [ ALT+W ]           Flurry II
--              [ ALT+E ]           Haste II
--              [ ALT+R ]           Refresh II
--              [ ALT+Y ]           Phalanx
--              [ ALT+O ]           Regen II
--              [ ALT+P ]           Shock Spikes
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--              [ ALT+D ]            Dispel
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--              [ ALT+W  ]          Toggle Weapons
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad1 ]    Sanguine Blade
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--              Addendum Commands:
--              Shorthand versions for each strategem type that uses the version appropriate for
--              the current Arts.
--                                          Light Arts                  Dark Arts
--                                          ----------                  ---------
--              gs c scholar light          Light Arts/Addendum
--              gs c scholar dark                                       Dark Arts/Addendum
--              gs c scholar cost           Penury                      Parsimony
--              gs c scholar speed          Celerity                    Alacrity
--              gs c scholar aoe            Accession                   Manifestation
--              gs c scholar addendum       Addendum: White             Addendum: Black


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    include('Mote-TreasureHunter')
	state.CP = M(false, "Capacity Points Mode")
    state.Buff.Saboteur = buffactive.Saboteur or false
    state.Buff.Stymie = buffactive.Stymie or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
        "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II',  'Gravity', 'Gravity II', 'Silence'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga', 'Blind', 'Blind II'}
    enfeebling_magic_sleep = S{'Sleep', 'Sleep II', 'Sleepga'}

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

    
    lockstyleset = 6
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.EnSpell = M{['description']='EnSpell', 'Enfire', 'Enblizzard', 'Enaero', 'Enstone', 'Enthunder', 'Enwater'}
    state.BarElement = M{['description']='BarElement', 'Barfire', 'Barblizzard', 'Baraero', 'Barstone', 'Barthunder', 'Barwater'}
    state.BarStatus = M{['description']='BarStatus', 'Baramnesia', 'Barvirus', 'Barparalyze', 'Barsilence', 'Barpetrify', 'Barpoison', 'Barblind', 'Barsleep'}
    state.GainSpell = M{['description']='GainSpell', 'Gain-STR', 'Gain-INT', 'Gain-AGI', 'Gain-VIT', 'Gain-DEX', 'Gain-MND', 'Gain-CHR'}

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')
    state.SleepMode = M{['description']='Sleep Mode', 'Normal', 'MaxDuration'}
	state.EnspellMode = M{['description']='Enspell Mode', 'None', 'Enspell Melee Mode', 'Enspell Melee Mode Acc'}
    state.NM = M(false, 'NM')
    state.CP = M(false, "Capacity Points Mode")
    state.WeaponMode = M{['description']='Weapon Mode','Crocea Bunzi','Crocea Daybreak','Naegling Machaera', 'Crocea Levante', 'Maxentius Machaera', 'Lvl1Daggers', 'Aeolian Edge'}
    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
 --   include('Global-GEO-Binds.lua') -- OK to remove this line
    include('organizer-lib')
	include('sendbinds.lua')
--	send_command('org organize')
--	send_command('lua l equipviewer')
--	send_command('equipviewer pos 2160 400')
	send_command('lua l partybuffs')
	
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua l gearinfo')
    end

    send_command('bind ^` input /ja "Composure" <me>')
    send_command('bind !` gs c toggle MagicBurst')

    if player.sub_job == 'SCH' then
        send_command('bind ^- gs c scholar light')
        send_command('bind ^= gs c scholar dark')
        send_command('bind !- gs c scholar addendum')
        send_command('bind != gs c scholar addendum')
        send_command('bind ^; gs c scholar speed')
        send_command('bind ![ gs c scholar aoe')
        send_command('bind !; gs c scholar cost')
    end

    send_command('bind !q input /ma "Temper II" <me>')
--    send_command('bind !w input /ma "Flurry II" <stpc>')
    send_command('bind !e input /ma "Haste II" <stpc>')
    send_command('bind !r input /ma "Refresh III" <stpc>')
    send_command('bind !y input /ma "Phalanx II" <stpc>')
    send_command('bind !o input /ma "Regen II" <stpc>')
--    send_command('bind !p input /ma "Shock Spikes" <me>')
	send_command('bind !d input /ma "Dispel" <t>')
    send_command('bind !c /convert <me>')
    send_command('bind ^t gs c cycle treasuremode')
    send_command('bind !insert gs c cycleback EnSpell')
    send_command('bind !delete gs c cycle EnSpell')
    send_command('bind ^insert gs c cycleback GainSpell')
    send_command('bind ^delete gs c cycle GainSpell')
    send_command('bind ^home gs c cycleback BarElement')
    send_command('bind ^end gs c cycle BarElement')
    send_command('bind ^pageup gs c cycleback BarStatus')
    send_command('bind ^pagedown gs c cycle BarStatus')
	send_command('bind ^a input /ma "Addle II" <t>')
	send_command('bind ^c input /ma "Cursna" <stal>')
	send_command('bind ^x input /ma "Viruna" <stal>')
	send_command('bind ^z input /ma "Poisona" <stal>')
    send_command('bind ^s input /ja "Stymie" <me>')
--	send_command('bind ^s input /ma "Stona" <stal>')
	send_command('bind !s input /ja "Saboteur" <me>')
	send_command('bind !x input /ja "Spontaneity" <me>')
    send_command('bind @s gs c cycle SleepMode')
    send_command('bind @e gs c cycle EnspellMode')
	send_command('bind @d gs c toggle NM')
	send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')
    send_command('bind !w gs c cycle WeaponMode')
	send_command('bind ^g input /ma "Gravity" <t>')
	send_command('bind !g input /ma "Gravity II" <t>')
    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad9 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad4 input /ws "Requiescat" <t>')
    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Red Lotus Blade" <t>')
    send_command('bind ^numpad3 input /ws "Flat Blade" <t>')
	send_command('bind ^d input /ma "Dispelga" <t>')
	send_command('bind ^b input /ma "Break" <t>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()

--    Haste = 0
--    DW_needed = 0
--    DW = false
--    moving = false
--    update_combat_form()
--    determine_haste_group()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
	send_command('unbind ^t')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^;')
    send_command('unbind ![')
    send_command('unbind !;')
    send_command('unbind !q')
    send_command('unbind !w')
	send_command('unbind !x')
    send_command('bind !e input /ma "Haste" <stpc>')
    send_command('bind !r input /ma "Refresh" <stpc>')
    send_command('bind !y input /ma "Phalanx" <me>')
    send_command('unbind !o')
    send_command('unbind !p')
	send_command('unbind !s')
    send_command('unbind @s')
    send_command('unbind @e')
    send_command('unbind @d')
    send_command('unbind @w')
	send_command('unbind ^w')
    send_command('unbind @c')
    send_command('unbind @r')
    send_command('unbind !insert')
    send_command('unbind !delete')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind ^home')
    send_command('unbind ^end')
    send_command('unbind ^pageup')
    send_command('unbind ^pagedown')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
	send_command('unbind ^c')
	send_command('unbind ^z')
	send_command('unbind ^x')
	send_command('unbind !d')
    send_command('unbind ^c')
	send_command('unbind ^s')
    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
	send_command('unbind ^d')
	send_command('unbind ^b')

    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua u gearinfo')
    end
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Actions we want to use to tag TH.
    sets.TreasureHunter = {
        head="Wh. Rarab Cap +1",
        hands={ name="Chironic Gloves", augments={'VIT+11','"Store TP"+4','"Treasure Hunter"+2','Accuracy+14 Attack+14',}},
        waist="Chaac Belt",
        }
    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +3"}
    sets.precast.JA['Convert'] =
	{
	main="Murgleis"
--    head="Nahtirah Hat",
--    body="Atrophy Tabard +3",
--    hands="Regal Cuffs",
--    legs="Atrophy Tights +3",
--    feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
--    neck="Bathy Choker +1",
--    waist="Eschan Stone",
--    left_ear="Eabani Earring",
--    right_ear="Etiolation Earring",
--    left_ring="Ilabrat Ring",
    }
    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Impatiens",
		head="Atrophy Chapeau +3", --16
        body="Viti. Tabard +3", --15
		ring1="Lebeche Ring",
		ring2="Weather. Ring +1",
		waist="Witful Belt",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        }

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ammo="Impatiens", --(2)
        ring1="Lebeche Ring", --(2)
        ring2="Weather. Ring +1",
		back="Perimede Cape", --(4)
        waist="Witful Belt", --3/(3)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.Impact = set_combine(sets.precast.FC, {
        ammo="Sapience Orb", --2
        head=empty,
        body="Twilight Cloak",
        hands="Leyline Gloves", --6
        neck="Voltsurge Torque", --5
		legs="Aya. Cosciales +2",
        ear1="Malignance Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        back="Swith Cape +1", --4
        waist="Witful Belt", --3/(3)
        })
    
	sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})
    sets.precast.Storm = set_combine(sets.precast.FC, {name="Stikini Ring +1",})
    sets.precast.FC.Utsusemi = sets.precast.FC.Cure


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Voluspa Tathlum",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
		feet="Leth. Houseaux +3",
--        feet="Nyame sollerets",
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Rufescent Ring",
        ring2="Epaminondas's Ring",
        back={ name="Sucellos's Cape", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','STR+10','Weapon skill damage +10%',}},
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        body="Jhakri Robe +2",
        neck="Combatant's Torque",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head={ name="Taeon Chapeau", augments={'Accuracy+19 Attack+19','Crit.hit rate+3','Crit. hit damage +3%',}},
        body="Ayanmo Corazza +2",
        hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
        feet="Thereoid Greaves",
        ear1="Sherida Earring",
		ear2="Mache Earring +1",
        ring1="Begrudging Ring",
        ring2="Ilabrat Ring",
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
        })

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        neck="Rep. Plat. Medal",
--        ear2="Sherida Earring",
        waist="Sailfi Belt +1",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
        })

    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        neck="Combatant's Torque",
        ear2="Telos Earring",
        waist="Grunfeld Rope",
        })
    
	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']
    
	sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['Death Blossom'].Acc = sets.precast.WS['Savage Blade'].Acc

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
        ammo="Regal Gem",
        ear2="Sherida Earring",
        ring2="Shukuyu Ring",
        })

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        neck="Combatant's Torque",
        ear1="Mache Earring +1",
        ring1="Ramuh Ring +1",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Sanguine Blade'] = {
        ammo="Pemphredo Tathlum",
        head="Pixie Hairpin +1",
        body="Nyame Mail",
        hands="Jhakri Cuffs +2",
        legs="Nyame Flanchard",
		feet="Leth. Houseaux +3",
--        feet="Nyame sollerets",
        neck="Baetyl Pendant",
        ear1="Friomisi Earring",
        ear2="Regal Earring",
        ring1="Archon Ring",
        ring2="Metamorph ring +1",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
        waist="Orpheus's Sash",
        }

    sets.precast.WS['Seraph Blade'] = {
        ammo="Pemphredo Tathlum",
        head="Nyame Helm",
--        head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Enmity-4','INT+11','Mag. Acc.+2','"Mag.Atk.Bns."+11',}},
        body="Nyame Mail",
        hands="Jhakri Cuffs +2",
        legs="Nyame Flanchard",
		feet="Leth. Houseaux +3",
--        feet="Nyame sollerets",
        neck="Baetyl Pendant",
        ear1="Moonshade Earring",
        ear2="Regal Earring",
        ring1="Weather. Ring +1",
        ring2="Metamorph ring +1",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},
        waist="Orpheus's Sash",
        }
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Seraph Blade'], {
        ring1="Freke Ring",
		ring2="Epaminondas's Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+10','Weapon skill damage +10%',}},
		 })
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast.Cure = {
        main="Daybreak", --22/
        sub="Sors Shield", --3/(-5)
        ammo="Esper Stone +1", --0/(-5)
        head="Kaykaus Mitra +1", --11(+2)/(-6)
        body="Kaykaus Bliaut +1", --(+4)/(-6)
        hands="Kaykaus Cuffs +1", --11(+2)/(-6)
        legs="Kaykaus Tights +1", --11(+2)/(-6)
--        legs="Atrophy Tights +3", --
        feet="Kaykaus Boots +1", --11(+2)/(-12)
        neck="Incanter's Torque",
        ear1="Mendi. Earring", --5
        ear2="Meili Earring",
        ring1="Sirona's Ring", --3/
        ring2="Haoma's Ring",
        back={ name="Sucellos's Cape", augments={'MND+20','MND+10','"Cure" potency +10%',}}, --(-10)
        waist="Bishop's Sash",
        }

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main="Chatoyant Staff",
        sub="Achaq Grip", --0/(-4)
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
        })

    sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
--        hands="Buremte Gloves", -- (13)
        neck="Phalaina Locket", -- 4(4)
        ring2="Asklepian Ring", -- (3)
        waist="Gishdubar Sash", -- (10)
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        ammo="Regal Gem",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        waist="Luminary Sash",
        })

    sets.midcast.StatusRemoval = {
        head="Vanya Hood",
        body="Vanya Robe",
        legs="Atrophy Tights +3",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        ear2="Healing Earring",
        ring1="Menelaus's Ring",
        ring2="Haoma's Ring",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        waist="Bishop's Sash",
        }

    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        hands="Hieros Mittens",
        body="Viti. Tabard +3",
        neck="Malison Medallion",
        ear1="Beatific Earring",
        back="Oretan. Cape +1",
        })

    sets.midcast['Enhancing Magic'] = {
        main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','Mag. Acc.+19','"Mag.Atk.Bns."+8','DMG:+6',}},
        sub="Ammurapi Shield",
        ammo="Regal Gem",
        head="Befouled Crown",
        body="Viti. Tabard +3",
        hands="Atrophy Gloves +3",
        legs="Atrophy Tights +3",
        feet="Leth. Houseaux +3",
        neck="Incanter's Torque",
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        back="Ghostfyre Cape",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        main={ name="Colada", augments={'Enh. Mag. eff. dur. +4','Mag. Acc.+19','"Mag.Atk.Bns."+8','DMG:+6',}},
        sub="Ammurapi Shield",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        body="Viti. Tabard +3",
        hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
        feet="Leth. Houseaux +3",
        neck="Dls. Torque +2",
        back="Ghostfyre Cape",
		waist="Embla Sash",
        }
	sets.midcast.BarElement = set_combine(sets.midcast.EnhancingDuration, {
		legs="Shedir Seraweels",
		})

    sets.midcast.EnhancingSkill = {
        main="Pukulatmuj +1",
        sub="Forfend +1",
        hands="Viti. Gloves +3",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','"Regen" potency+3',}},
		hands={ name="Telchine Gloves", augments={'"Conserve MP"+5','"Regen" potency+3',}},
		legs={ name="Telchine Braconi", augments={'"Conserve MP"+5','"Regen" potency+3',}},
        feet="Bunzi's Sabots",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1", -- +1
        body="Atrophy Tabard +3", -- +3
        legs="Leth. Fuseau +2", -- +2
        })

    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
        waist="Gishdubar Sash",
        back="Grapevine Cape",
		feet="Inspirited Boots",
        })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
        waist="Siegel Sash",
		legs="Shedir Seraweels",
		ear1="Earthcry Earring",
        })

    sets.midcast['Phalanx'] = set_combine(sets.midcast.EnhancingDuration, {
        main="Sakpata's Sword", 
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+11 "Mag.Atk.Bns."+11','Accuracy+24','Phalanx +5',}}, --5
        head={ name="Merlinic Hood", augments={'MND+4','Sklchn.dmg.+2%','Phalanx +4',}}, --4
		hands=gear.Taeon_Phalanx_hands, --3(10)
        legs={ name="Chironic Hose", augments={'AGI+3','Enmity-1','Phalanx +4','Mag. Acc.+20 "Mag.Atk.Bns."+20',}}, --4
        feet={ name="Merlinic Crackows", augments={'Attack+10','Weapon skill damage +1%','Phalanx +5','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}, --5
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1",
        waist="Emphatikos Rope",
		legs="Shedir Seraweels",
        })

    sets.midcast.Storm = sets.midcast.EnhancingDuration
    sets.midcast.GainSpell = {hands="Viti. Gloves +3"}
    sets.midcast.SpikesSpell = {legs="Viti. Tights +3"}

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell


     -- Custom spell classes
    sets.midcast.MndEnfeebles = {
        main="Daybreak",
        sub="Ammurapi Shield",
        ammo="Regal Gem",
        head="Viti. Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Kaykaus Cuffs +1",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+27','MND+14',}},
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        ear1="Malignance earring",
        ear2="Snotra Earring",
		ring1="Kishar Ring",
        ring2="Metamor. Ring +1",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        waist="Obstin. Sash",
--        waist="Luminary Sash",
        }

    sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
        main="Murgleis",
        sub="Ammurapi Shield",
        range="Ullr",
        ammo=empty,
        head="Atrophy Chapeau +3",
        body="Atrophy Tabard +3",
     	ear1="Regal Earring",
--        ring1={name="Stikini Ring +1", bag="wardrobe3"},
--        waist="Acuity Belt +1",
        })

    sets.midcast.MndEnfeeblesEffect = set_combine(sets.midcast.MndEnfeebles, {
        ammo="Regal Gem",
        body="Lethargy Sayon +2",
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        })
		
    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Maxentius",
        sub="Ammurapi Shield",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+30','"Resist Silence"+7','INT+14','"Mag.Atk.Bns."+13',}},
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		waist="Acuity Belt +1",
		})

    sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.IntEnfeebles, {
        main="Murgleis",
        sub="Ammurapi Shield",
        range="Ullr",
        ammo=empty,
        head="Atrophy Chapeau +3",
		body="Atrophy Tabard +3",
		ear1="Regal Earring",
--      ring2="Weather. Ring +1",
        waist="Acuity Belt +1",
        })

    sets.midcast.IntEnfeeblesEffect = set_combine(sets.midcast.IntEnfeebles, {
        ammo="Regal Gem",
        body="Lethargy Sayon +2",
        feet="Vitiation Boots +3",
        neck="Dls. Torque +2",
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        })

    sets.midcast.SkillEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Contemplator +1",
--        main={ name="Grioavolr", augments={'Enfb.mag. skill +10','MND+11','Mag. Acc.+27',}},
		sub="Enki Strap",
        head="Viti. Chapeau +3",
        body="Atrophy Tabard +3",
        hands="Leth. Ganth. +2",
        feet="Vitiation Boots +3",
        neck="Incanter's Torque",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        ear1="Vor Earring",
        ear2="Snotra Earring",
        waist="Rumination Sash",
        })

    sets.midcast.EffectEnfeebles = {
        ammo="Regal Gem",
        body="Lethargy Sayon +2",
        feet="Vitiation Boots +3",
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        }

    sets.midcast.Sleep = set_combine(sets.midcast.IntEnfeeblesAcc, {
        head="Viti. Chapeau +3",
        neck="Dls. Torque +2",
        ear2="Snotra Earring",
        ring1="Kishar Ring",
        })

    sets.midcast.SleepMaxDuration = set_combine(sets.midcast.Sleep, {
        head="Leth. Chappel +2",
        body="Lethargy Sayon +2",
        hands="Regal Cuffs",
        legs="Leth. Fuseau +2",
        feet="Leth. Houseaux +3",
        })

    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles
    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeeblesAcc, {
		main="Daybreak", 
		sub="Ammurapi Shield",
		head="Wh. Rarab Cap +1",
        hands={ name="Chironic Gloves", augments={'VIT+11','"Store TP"+4','"Treasure Hunter"+2','Accuracy+14 Attack+14',}},
        waist="Chaac Belt",
		})
	
	
    sets.midcast['Dark Magic'] = {
        main="Murgleis",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Atrophy Chapeau +3",
        body="Atrophy Tabard +3",
        hands="Kaykaus Cuffs +1",
        legs={ name="Chironic Hose", augments={'Mag. Acc.+30','"Resist Silence"+7','INT+14','"Mag.Atk.Bns."+13',}},
        feet="Vitiation Boots +3",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        waist="Luminary Sash",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        feet="Merlinic Crackows",
        ear1="Hirudinea Earring",
        ring1="Archon Ring",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain
    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {waist="Luminary Sash"})
    sets.midcast['Bio III'] = set_combine(sets.midcast['Dark Magic'], {legs="Viti. Tights +3"})

    sets.midcast['Elemental Magic'] = {
        main="Bunzi's Rod",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
--        head={ name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Enmity-4','INT+11','Mag. Acc.+2','"Mag.Atk.Bns."+11',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
        neck="Baetyl Pendant",
        ear1="Friomisi Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2={"Metamor. Ring +1"},
        back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        waist="Sacro Cord",
        }

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        body="Seidr Cotehardie",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
		waist="Acuity Belt +1",
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        ear1="Hermetic Earring",
        waist="Yamabuki-no-Obi",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        range="Ullr",
        ammo=empty,
		body="Twilight Cloak",
        hands="Regal Cuffs",
		Neck="Dls. Torque +2",
		ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
		ear1="Malignance Earring",
		ear2="Regal Earring",
		waist="Luminary Sash",
        })

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    -- Job-specific buff sets
    sets.buff.ComposureOther = {
        head="Leth. Chappel +2",
--        body="Lethargy Sayon +2",
 --       hands="Leth. Ganth. +2",
        legs="Leth. Fuseau +2",
        feet="Leth. Houseaux +3",
        }
	
	sets.buff.ComposureOtherRefresh = set_combine(sets.buff.ComposureOther, {
	    head="Amalric Coif +1", -- +1
 --       body="Atrophy Tabard +3", -- +3
	})
	
    sets.buff.Saboteur = {hands="Leth. Ganth. +2"}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
--        main="Crocea Mors",
        main={ name="Colada", augments={'"Refresh"+2','STR+9','Mag. Acc.+10',}},
        sub="Sacro Bulwark",
        ammo="Homiliary",
        head="Viti. Chapeau +3",
--        body="Jhakri Robe +2",
		body="Lethargy Sayon +2",
        hands={ name="Chironic Gloves", augments={'Pet: DEX+12','MND+7','"Refresh"+2','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
        legs="Malignance Tights",
        feet={ name="Chironic Slippers", augments={'VIT+5','AGI+8','"Refresh"+2','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Etiolation Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine(sets.idle, {
--        main="Bolelabunga",
        sub="Sacro Bulwark", --10/0
        ammo="Staunch Tathlum +1", --3/3
        head="Malignance Chapeau",
        body="Malignance Tabard", --6/6
        hands="Malignance Gloves", --4/4
        legs="Malignance Tights", --5/0
        feet="Malignance Boots",
        neck="Loricate Torque +1", --6/6
--       ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        waist="Carrier's Sash",
        })

    sets.idle.Town = set_combine(sets.idle, {
        main="Murgleis",
        head="Nyame Helm",
        body="Shamash Robe",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame sollerets",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        waist="Flume Belt +1",
        })

    sets.idle.Weak = sets.idle.DT

    sets.resting = set_combine(sets.idle, {
--        main="Chatoyant Staff",
        waist="Shinjutsu-no-Obi +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.magic_burst =  set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB, --5
        head="Ea Hat",
--        body=gear.Merl_MB_body, --10
        hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}}, --(6)
--        legs="Merlinic Shalwar", --2
--        feet="Merlinic Crackows", --11
        neck="Mizu. Kubikazari", --10
		legs="Ea Slops",
		feet="Ea Pigaches",
        ring1="Mujin Band", --(5)
        })

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    sets.engaged = {
--        main="Crocea Mors",
--        sub="Daybreak",
        ammo="Ginsen",
        head="Bunzi's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1",
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
--        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
        waist="Windbuffet Belt +1",
        }
    sets.engaged.Magical = {
 		main="Crocea Mors",
        sub="Sacro Bulwark",
        }
    sets.engaged.Physical = {
 		main="Naegling",
        sub="Sacro Bulwark",
        }
    sets.engaged.Enaero = {
 		main="Crocea Mors",
        sub="Sacro Bulwark",
        }		
    sets.engaged.Daggers = {
        main="Qutrub Knife",
        sub="Sacro Bulwark",
        }
	sets.engaged.AE = {
	    main="Tauret",
		sub="Sacro Bulwark",
		}
	sets.engaged.Club = {
	    main="Maxentius",
		sub="Sacro Bulwark",
		}
    sets.engaged.MidAcc = set_combine(sets.engaged, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
--        main="Almace",
--		sub="Ternion Dagger +1",
--        main="Crocea Mors",
--        sub="Daybreak",
-- 		main="Naegling",
--        sub="Machaera +2",
--        main="Qutrub Knife",
--        sub="Ceremonial Dagger",
--        sub="Levante Dagger",
        ammo="Ginsen",
        head="Bunzi's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1", --6
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Anu Torque",
        ear1="Suppanomimi", --5
		ear2="Eabani Earring", --4
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
--        ring2={name="Chirich Ring +1", bag="wardrobe4"},
 --       back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } --41

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head="Bunzi's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1", --6
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Anu Torque",
        ear1="Suppanomimi", --5
		ear2="Eabani Earring", --4
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
--        ring2={name="Chirich Ring +1", bag="wardrobe4"},
 --       back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        }) --41

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        neck="Combatant's Torque",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        head="Carmine Mask +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head="Bunzi's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1", --6
        feet="Malignance Boots",
--        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Anu Torque",
        ear1="Suppanomimi", --5
		ear2="Eabani Earring", --4
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
--        ring2={name="Chirich Ring +1", bag="wardrobe4"},
 --       back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        }) --32

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        legs="Carmine Cuisses +1", --6
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ear2="Telos Earring",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head="Bunzi's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1", --6
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
--        ear2="Telos Earring",
        ear2="Eabani Earring", --4
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
--       back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        }) --27

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        legs="Carmine Cuisses +1", --6
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged.DW, {
        ammo="Ginsen",
        head="Bunzi's Hat",
        body="Malignance Tabard",
        hands="Malignance Gloves",
        legs="Carmine Cuisses +1",
        feet="Malignance Boots",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
		 --       back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Windbuffet Belt +1",
        }) --10

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1", --6
        ear1="Cessance Earring",
        ear2="Mache Earring +1",
        ring1="Ramuh Ring +1",
        waist="Olseni Belt",
        })
    sets.engaged.DW.Magical = {
 		main="Crocea Mors",
        sub="Bunzi's Rod",
        }
	sets.engaged.DW.Magical2 = {
 		main="Crocea Mors",
        sub="Daybreak",
        }	
    sets.engaged.DW.Physical = {
 		main="Naegling",
        sub="Machaera +2",
        }
    sets.engaged.DW.Enaero = {
 		main="Crocea Mors",
        sub="Levante Dagger",
        }		
    sets.engaged.DW.Daggers = {
        main="Qutrub Knife",
        sub="Aern Dagger",
        }
	sets.engaged.DW.AE = {
	    main="Tauret",
		sub="Bunzi's Rod",
		}
	sets.engaged.DW.Club = {
	    main="Maxentius",
		sub="Machaera +2",
		}
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Bunzi's Hat", --6
        body="Malignance Tabard",  --9
--        hands="Aya. Manopolas +2",
		hands="Malignance Gloves",  --5
--		neck="Loricate Torque +1", --6/6
        legs="Malignance Tights",
		feet="Malignance Boots",  --4
		ring1="Defending ring",
		ring2={name="Chirich Ring +1", bag="wardrobe1"},
--		waist="Orpheus's Sash",
		--       back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.Enspell = {
	hands="Aya. Manopolas +2",
	waist="Orpheus's Sash",
	neck="Anu Torque",
	ring1={name="Chirich Ring +1", bag="wardrobe3"},
    ring2={name="Chirich Ring +1", bag="wardrobe1"},
	ammo="Sroda Tathlum"
	}
	
	sets.engaged.Enspell.Acc = {
	range="Ullr",
	ammo=empty,
	hands="Aya. Manopolas +2",
	waist="Orpheus's Sash",
	neck="Dls. Torque +2",
	ear1="Digni. Earring",
    ear2="Telos Earring", 
	ring1={name="Chirich Ring +1", bag="wardrobe3"},
    ring2={name="Chirich Ring +1", bag="wardrobe1"}
	}
    sets.engaged.Enspell.Fencer = {ring1="Fencer's Ring"}
	
	sets.engaged.Doom = {
--        neck="Nicander's Necklace", --20
        ring1="Eshmun's Ring", --20
        ring2="Purity Ring",
        waist="Gishdubar Sash", --10
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = sets.engaged.Doom

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    data.weaponskills.elemental = S{'Wildfire','Leaden Salute','Sanguine Blade','Aeolian Edge','Cataclysm','Trueflight','Tachi: Jinpu','Flash Nova'}
	if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
    if spell.english == "Phalanx II" and spell.target.type == 'SELF' then
        cancel_spell()
        send_command('@input /ma "Phalanx" <me>')
    end
	if spell.type == 'WeaponSkill' then
        if state.WeaponskillMode.value ~= 'Proc' and data.weaponskills.elemental:contains(spell.english) then
                if spell.element and spell.element == world.weather_element and world.weather_intensity == 2 then
                    equip({waist="Hachirin-no-Obi"})
                elseif spell.target.distance < 3 then
                    equip({waist="Orpheus's Sash"})
                elseif spell.element and spell.element == world.weather_element and spell.element == world.day_element then
                    equip({waist="Hachirin-no-Obi"})
                elseif spell.target.distance < 8 then
                    equip({waist="Orpheus's Sash"})
                elseif spell.element and (spell.element == world.weather_element or spell.element == world.day_element) then
                    equip({waist="Hachirin-no-Obi"})
                end
    end
end
end
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Sleep II' then
        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end
    end
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
                if spell.target.type == 'SELF' then
                    equip (sets.midcast.RefreshSelf)
                end
            end
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif spell.english:startswith('Gain') then
            equip(sets.midcast.GainSpell)
        elseif spell.english:contains('Spikes') then
            equip(sets.midcast.SpikesSpell)
        end
        if (spell.target.type == 'PLAYER' or spell.target.type == 'NPC') and buffactive.Composure and spellMap ~= 'Refresh' then
            equip(sets.buff.ComposureOther)
        end
    end
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:contains('Sleep') and not spell.interrupted then
        set_sleep_timer(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub','ranged','ammo')
    else
        enable('main','sub','ranged','ammo')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
	update_combat_form()
    determine_haste_group()
	check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
        if spell.skill == 'Enfeebling Magic' then
            if enfeebling_magic_skill:contains(spell.english) then
                return "SkillEnfeebles"
            elseif spell.type == "WhiteMagic" then
                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                    return "MndEnfeeblesAcc"
                elseif enfeebling_magic_effect:contains(spell.english) then
                    return "MndEnfeeblesEffect"
                else
                    return "MndEnfeebles"
              end
            elseif spell.type == "BlackMagic" then
                if enfeebling_magic_acc:contains(spell.english) and not buffactive.Stymie then
                    return "IntEnfeeblesAcc"
                elseif enfeebling_magic_effect:contains(spell.english) then
                    return "IntEnfeeblesEffect"
                elseif enfeebling_magic_sleep:contains(spell.english) and ((buffactive.Stymie and buffactive.Composure) or state.SleepMode.value == 'MaxDuration') then
                    return "SleepMaxDuration"
                elseif enfeebling_magic_sleep:contains(spell.english) then
                    return "Sleep"
                else
                    return "IntEnfeebles"
                end
            else
                return "MndEnfeebles"
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
     elseif state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
	 if state.Auto_Kite.value == true then
        idleSet = set_combine(idleSet, sets.Kiting)
    end
	if world.area:endswith('Adoulin') then
	    idleSet = set_combine(idleSet,{body="Councilor's Garb"})
	end
    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

function customize_melee_set(meleeSet)
    if state.EnspellMode.Current == 'Enspell Melee Mode' then
        meleeSet = set_combine(meleeSet, sets.engaged.Enspell)
    end
	if state.EnspellMode.Current == 'Enspell Melee Mode Acc' then
        meleeSet = set_combine(meleeSet, sets.engaged.Enspell.Acc)
    end
    if state.EnspellMode.value == true and player.hpp <= 75 and player.tp < 1000 then
        meleeSet = set_combine(meleeSet, sets.engaged.Enspell.Fencer)
    end
    
	
	if state.WeaponMode.Current == 'Crocea Bunzi' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Magical)
	elseif state.WeaponMode.Current == 'Crocea Daybreak' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Magical2) 		
	elseif state.WeaponMode.Current == 'Naegling Machaera' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Physical)
	elseif state.WeaponMode.Current == 'Crocea Levante' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Enaero)
	elseif state.WeaponMode.Current == 'Maxentius Machaera' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Club)	
	elseif state.WeaponMode.Current == 'Lvl1Daggers' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Daggers)
    elseif state.WeaponMode.Current == 'Aeolian Edge' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.AE)
	elseif state.WeaponMode.Current == 'Crocea Daybreak' and (player.sub_job == 'SCH' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Magical) 
	elseif state.WeaponMode.Current == 'Naegling Machaera' and (player.sub_job == 'SCH' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Physical)
	elseif state.WeaponMode.Current == 'Crocea Levante' and (player.sub_job == 'SCH' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Enaero)
	elseif state.WeaponMode.Current == 'Maxentius Machaera' and (player.sub_job == 'SCH' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Club)	
	elseif state.WeaponMode.Current == 'Lvl1Daggers' and (player.sub_job == 'SCH' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Daggers)
    elseif state.WeaponMode.Current == 'Aeolian Edge' and (player.sub_job == 'SCH' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.AE)
	end
	if buff == "doom" then
        meleeSet = set_combine(meleeSet, sets.engaged.Doom)
    end
	return meleeSet
end
-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then 
--	    send_command('@input /echo <----- variable value: ' .. DW_needed .. ' ----->')
        if DW_needed <= 16 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 16 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 26 and DW_needed <= 34 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 34 and DW_needed <= 43 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 43 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
              end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
              if tonumber(cmdParams[3]) ~= Haste then
                  Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'enspell' then
        send_command('@input /ma '..state.EnSpell.value..' <me>')
    elseif cmdParams[1]:lower() == 'barelement' then
        send_command('@input /ma '..state.BarElement.value..' <me>')
    elseif cmdParams[1]:lower() == 'barstatus' then
        send_command('@input /ma '..state.BarStatus.value..' <me>')
    elseif cmdParams[1]:lower() == 'gainspell' then
        send_command('@input /ma '..state.GainSpell.value..' <me>')
    end

    gearinfo(cmdParams, eventArgs)
end

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>

function handle_strategems(cmdParams)
    -- cmdParams[1] == 'scholar'
    -- cmdParams[2] == strategem to use

    if not cmdParams[2] then
        add_to_chat(123,'Error: No strategem command given.')
        return
    end
    local strategem = cmdParams[2]:lower()

    if strategem == 'light' then
        if buffactive['light arts'] then
            send_command('input /ja "Addendum: White" <me>')
        elseif buffactive['addendum: white'] then
            add_to_chat(122,'Error: Addendum: White is already active.')
        else
            send_command('input /ja "Light Arts" <me>')
        end
    elseif strategem == 'dark' then
        if buffactive['dark arts'] then
            send_command('input /ja "Addendum: Black" <me>')
        elseif buffactive['addendum: black'] then
            add_to_chat(122,'Error: Addendum: Black is already active.')
        else
            send_command('input /ja "Dark Arts" <me>')
        end
    elseif buffactive['light arts'] or buffactive['addendum: white'] then
        if strategem == 'cost' then
            send_command('input /ja Penury <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Celerity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Accession <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: White" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    elseif buffactive['dark arts']  or buffactive['addendum: black'] then
        if strategem == 'cost' then
            send_command('input /ja Parsimony <me>')
        elseif strategem == 'speed' then
            send_command('input /ja Alacrity <me>')
        elseif strategem == 'aoe' then
            send_command('input /ja Manifestation <me>')
        elseif strategem == 'addendum' then
            send_command('input /ja "Addendum: Black" <me>')
        else
            add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
        end
    else
        add_to_chat(123,'No arts has been activated yet.')
    end
end

function set_sleep_timer(spell)
    local self = windower.ffxi.get_player()

    if spell.en == "Sleep II" then 
        base = 90
    elseif spell.en == "Sleep" or spell.en == "Sleepga" then 
        base = 60
    end

    if state.Buff.Saboteur then
        if state.NM.value then
            base = base * 1.25
        else
            base = base * 2
        end
    end

    -- Job Points Buff
    base = base + self.job_points.rdm.enfeebling_magic_duration

    if state.Buff.Stymie then
        base = base + self.job_points.rdm.stymie_effect
    end

        --Enfeebling duration non-augmented gear total
    gear_mult = 1.20
    --Enfeebling duration augmented gear total
    aug_mult = 1.25
	--Estoquer/Lethargy Composure set bonus
    --2pc = 1.1 / 3pc = 1.2 / 4pc = 1.35 / 5pc = 1.5
    empy_mult = 1 --from sets.midcast.Sleep

    totalDuration = math.floor(base * gear_mult * aug_mult * empy_mult)
        
    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
    end
    add_to_chat(1, 'Base: ' ..base.. ' Merits: ' ..self.merits.enfeebling_magic_duration.. ' Job Points: ' ..self.job_points.rdm.stymie_effect.. ' Set Bonus: ' ..empy_mult)

end

windower.register_event('zone change', 
    function()
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
           send_command('gi ugs true')
       end
    end
)

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'SCH' then
        set_macro_page(1, 6 )
    elseif player.sub_job == 'NIN' then
        set_macro_page(2, 6)
    else
        set_macro_page(1, 6)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end