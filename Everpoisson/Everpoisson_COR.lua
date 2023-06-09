-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ ALT+F9 ]          Cycle Ranged Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--              [ WIN+` ]           Toggle use of Luzaf Ring.
--              [ WIN+Q ]           Quick Draw shot mode selector.
--              [ CTRL+` ]          Treasure Hunter Mode
--  Abilities:  [ CTRL+- ]          Quick Draw primary shot element cycle forward.
--              [ CTRL+= ]          Quick Draw primary shot element cycle backward.
--              [ ALT+- ]           Quick Draw secondary shot element cycle forward.
--              [ ALT+= ]           Quick Draw secondary shot element cycle backward.
--              [ CTRL+[ ]          Quick Draw toggle target type.
--              [ CTRL+] ]          Quick Draw toggle use secondary shot.
--
--              [ CTRL+C ]          Crooked Cards
--              [ ALT+` ]           Double-Up
--              [ CTRL+X ]          Fold
--              [ CTRL+S ]          Snake Eye
--              [ CTRL+NumLock ]    Triple Shot
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+G ]          Cycles between available ranged weapons
--              [ CTRL+W ]          Toggle Ranged Weapon Lock
--              [ ALT+W  ]          Toggle Weapons
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad8 ]    Last Stand
--              [ CTRL+Numpad4 ]    Leaden Salute
--              [ CTRL+Numpad6 ]    Wildfire
--              [ CTRL+Numpad1 ]    Requiescat
--
--  RA:         [ Numpad0 ]         Ranged Attack
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c qd                         Uses the currently configured shot on the target, with either <t> or
--                                  <stnpc> depending on setting.
--  gs c qd t                       Uses the currently configured shot on the target, but forces use of <t>.
--
--  gs c cycle mainqd               Cycles through the available steps to use as the primary shot when using
--                                  one of the above commands.
--  gs c cycle altqd                Cycles through the available steps to use for alternating with the
--                                  configured main shot.
--  gs c toggle usealtqd            Toggles whether or not to use an alternate shot.
--  gs c toggle selectqdtarget      Toggles whether or not to use <stnpc> (as opposed to <t>) when using a shot.
--
--  gs c toggle LuzafRing           Toggles use of Luzaf Ring on and off


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
--  include('Arislan-Globals.lua')
	gear.COR_DW_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}} 
    gear.COR_RA_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}}
    gear.COR_SNP_Cape = {name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10',}}
    gear.COR_TP_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.COR_WS1_Cape = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}} 
    gear.COR_WS2_Cape = {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}} 
    gear.COR_WS3_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
    gear.COR_WS4_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}}
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- QuickDraw Selector
    state.Mainqd = M{['description']='Primary Shot', 'Fire Shot', 'Ice Shot', 'Wind Shot', 'Earth Shot', 'Thunder Shot', 'Water Shot'}
    state.Altqd = M{['description']='Secondary Shot', 'Fire Shot', 'Ice Shot', 'Wind Shot', 'Earth Shot', 'Thunder Shot', 'Water Shot'}
    state.UseAltqd = M(false, 'Use Secondary Shot')
    state.SelectqdTarget = M(false, 'Select Quick Draw Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')
 --   state.Melee = M{['description']='Current Mode', 'Savage', 'Shooting',}
    state.DualWield = M(false, 'Dual Wield III')
    state.QDMode = M{['description']='Quick Draw Mode', 'STP', 'Magic Enhance', 'Magic Attack'}

    state.Currentqd = M{['description']='Current Quick Draw', 'Main', 'Alt'}

    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    define_roll_values()

    lockstyleset = 18
	include('Mote-TreasureHunter')
	no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
        "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('DT', 'Normal')
    state.RangedMode:options('STP', 'Normal', 'TH', 'Acc', 'HighAcc', 'Critical')
	state.WeaponskillMode:options('Normal', 'Acc', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    state.Gun = M{['description']='Current Gun', 'Anarchy +2', 'Death Penalty', 'Fomalhaut',}--, 'Armageddon'
    state.CP = M(false, "Capacity Points Mode")
    state.WeaponLock = M(false, 'Weapon Lock')
    state.WeaponMode = M{['description']='Weapon Mode','Naegling Rostam','Tauret Blurred','Rostam Melee','Rostam Shooting',}
	state.CritMode = M{['description']='Crit Mode','Off','On',}
    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
--    gear.RAbullet = "Eminent Bullet"
--    gear.WSbullet = "Eminent Bullet"
    gear.MAbullet = "Living Bullet"
    gear.QDbullet = "Hauksbok bullet"
    options.ammo_warning_limit = 10

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
--  include('Global-GEO-Binds.lua') -- OK to remove this line
    include('sendbinds.lua')
	include('organizer-lib')
	include('sendbinds.lua')
--	send_command('org organize')
--	send_command('lua l equipviewer')
--	send_command('equipviewer pos 2160 400')
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua l gearinfo')
		end

 --   send_command('bind !` input /ja "Double-up" <me>')
	send_command('bind ^` gs c cycle treasuremode')
    send_command('bind ^c input /ja "Crooked Cards" <me>')
    send_command('bind ^s input /ja "Snake Eye" <me>')
    send_command('bind ^f input /ja "Fold" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
    send_command('bind @` gs c toggle LuzafRing')
    send_command('bind ^l input /ws "leaden salute" <stnpc>')
	send_command('bind !l input /ws "leaden salute" <Sabotender Dulce>')

    send_command('bind ^- gs c cycleback mainqd')
    send_command('bind ^= gs c cycle mainqd')
    send_command('bind !- gs c cycle altqd')
    send_command('bind != gs c cycleback altqd')
    send_command('bind ^[ gs c toggle selectqdtarget')
    send_command('bind ^] gs c toggle usealtqd')

    send_command('bind @c gs c toggle CP')
    send_command('bind @q gs c cycle QDMode')
    send_command('bind !e gs c cycle Gun')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @r gs c toggle WeaponLock')
    send_command('bind ^S gs c cycle Melee')
    send_command('bind ^numlock input /ja "Triple Shot" <me>')
    send_command('bind !w gs c cycle WeaponMode')
	send_command('bind !c gs c cycle CritMode')
    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    end

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad8 input /ws "Last Stand" <t>')
    send_command('bind ^numpad4 input /ws "Leaden Salute" <t>')
    send_command('bind ^numpad6 input /ws "Wildfire" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
    send_command('bind ^numpad2 input /ws "Hot Shot" <t>')
    send_command('bind ^numpad3 input /ws "Numbing Shot" <t>')
    send_command('bind !q input /ja "Earth Shot" <t>')
    send_command('bind numpad0 input /ra <t>')
	send_command('bind !, input /ja "Random Deal" <me> ')
	send_command('bind !. input /ja "Wild Card" <me> ')

    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind ^c')
    send_command('unbind ^s')
    send_command('unbind ^f')
    send_command('unbind !`')
    send_command('unbind @`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind @c')
    send_command('unbind @q')
    send_command('unbind @e')
    send_command('unbind @w')
	send_command('unbind !w')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind numpad0')
    send_command('unbind ^S')
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
	send_command('unbind !c')
	send_command('unbind ^l')
    send_command('unbind !l')
	send_command('unbind !q')
	send_command('unbind ^,')
	send_command('unbind ^.')
	
	if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua u gearinfo')
    end
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +3"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac"}

    sets.precast.CorsairRoll = {
        main={ name="Rostam", augments={'Path: C',}},
        head="Lanun Tricorne",
        body="Meg. Cuirie +2", --8/0
        hands="Chasseur's Gants +1",
        legs="Desultor Tassets",
        feet="Lanun Bottes +3", --6/0
        neck="Regal Necklace",
        ear1="Genmei Earring", --2/0
        ear2="Etiolation Earring", --0/3
        ring1="Luzaf's Ring", --7/(-1)
        ring2="Barataria Ring", --10/10
        back= {name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10',}},
        waist="Flume Belt +1", --4/0
        }

    sets.precast.CorsairRoll.Gun = set_combine(sets.precast.CorsairRoll.Engaged, {range="Compensator"})
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +1"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})

    sets.precast.LuzafRing = set_combine(sets.precast.CorsairRoll, {ring1="Luzaf's Ring"})
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +3"}

    sets.precast.Waltz = {
        body="Passion Jacket",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        head="Carmine Mask +1", --14
        body={ name="Taeon Tabard", augments={'"Fast Cast"+5',}}, --9
        hands="Leyline Gloves", --7
        legs={ name="Herculean Trousers", augments={'Mag. Acc.+25','"Fast Cast"+6','MND+8',}}, --6
        feet={ name="Herculean Boots", augments={'Mag. Acc.+8','"Fast Cast"+6','STR+7','"Mag.Atk.Bns."+6',}}, --6
        neck="Voltsurge Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Etiolation Earring", --1
        ring1="Weather. Ring +1", --6(4)
        ring2="Kishar Ring", --4
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        ring1="Lebeche Ring",
        })

    -- (10% Snapshot from JP Gifts)
    sets.precast.RA = {
        ammo=gear.RAbullet,
        head="Taeon Chapeau", --10/0
        body="Oshosi Vest", --12/0
--		body="Laksa. Frac +3", --0/20
        hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}}, --8/11
--        legs="Laksa. Trews +3", --15/0
	    legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}}, --10/13
        feet="Meg. Jam. +2", --10/0
--		neck="Comm. Charm +1", --3/0
        back= { name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10',}}, --10/0
        waist="Yemaya Belt" --0/5
--        waist="Impulse Belt", --3/0
      } --60/29

    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
 --       legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}}, --10/13
		body="Laksa. Frac +3", --0/20
--		waist="Yemaya Belt" --0/5
		}) --48/49

    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
        head="Chass. Tricorne +1", --0/14
        feet="Pursuer's Gaiters", --0/10
        waist="Impulse Belt" --3/0
	    }) --31/68


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo=gear.WSbullet,
        head="Nyame helm",
        body="Laksa. Frac +3",
        hands="Nyame gauntlets",
--        hands="Meg. Gloves +2",
--        legs={ name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +3%','MND+2','Mag. Acc.+11','"Mag.Atk.Bns."+2',}},
        legs="Nyame Flanchard",
    --  feet= { name="Herculean Boots", augments={'Accuracy+29','Weapon skill damage +4%','DEX+2','Attack+14',}},
        feet="Lanun Bottes +3", 
	    neck="Comm. Charm +1",
        ear1="Moonshade Earring",
        ear2="Ishvara Earring",
        ring1="Rufescent Ring",
        ring2="Epaminondas's Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
--        legs=gear.Adhemar_C_legs,
        feet=gear.Herc_RA_feet,
        ear2="Telos Earring",
        neck="Iskur Gorget",
        ring2="Hajduk Ring +1",
        waist="Kwahu Kachina Belt",
        })

    sets.precast.WS['Last Stand'] = {
	    ammo=gear.WSbullet,
        body="Laksa. Frac +3",
        hands="Nyame gauntlets",
--        hands="Meg. Gloves +2",
--		legs={ name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +3%','MND+2','Mag. Acc.+11','"Mag.Atk.Bns."+2',}},
        legs="Nyame Flanchard",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
        ear2="Ishvara Earring",
		ring1="Dingir Ring",
		ring2="Regal Ring",
		waist="Fotia Belt",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
		}

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
--        legs=gear.Adhemar_C_legs,
        feet=gear.Herc_RA_feet,
        neck="Iskur Gorget",
        ear2="Telos Earring",
        ring2="Hajduk Ring +1",
        waist="Kwahu Kachina Belt",
		back= { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
        })

    sets.precast.WS['Wildfire'] = {
     -- ammo="Living Bullet",
        ammo=gear.MAbullet,
        head="Nyame Helm",
 --       head={ name="Herculean Helm", augments={'Phys. dmg. taken -3%','"Dbl.Atk."+1','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
        body="Lanun Frac +3",
        hands="Nyame Gauntlets",
--        legs={ name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +3%','MND+2','Mag. Acc.+11','"Mag.Atk.Bns."+2',}},
        legs="Nyame Flanchard",
        feet="Lanun Bottes +3",
        neck="Comm. Charm +1",
        ear1="Novio Earring",
        ear2="Friomisi Earring",
        ring1="Epaminondas's Ring",
        ring2="Dingir Ring",
        back= { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
        waist="Eschan Stone",
        }

    sets.precast.WS['Hot Shot'] = sets.precast.WS['Wildfire']
	
	sets.precast.WS['Sniper Shot'] = set_combine(sets.precast.WS['Last Stand'], {
        head="Malignance Chapeau", --6/0
		body="Laksa. Frac +3", --9
        hands="Nyame gauntlets",
        hands="Malignance Gloves", --5
	    feet="Lanun Bottes +3", 
		legs="Malignance Tights", --7
        neck="Comm. Charm +1",
		ear1="Moonshade Earring",
        ring1="Epaminondas's Ring",
        ring2="Dingir Ring",
		waist="Svelt. Gouriz +1"
        })
    sets.precast.WS['Leaden Salute'] = set_combine(sets.precast.WS['Wildfire'], {
        head="Pixie Hairpin +1",
        ear1="Moonshade Earring",
        ring1="Archon Ring",
		waist="Svelt. Gouriz +1"
        })

    sets.precast.WS['Leaden Salute'].FullTP = {ear1="Novio Earring", waist="Svelt. Gouriz +1"}

    sets.precast.WS['Evisceration'] = {
--        head=gear.Adhemar_B_head,
        body="Abnoba Kaftan",
        hands="Mummu Wrists +2",
        legs="Samnuha Tights",
        feet="Mummu Gamash. +2",
        neck="Fotia Gorget",
        ear2="Brutal Earring",
        ring1="Regal Ring",
        ring2="Mummu Ring",
        back=gear.COR_TP_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        head="Meghanada Visor +2",
        body=gear.Adhemar_A_body,
        legs=gear.Herc_WS_legs,
        ear2="Telos Earring",
        })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        head="Nyame helm",
        body="Nyame Mail",
        hands="Nyame gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame sollerets",
        ring1="Regal Ring",
        ring2="Epaminondas's Ring",
 --       ring2="Shukuyu Ring",
        back= {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}, 
        waist="Sailfi Belt +1",
        })
	sets.precast.WS['Circle Blade'] = set_combine(sets.precast.WS['Savage Blade'], {
        })
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
        body="Meg. Cuirie +2",
        ear2="Telos Earring",
        ring2="Rufescent Ring",
        waist="Grunfeld Rope",
        })
    sets.precast.WS['Savage Blade'].DT = set_combine(sets.precast.WS['Savage Blade'], {
        head="Malignance Chapeau",
        body="Malignance Tabard",
        hands="Nyame gauntlets",
 --       hands="Malignance Gloves",
--        legs="Malignance Tights",
        legs="Nyame Flanchard",
        feet="Malignance Boots",
        })

    sets.precast.WS['Swift Blade'] = set_combine(sets.precast.WS, {
--        head=gear.Adhemar_B_head,
        body=gear.Adhemar_A_body,
--        hands=gear.Adhemar_B_hands,
        legs="Meg. Chausses +2",
        feet=gear.Herc_TA_feet,
        ear1="Cessance Earring",
        ear2="Brutal Earring",
        ring1="Regal Ring",
        ring2="Epona's Ring",
        back= {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}, 
        })

    sets.precast.WS['Swift Blade'].Acc = set_combine(sets.precast.WS['Swift Blade'], {
        head="Meghanada Visor +2",
        hands="Meg. Gloves +2",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        })

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS['Swift Blade'], {
        hands="Meg. Gloves +2",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
		ring2="Rufescent Ring",
        }) --MND

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
        head="Meghanada Visor +2",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        })

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Wildfire'], {
        ammo="Hauksbok Bullet",
		ear1="Moonshade Earring",
        ring1="Shiva Ring +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Cure = {
        neck="Incanter's Torque",
        ear1="Roundel Earring",
        ear2="Mendi. Earring",
        ring1="Lebeche Ring",
        ring2="Haoma's Ring",
--        waist="Bishop's Sash",
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Occult Acumen Set
    sets.midcast['Dark Magic'] = {
        ammo=gear.QDbullet,
        head=gear.Herc_MAB_head,
        body="Mummu Jacket +2",
--        hands=gear.Adhemar_B_hands,
        legs="Chas. Culottes +1",
--        feet="Carmine Greaves +1",
        neck="Iskur Gorget",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Archon Ring",
        ring2="Dingir Ring",
        back=gear.COR_RA_Cape,
        waist="Oneiros Rope",
        }

    sets.midcast.CorsairShot = {
        ammo=gear.QDbullet,
--        head=gear.Herc_MAB_head,
        head="Ikenga's Hat",
		body="Lanun Frac +3",
        hands="Carmine Fin. Ga. +1",
        legs="Malignance Tights",
--        legs=gear.Herc_MAB_legs,
        feet="Chasseur's bottes +1",
--        feet="Lanun Bottes +3",
        neck="Baetyl Pendant",
        ear1="Novio Earring",
        ear2="Friomisi Earring",
        ring1="Fenrir Ring +1",
        ring2="Dingir Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','"Store TP"+10',}},
        waist="Eschan Stone",
        }

    sets.midcast.CorsairShot.STP = {
        ammo=gear.QDbullet,
        head="Ikenga's Hat",
        body="Mummu Jacket +2",
        hands="Schutzen Mittens",
        legs="Chas. Culottes +1",
        feet="Carmine Greaves +1",
        neck="Iskur Gorget",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Ilabrat Ring",
        ring2="Chirich Ring +1",
        back=gear.COR_RA_Cape,
        waist="Kentarch Belt +1",
        }

    sets.midcast.CorsairShot.Resistant = set_combine(sets.midcast.CorsairShot, {
        head="Ikenga's Hat",
        body="Mummu Jacket +2",
        hands="Laksa. Gants +3",
        legs="Mummu Kecks +2",
        feet="Laksa. Boots +3",
        neck="Sanctity Necklace",
        ear1="Hermetic Earring",
        ear2="Digni. Earring",
        ring1="Regal Ring",
        ring2="Weather. Ring +1",
        back=gear.COR_WS1_Cape,
        waist="Kwahu Kachina Belt",
        })

    sets.midcast.CorsairShot['Light Shot'] = sets.midcast.CorsairShot.Resistant
    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot.Resistant
    sets.midcast.CorsairShot.Enhance = {body="Mirke Wardecors", feet="Chass. Bottes +1"}

    -- Ranged gear
    sets.midcast.RA = {
        ammo=gear.RAbullet,
--        head="Meghanada Visor +2",
--        body="Malignance Tabard",
--        hands= {name="Adhemar Wrist. +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
--        legs= {name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}},
        head="Ikenga's Hat",
        body="Ikenga's Vest",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
        neck="Iskur Gorget",
        ear1="Enervating earring",
        ear2="Telos Earring",
        ring1="Chirich Ring +1",
        ring2="Crepuscular Ring",
        back= {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}},
        waist="Yemaya Belt",
        }

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
        head="Meghanada Visor +2",
        hands="Lanun Gants +3",
        ring1="Regal Ring",
        })

    sets.midcast.RA.HighAcc = set_combine(sets.midcast.RA.Acc, {
        body="Laksa. Frac +3",
        legs="Laksa. Trews +3",
        ring2="Hajduk Ring +1",
        waist="Kwahu Kachina Belt",
        })

    sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
        head="Meghanada Visor +2",
        body="Meg. Cuirie +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Oshosi Leggings",
        ring1="Begrudging Ring",
        ring2="Mummu Ring",
        waist="Kwahu Kachina Belt",
        })

    sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
--        feet=gear.Adhemar_D_feet,
        ear1="Dedition Earring",
        })

	sets.midcast.RA.TH = set_combine(sets.midcast.RA, {
        head = "Wh. Rarab Cap +1",
		body={ name="Herculean Vest", augments={'"Store TP"+2','AGI+7','"Treasure Hunter"+2','Accuracy+9 Attack+9','Mag. Acc.+16 "Mag.Atk.Bns."+16',}},
		waist="Chaac Belt",
        })

    sets.TripleShot = {
        head="Oshosi Mask", --4
        body="Chasseur's Frac +1", --12
        hands="Lanun Gants +3",
        legs="Oshosi Trousers", --5
        feet="Oshosi Leggings", --2
        } --27

    sets.TripleShotCritical = {
        head="Meghanada Visor +2",
        waist="Kwahu Kachina Belt",
        }


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo=gear.MAbullet,
        head="Mummu Bonnet +1",
        body="Malignance Tabard",
        hands="Malignance Gloves",
--        hands=gear.Herc_DT_hands,
        legs="Malignance Tights",
        feet="Mummu Gamash. +1",
--		feet="Ahosi Leggings",
        neck="Elite royal collar",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Defending Ring",
        ring2="Sheltered Ring",
        back="Moonlight Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine(sets.idle, {
        head="Malignance Chapeau", --5/0
        body="Malignance Tabard", --6/0
        hands="Malignance Gloves",
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ear2="Etiolation Earring", --0/3
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Flume Belt +1", --4/0
        feet="Malignance Boots",
		legs="Malignance Tights",
        })

    sets.idle.Refresh = set_combine(sets.idle, {
        head=gear.Herc_Idle_head,
        --body="Mekosu. Harness",
        legs="Rawhide Trousers",
        ring1="Stikini Ring +1",
        ring2="Stikini Ring +1",
        })

    sets.idle.Town = set_combine(sets.idle, {
        ranged="Death Penalty",
		head="Malignance Chapeau",
		body="Lanun Frac +3",
        hands="Lanun Gants +3",
        feet="Lanun Bottes +3",
        neck="Iskur Gorget",
        ear1="Suppanomimi",
        ear2="Telos Earring",
        ring1="Regal Ring",
--        ring2="Dingir Ring",
        back=gear.COR_WS1_Cape,
        waist="Windbuffet Belt +1",
        })

    sets.idle.Sword = {
 		main="Naegling",
--        sub={ name="Rostam", augments={'Path: B',}},
        sub="Blurred Knife +1",
        }
    sets.idle.Dagger = {
	    main={ name="Rostam", augments={'Path: B',}},
        sub="Tauret",
		}
	sets.idle.Dagger2 = {
 		main={ name="Rostam", augments={'Path: A',}},
        sub="Tauret",
		}
--        sub={ name="Rostam", augments={'Path: C',}},
    sets.idle.DaggerTauret = {
	    main="Tauret",
--        sub={ name="Rostam", augments={'Path: B',}},
        sub="Blurred Knife +1",
        }
    sets.idle.Empty = {
 		main=empty,
        sub=empty,
        }
	sets.idle.SwordShield = {
 		main="Naegling",
        sub="Nusku shield",
        }
    sets.idle.DaggerShield = {
        main={ name="Rostam", augments={'Path: B',}},
        sub="Nusku shield",
        }
    sets.idle.Dagger2Shield = {
        main={ name="Rostam", augments={'Path: A',}},
        sub="Nusku shield",
        }		
	sets.idle.DaggerTauretShield = {
	    main="Tauret",
        sub="Nusku shield",
        }	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {legs="Carmine Cuisses +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		head="Malignance Chapeau", --6/0
		body="Malignance Tabard", --9
        hands="Malignance Gloves", --5
--        neck="Loricate Torque +1", --6/6
	    feet="Malignance Boots", --4
		legs="Malignance Tights", --7
        neck="Iskur Gorget",
        ear1="Telos Earring",
        ear2="Brutal Earring",
 --       ring1=Ilabrat Ring",
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Sailfi Belt +1",
        }
		
    sets.engaged.Sword = {
 		main="Naegling",
        sub="Nusku shield",
        }
    sets.engaged.Dagger = {
        main={ name="Rostam", augments={'Path: B',}},
        sub="Nusku shield",
        }
    sets.engaged.Dagger2 = {
        main={ name="Rostam", augments={'Path: A',}},
        sub="Nusku shield",
        }		
	sets.engaged.DaggerTauret = {
	    main="Tauret",
        sub="Nusku shield",
        }	
    sets.engaged.Empty = {
 		main=empty,
        sub=empty,
        }	

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        head="Carmine Mask +1",
        feet=gear.Herc_STP_feet,
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
--        feet="Carmine Greaves +1",
--        ring1="Chirich Ring +1",
        })

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1",
--        hands="Malignance Gloves",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
	--   hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring",
--        ring1=Ilabrat Ring",
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Windbuffet Belt +1",
	   -- waist="Reiki Yotai", --7
      } -- 48%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
--        ring1="Chirich Ring +1",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1",
--        hands="Malignance Gloves",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
	 --   hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Windbuffet Belt +1",
	  --  waist="Reiki Yotai", --7
        } -- 42%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        head="Carmine Mask +1",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
--        ring1="Chirich Ring +1",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1",
--        hands="Malignance Gloves",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Windbuffet Belt +1",
	 --   waist="Reiki Yotai", --7
        } -- 31%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
--        ring1="Chirich Ring",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1",
--        hands="Malignance Gloves",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+4','STR+3','Attack+2',}},
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Windbuffet Belt +1",
	 --   waist="Reiki Yotai", --7
        } -- 27%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
 --       ring1="Chirich Ring",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1", --6
--        hands="Malignance Gloves",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+4','STR+3','Attack+2',}},
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Telos Earring",
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Windbuffet Belt +1",
        } -- 21%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Dampening Tam",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        legs="Meg. Chausses +2",
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        feet=gear.Herc_STP_feet,
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
 --       feet="Carmine Greaves +1",
--        ring1="Chirich Ring",
        })
    sets.engaged.DW.Crit = {
	    head="Mummu Bonnet +2",
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Mummu Gamash. +2",
        neck="Iskur Gorget",
        ear1="Suppanomimi",
        ear2="Telos Earring",
        ring1="Epona's Ring",
        ring2="Petrov Ring",
        back=gear.COR_TP_Cape,
        waist="Windbuffet Belt +1",
	    }

   sets.engaged.DW.Sword = {
 		main="Naegling",
        sub="Blurred Knife +1",
        }
    sets.engaged.DW.Dagger = {
        main={ name="Rostam", augments={'Path: B',}},
        sub="Tauret",		
        }
    sets.engaged.DW.Dagger2 = {
        main={ name="Rostam", augments={'Path: A',}},
        sub="Tauret",		
        }		
	sets.engaged.DW.DaggerTauret = {
	    main="Tauret",
        sub="Blurred Knife +1",
        }	
    sets.engaged.DW.Empty = {
 		main=empty,
        sub=empty,
        }
		
    sets.engaged.DW.MaxHastePlus = set_combine(sets.engaged.DW.MaxHaste, {back=gear.COR_DW_Cape})
    sets.engaged.DW.LowAcc.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {back=gear.COR_DW_Cape})
    sets.engaged.DW.MidAcc.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {back=gear.COR_DW_Cape})
    sets.engaged.DW.HighAcc.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHaste, {back=gear.COR_DW_Cape})
    sets.engaged.DW.STP.MaxHastePlus = set_combine(sets.engaged.DW.STP.MaxHaste, {back=gear.COR_DW_Cape})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Malignance Chapeau", --6/0
		body="Malignance Tabard", --9
        hands="Malignance Gloves", --5
--        neck="Loricate Torque +1", --6/6
	    feet="Malignance Boots", --4
		legs="Malignance Tights", --7
	    ear1="Eabani Earring",
		ear2="Telos Earring",
        ring2="Defending Ring", --10
		waist="Reiki Yotai",
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHastePlus = set_combine(sets.engaged.DW.STP.MaxHastePlus, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {ring1="Eshmun's Ring", ring2="Purity Ring", waist="Gishdubar Sash"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {}
	sets.TreasureHunter = {head = "Wh. Rarab Cap +1", body={ name="Herculean Vest", augments={'"Store TP"+2','AGI+7','"Treasure Hunter"+2','Accuracy+9 Attack+9','Mag. Acc.+16 "Mag.Atk.Bns."+16',}}, waist="Chaac Belt"}
--	back="Mecisto. Mantle"}
    sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- Gear
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") then
        if player.status ~= 'Engaged' then
            equip(sets.precast.CorsairRoll.Gun)
        end
        if state.LuzafRing.value then
            equip(sets.precast.LuzafRing)
        end
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    end

    if spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
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

    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") then
        if player.status ~= 'Engaged' then
            equip(sets.precast.CorsairRoll.Gun)
        end
    elseif spell.action_type == 'Ranged Attack' then
        if flurry == 2 then
            equip(sets.precast.RA.Flurry2)
        elseif flurry == 1 then
            equip(sets.precast.RA.Flurry1)
        end
		-- Equip obi or Orpheaus
    elseif spell.type == 'WeaponSkill' then
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
            
--        if spell.english == 'Leaden Salute' then
--            if (world.weather_element == 'Dark' or world.day_element == 'Dark') and
--            	(player.target.distance    <= 2.1)		then
--                equip({waist="Orpheus's Sash"})
--				
--	elseif (world.weather_element == 'Dark' or world.day_element == 'Dark') and
--            	(player.target.distance    >= 2.1)		then
--                equip(sets.Obi)
--				
--	elseif (world.weather_element == 'Dark' and world.day_element == 'Dark') or (world.weather_element == 'Dark' and world.weather_intensity == 2) then
--                equip(sets.Obi)
--            end
--    	
			elseif spell.type == 'WeaponSkill' and spell.english == 'Leaden Salute' then 
			 if
			player.tp > 2900 then
                equip(sets.precast.WS['Leaden Salute'].FullTP)
            end
		end
		
--    elseif spell.english == 'Wildfire' then
--            if	(world.weather_element == 'Fire' and world.day_element == 'Fire') and
--		    equip(sets.Obi)

end
end
       

--	elseif spell.english == 'Wildfire' and (world.weather_element == 'Fire' or world.day_element == 'Fire') and
--		then
--            equip({waist="Orpheus's Sash"})
--		then
--            equip(sets.Obi)
--        end
--    end


function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Equip obi if weather/day matches for Quick Draw.
    if spell.type == 'CorsairShot' then
        if (spell.element == world.day_element or spell.element == world.weather_element) and
        (spell.english ~= 'Light Shot' and spell.english ~= 'Dark Shot') then
            equip(sets.Obi)
        end
        if state.QDMode.value == 'Magic Enhance' then
            equip(sets.midcast.CorsairShot.Enhance)
        elseif state.QDMode.value == 'STP' then
            equip(sets.midcast.CorsairShot.STP)
        end
    elseif spell.action_type == 'Ranged Attack' then
        if buffactive['Triple Shot'] then
            equip(sets.TripleShot)
            if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Armageddon" then
                equip(sets.TripleShotCritical)
            end
        elseif buffactive['Aftermath: Lv.3'] and player.equipment.main == "Armageddon" then
            equip(sets.midcast.RA.Critical)
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
    if spell.english == "Light Shot" then
        send_command('@timers c "Light Shot ['..spell.target.name..']" 60 down abilities/00195.png')
    end
end

function job_buff_change(buff,gain)
-- If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            --add_to_chat(122, "Flurry status cleared.")
        end
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

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
        disable('ranged')
    else
        enable('ranged')
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
--	check_moving()
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

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if world.area:endswith('Adoulin') then
	    idleSet = set_combine(idleSet,{body="Councilor's Garb"})
	end
    if state.Gun.current == 'Death Penalty' then
        equip({ranged="Death Penalty"})
    elseif state.Gun.current == 'Fomalhaut' then
        equip({ranged="Fomalhaut"})
    elseif state.Gun.current == 'Anarchy +2' then
        equip({ranged="Anarchy +2"})
    elseif state.Gun.current == 'Death Penalty' then
        equip({ranged="Death Penalty"})
    end
	if state.WeaponMode.Current == 'Naegling Rostam' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    idleSet = set_combine(idleSet, sets.idle.Sword)
	elseif state.WeaponMode.Current == 'Empty' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    idleSet = set_combine(idleSet, sets.idle.Empty)
	elseif state.WeaponMode.Current == 'Rostam Melee' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    idleSet = set_combine(idleSet, sets.idle.Dagger)
	elseif state.WeaponMode.Current == 'Rostam Shooting' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    idleSet = set_combine(idleSet, sets.idle.Dagger2)	
	elseif state.WeaponMode.Current == 'Tauret Blurred' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    idleSet = set_combine(idleSet, sets.idle.DaggerTauret)
	elseif state.WeaponMode.Current == 'Naegling Rostam' and (player.sub_job == 'WAR' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    idleSet = set_combine(idleSet, sets.idle.SwordShield)
	elseif state.WeaponMode.Current == 'Empty' and (player.sub_job == 'WAR' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    idleSet = set_combine(idleSet, sets.idle.Empty)
	elseif state.WeaponMode.Current == 'Rostam Melee' and (player.sub_job == 'WAR' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    idleSet = set_combine(idleSet, sets.idle.DaggerShield)
	elseif state.WeaponMode.Current == 'Rostam Shooting' and (player.sub_job == 'WAR' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    idleSet = set_combine(idleSet, sets.idle.Dagger2Shield)	
	elseif state.WeaponMode.Current == 'Tauret Blurred' and (player.sub_job == 'WAR' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    idleSet = set_combine(idleSet, sets.idle.DaggerTauretShield)	
	end
--	if state.Melee.current == 'Savage' then
--        equip({main="Naegling", sub="Rostam"})
--    elseif state.Melee.current == 'Shooting' then
--        equip({main="Rostam", sub="Tauret"})
--    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.Gun.current == 'Death Penalty' then
        equip({ranged="Death Penalty"})
    elseif state.Gun.current == 'Fomalhaut' then
        equip({ranged="Fomalhaut"})
    elseif state.Gun.current == 'Anarchy +2' then
        equip({ranged="Anarchy +2"})
    elseif state.Gun.current == 'Death Penalty' then
        equip({ranged="Death Penalty"})
    end
	if state.WeaponMode.Current == 'Naegling Rostam' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Sword)
	elseif state.WeaponMode.Current == 'Empty' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Empty)
	elseif state.WeaponMode.Current == 'Rostam Melee' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Dagger)
	elseif state.WeaponMode.Current == 'Rostam Shooting' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.Dagger2)	
	elseif state.WeaponMode.Current == 'Tauret Blurred' and (player.sub_job == 'NIN' or player.sub_job == 'DNC') then
	    meleeSet = set_combine(meleeSet, sets.engaged.DW.DaggerTauret)
	elseif state.WeaponMode.Current == 'Naegling Rostam' and (player.sub_job == 'WAR' or player.sub_job == 'WHM' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Sword)
	elseif state.WeaponMode.Current == 'Empty' and (player.sub_job == 'NIN' or player.sub_job == 'DNC' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Empty)
	elseif state.WeaponMode.Current == 'Rostam Melee' and (player.sub_job == 'NIN' or player.sub_job == 'DNC' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Dagger)
	elseif state.WeaponMode.Current == 'Rostam Shooting' and (player.sub_job == 'NIN' or player.sub_job == 'DNC' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.Dagger2)	
	elseif state.WeaponMode.Current == 'Tauret Blurred' and (player.sub_job == 'NIN' or player.sub_job == 'DNC' or world.area:endswith('Gaol')) then
	    meleeSet = set_combine(meleeSet, sets.engaged.DaggerTauret)			
	end
	if state.CritMode.Current == 'On' then
	   meleeSet = set_combine(meleeSet, sets.engaged.DW.Crit)
	elseif state.CritMode == 'Off' then
    return meleeSet
	end
--	   meleeSet = set_combine(meleeSet, sets.engaged.DW.Crit)
	return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairShot' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectqdTarget.value
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''

    msg = msg .. '[ Offense/Ranged: '..state.OffenseMode.current

    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end

    msg = msg .. '/' ..state.RangedMode.current .. ' ]'

    if state.WeaponskillMode.value ~= 'Normal' then
        msg = msg .. '[ WS: '..state.WeaponskillMode.current .. ' ]'
    end

    if state.DefenseMode.value ~= 'None' then
        msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
    end

    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode: ON ]'
    end

    msg = msg .. '[ *'..state.Mainqd.current

    if state.UseAltqd.value == true then
        msg = msg .. '/'..state.Altqd.current
    end

    msg = msg .. ' ('

    if state.QDMode.value then
        msg = msg .. state.QDMode.current .. ') '
    end

    msg = msg .. ']'

    add_to_chat(060, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

--Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
                end
            end
        end
    end)

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MaxHastePlus')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 27 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'qd' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doqd = ''
        if state.UseAltqd.value == true then
            doqd = state[state.Currentqd.current..'qd'].current
            state.Currentqd:cycle()
        else
            doqd = state.Mainqd.current
        end

        send_command('@input /ja "'..doqd..'" <t>')
    end

    gearinfo(cmdParams, eventArgs)
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

function define_roll_values()
    rolls = {
        ["Corsair's Roll"] =    {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"] =        {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"] =     {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"] =        {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"] =      {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"] =     {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Drachen Roll"] =      {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"] =       {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"] =       {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"] =        {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"] =      {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"] =     {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"] =      {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"] =    {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"] =    {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Puppet Roll"] =       {lucky=3, unlucky=7, bonus="Pet Magic Attack/Accuracy"},
        ["Gallant's Roll"] =    {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"] =     {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"] =     {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"] =    {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Naturalist's Roll"] = {lucky=3, unlucky=7, bonus="Enh. Magic Duration"},
        ["Runeist's Roll"] =    {lucky=4, unlucky=8, bonus="Magic Evasion"},
        ["Bolter's Roll"] =     {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"] =     {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"] =    {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"] =    {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] =  {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"] =      {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"] =      {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] =  {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"] =    {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, '[ Lucky: '..tostring(rollinfo.lucky)..' / Unlucky: '..tostring(rollinfo.unlucky)..' ] '..spell.english..': '..rollinfo.bonus..' ('..rollsize..') ')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1

    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.english == 'Wildfire' or spell.english == 'Leaden Salute' then
                -- magical weaponskills
                bullet_name = gear.MAbullet
            else
                -- physical weaponskills
                bullet_name = gear.WSbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end

    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]

    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end

    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end

    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
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
    if player.sub_job == 'DNC' then
        set_macro_page(1, 7)
    else
        set_macro_page(1, 7)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end