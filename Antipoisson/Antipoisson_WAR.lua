-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad8 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('Global-Binds.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Retaliation'] = buffactive['Retaliation'] or false
--    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
--    state.Buff['Feint'] = buffactive['feint'] or false

    include('Mote-TreasureHunter')


    state.AttackMode = M{['description']='Attack', 'Capped', 'Uncapped'}
    state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 10
	
	no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'STP', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'DT', 'Refresh')
    state.WeaponMode = M{['description']='Weapon Mode', 'Chango', 'Montante +1'}
	
    -- Additional local binds
--    include('Global-Binds.lua') -- OK to remove this line
--    include('Global-GEO-Binds.lua') -- OK to remove this line
--    include('Poisson-Globals.lua')
    include('organizer-lib')
	include('sendbinds.lua')
	include('sendbindsanti.lua')
--	send_command('org organize')
    send_command('lua l gearinfo')
--	send_command('lua l equipviewer')
--	send_command('equipviewer pos 2160 400')

    send_command('bind ^` gs c cycle treasuremode')
--    send_command('bind !` input /ja "Flee" <me>')
    send_command('bind @a gs c cycle AttackMode')
    send_command('bind @c gs c toggle CP')
    send_command('bind !w gs c cycle WeaponMode')
--    send_command('bind ^numlock input /ja "Assassin\'s Charge" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end

    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad8 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
    send_command('bind ^numpad2 input /ws "Wasp Sting" <t>')
    send_command('bind ^numpad3 input /ws "Gust Slash" <t>')

    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
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
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @a')
    send_command('unbind @c')
    send_command('unbind @r')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

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
	send_command('unbind @w')	

    send_command('lua u gearinfo')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
        
        legs={ name="Odyssean Cuisses", augments={'Attack+8','Weapon Skill Acc.+8','"Treasure Hunter"+2','Accuracy+4 Attack+4',}},
        waist="Chaac Belt", --1
        }


    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
--    sets.precast.JA.Provoke = sets.TreasureHunter
    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Berserk'] = {body="Pumm. Lorica +3",feet="Agoge Calligae +1"}
    sets.precast.JA['Aggressor'] = {head="Pumm. Mask +1",body="Agoge Lorica +1"}
    sets.precast.JA['Blood Rage'] = {body="Boii Lorica +1"}
    sets.precast.JA['Warcry'] = {head="Agoge Mask"}
    sets.precast.JA['Mighty Strikes'] = {hands="Agoge Mufflers +1"}

       sets.precast.Waltz = {
        legs="Dashing Subligar",
 --       neck="Phalaina Locket",
 --       ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        ammo="Sapience Orb",
        head={ name="Herculean Helm", augments={'Phys. dmg. taken -3%','"Dbl.Atk."+1','Weapon skill damage +9%','Accuracy+17 Attack+17','Mag. Acc.+3 "Mag.Atk.Bns."+3',}}, --7
        body={ name="Taeon Tabard", augments={'"Fast Cast"+5',}}, --9
        hands="Leyline Gloves", --7
        legs={ name="Herculean Trousers", augments={'Mag. Acc.+25','"Fast Cast"+6','MND+8',}}, --6
        feet={ name="Herculean Boots", augments={'Mag. Acc.+8','"Fast Cast"+6','STR+7','"Mag.Atk.Bns."+6',}}, --6
        neck="Voltsurge Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Etiolation Earring", --2
--        ring2="Weather. Ring +1", --6(4)
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
--        body="Passion Jacket",
        ring1="Lebeche Ring",
        })

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

 	sets.precast.WS = {
			ammo="Knobkierrie",
			head="Flam. Zucchetto +2",
			body={ name="Argosy Hauberk +1", augments={'STR+12','DEX+12','Attack+20',}},
			hands={ name="Argosy Mufflers +1", augments={'STR+12','DEX+12','Attack+20',}},
			legs={ name="Argosy Breeches +1", augments={'STR+12','DEX+12','Attack+20',}},
			feet="Flam. Gambieras +2",
			neck="Fotia Gorget",
			waist="Fotia Belt",
			left_ear="Brutal Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Regal Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+5','"Dbl.Atk."+10',}},
	}

	-- Decimation Sets --
	sets.precast.WS.Decimation = {
			ammo="Seeth. Bomblet",
			head="Flam. Zucchetto +2",
			body={ name="Argosy Hauberk +1", augments={'STR+12','DEX+12','Attack+20',}},
			hands={ name="Argosy Mufflers +1", augments={'STR+12','DEX+12','Attack+20',}},
			legs={ name="Argosy Breeches +1", augments={'STR+12','DEX+12','Attack+20',}},
			feet="Flam. Gambieras +2",
			neck="Fotia Gorget",
			waist="Fotia Belt",
			left_ear="Brutal Earring",
			right_ear="Cessance Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Regal Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+5','"Dbl.Atk."+10',}},
	}
	sets.precast.WS.Decimation.MidACC = set_combine(sets.precast.WS.Decimation,{})
	sets.precast.WS.Decimation.HighACC = set_combine(sets.precast.WS.Decimation.MidACC,{})
	sets.precast.WS.Decimation.MaxACC = set_combine(sets.precast.WS.Decimation.HighACC,{})

	-- Upheaval Sets --
	sets.precast.WS.Upheaval = {
			ammo="Knobkierrie",
			head={ name="Odyssean Helm", augments={'Attack+9','Weapon skill damage +4%','VIT+13',}},
			body="Pumm. Lorica +3",
			hands={ name="Odyssean Gauntlets", augments={'Attack+7','Weapon skill damage +4%','VIT+7','Accuracy+8',}},
			legs={ name="Odyssean Cuisses", augments={'Accuracy+19 Attack+19','Weapon skill damage +3%','VIT+5','Accuracy+15',}},
			feet="Sulev. Leggings +2",
--			neck={ name="War. Beads +2", augments={'Path: A',}},
			waist="Grunfeld Rope",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			ring1="Gelatinous Ring +1",
			ring2="Regal Ring",
			back={ name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS.Upheaval.MidACC = set_combine(sets.precast.WS.Upheaval,{})
	sets.precast.WS.Upheaval.HighACC = set_combine(sets.precast.WS.Upheaval.MidACC,{})
	sets.precast.WS.Upheaval.MaxACC = set_combine(sets.precast.WS.Upheaval.HighACC,{})

	-- Upheaval(Attack) Set --
	sets.precast.WS.Upheaval.ATT = set_combine(sets.precast.WS.Upheaval,{})

	-- Ukko's Fury Sets --
	sets.precast.WS["Ukko's Fury"] = {}
	sets.precast.WS["Ukko's Fury"].MidACC = set_combine(sets.precast.WS["Ukko's Fury"],{})
	sets.precast.WS["Ukko's Fury"].HighACC = set_combine(sets.precast.WS["Ukko's Fury"].MidACC,{})
	sets.precast.WS["Ukko's Fury"].MaxACC = set_combine(sets.precast.WS["Ukko's Fury"].HighACC,{})

	-- Ukko's Fury(Attack) Set --
	sets.precast.WS["Ukko's Fury"].ATT = set_combine(sets.precast.WS["Ukko's Fury"],{})

	-- King's Justice Sets --
	sets.precast.WS["King's Justice"] = {}
	sets.precast.WS["King's Justice"].MidACC  = set_combine(sets.precast.WS["King's Justice"],{})
	sets.precast.WS["King's Justice"].HighACC = set_combine(sets.precast.WS["King's Justice"].MidACC,{})
	sets.precast.WS["King's Justice"].MaxACC = set_combine(sets.precast.WS["King's Justice"].HighACC,{})

	-- Resolution Sets --
	sets.precast.WS.Resolution = {
			ammo="Seeth. Bomblet",
			head="Sakpata's Helm",
            body="Sakpata's Plate",
            hands="Sakpata's Gauntlets",
            legs="Sakpata's Cuisses",
            feet="Sakpata's Leggings",
			neck="Fotia Gorget",
			waist="Fotia Belt",
			left_ear="Brutal Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Regal Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+5','"Dbl.Atk."+10',}},
	}
	sets.precast.WS.Resolution.MidACC = set_combine(sets.precast.WS.Resolution,{})
	sets.precast.WS.Resolution.HighACC = set_combine(sets.precast.WS.Resolution.MidACC,{})
	sets.precast.WS.Resolution.MaxACC = set_combine(sets.precast.WS.Resolution.HighACC,{})

	-- Mistral Axe Sets --
	sets.precast.WS["Mistral Axe"] = {
			ammo="Knobkierrie",
			head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
			body="Pumm. Lorica +3",
			hands={ name="Valorous Mitts", augments={'Weapon skill damage +3%','STR+7','Accuracy+9','Attack+5',}},
			legs={ name="Valorous Hose", augments={'Attack+22','Weapon skill damage +4%','STR+6',}},
			feet="Sulev. Leggings +2",
			neck={ name="War. Beads +2", augments={'Path: A',}},
			waist="Sailfi belt +1",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Epaminondas's Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS["Mistral Axe"].MidACC  = set_combine(sets.precast.WS["Mistral Axe"],{})
	sets.precast.WS["Mistral Axe"].HighACC = set_combine(sets.precast.WS["Mistral Axe"].MidACC,{})
	sets.precast.WS["Mistral Axe"].MaxACC = set_combine(sets.precast.WS["Mistral Axe"].HighACC,{})

	-- Cloudsplitter Sets --
	sets.precast.WS["Cloudsplitter"] = {
			ammo="Knobkierrie",
			head={ name="Valorous Mask", augments={'INT+9','"Mag.Atk.Bns."+24','"Refresh"+1','Mag. Acc.+14 "Mag.Atk.Bns."+14',}},
			body={ name="Valorous Mail", augments={'Accuracy+1','"Mag.Atk.Bns."+29','Accuracy+1 Attack+1','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
			hands={ name="Valorous Mitts", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','CHR+10',}},
			legs={ name="Valorous Hose", augments={'AGI+2','Accuracy+3 Attack+3','Weapon skill damage +4%','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
			feet={ name="Valorous Greaves", augments={'"Mag.Atk.Bns."+22','Pet: Mag. Acc.+23 Pet: "Mag.Atk.Bns."+23','INT+1 MND+1 CHR+1','Accuracy+1 Attack+1','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
			neck="Baetyl Pendant",
			waist="Eschan Stone",
			left_ear="Friomisi Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Epaminondas's Ring",
			back={ name="Cichol's Mantle", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS["Cloudsplitter"].MidACC  = set_combine(sets.precast.WS["Cloudsplitter"],{})
	sets.precast.WS["Cloudsplitter"].HighACC = set_combine(sets.precast.WS["Cloudsplitter"].MidACC,{})
	sets.precast.WS["Cloudsplitter"].MaxACC = set_combine(sets.precast.WS["Cloudsplitter"].HighACC,{})

	-- Calamity Sets --
	sets.precast.WS["Calamity"] = {
			ammo="Knobkierrie",
			head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
			body="Pumm. Lorica +3",
			hands={ name="Valorous Mitts", augments={'Weapon skill damage +3%','STR+7','Accuracy+9','Attack+5',}},
			legs={ name="Valorous Hose", augments={'Attack+22','Weapon skill damage +4%','STR+6',}},
			feet="Sulev. Leggings +2",
			neck={ name="War. Beads +2", augments={'Path: A',}},
			waist="Sailfi belt +1",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Karieyh Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS["Calamity"].MidACC  = set_combine(sets.precast.WS["Calamity"],{})
	sets.precast.WS["Calamity"].HighACC = set_combine(sets.precast.WS["Calamity"].MidACC,{})
	sets.precast.WS["Calamity"].MaxACC = set_combine(sets.precast.WS["Calamity"].HighACC,{})

	-- Savage Blade Sets --
	sets.precast.WS["Savage Blade"] = {
			ammo="Knobkierrie",
			head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
			body="Pumm. Lorica +3",
			hands={ name="Valorous Mitts", augments={'Weapon skill damage +3%','STR+7','Accuracy+9','Attack+5',}},
			legs={ name="Valorous Hose", augments={'Attack+22','Weapon skill damage +4%','STR+6',}},
			feet="Sulev. Leggings +2",
			neck={ name="War. Beads +2", augments={'Path: A',}},
			waist="Sailfi belt +1",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Karieyh Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS["Savage Blade"].MidACC  = set_combine(sets.precast.WS["Savage Blade"],{})
	sets.precast.WS["Savage Blade"].HighACC = set_combine(sets.precast.WS["Savage Blade"].MidACC,{})
	sets.precast.WS["Savage Blade"].MaxACC = set_combine(sets.precast.WS["Savage Blade"].HighACC,{})

	-- Fell Cleave Set --
	sets.precast.WS["Fell Cleave"] = set_combine(sets.precast.WS["Resolution"], {
	
			ammo="Knobkierrie",
			head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
			body="Pumm. Lorica +3",
			hands={ name="Valorous Mitts", augments={'Weapon skill damage +3%','STR+7','Accuracy+9','Attack+5',}},
			legs={ name="Valorous Hose", augments={'Attack+22','Weapon skill damage +4%','STR+6',}},
			feet="Sulev. Leggings +2",
			neck={ name="War. Beads +2", augments={'Path: A',}},
--			waist="Sailfi belt +1",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Regal Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	})

	-- Stardiver Sets --
	sets.precast.WS.Stardiver = {
			ammo="Seeth. Bomblet",
			head="Flam. Zucchetto +2",
			body={ name="Argosy Hauberk +1", augments={'STR+12','DEX+12','Attack+20',}},
			hands={ name="Argosy Mufflers +1", augments={'STR+12','DEX+12','Attack+20',}},
			legs={ name="Argosy Breeches +1", augments={'STR+12','DEX+12','Attack+20',}},
			feet="Flam. Gambieras +2",
			neck="Fotia Gorget",
			waist="Fotia Belt",
			left_ear="Brutal Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Regal Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},	
	}
	sets.precast.WS.Stardiver.MidACC = set_combine(sets.precast.WS.Stardiver,{})
	sets.precast.WS.Stardiver.HighACC = set_combine(sets.precast.WS.Stardiver.MidACC,{})
	sets.precast.WS.Stardiver.MaxACC = set_combine(sets.precast.WS.Stardiver.HighACC,{})

	-- Impulse Drive Sets --
	sets.precast.WS["Impulse Drive"] = {
			ammo="Knobkierrie",
			head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
			body="Pumm. Lorica +3",
			hands={ name="Valorous Mitts", augments={'Weapon skill damage +3%','STR+7','Accuracy+9','Attack+5',}},
			legs={ name="Valorous Hose", augments={'Attack+22','Weapon skill damage +4%','STR+6',}},
			feet="Sulev. Leggings +2",
			neck={ name="War. Beads +2", augments={'Path: A',}},
			waist="Sailfi belt +1",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Regal Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS["Impulse Drive"].MidACC  = set_combine(sets.precast.WS["Impulse Drive"],{})
	sets.precast.WS["Impulse Drive"].HighACC = set_combine(sets.precast.WS["Impulse Drive"].MidACC,{})
	sets.precast.WS["Impulse Drive"].MaxACC = set_combine(sets.precast.WS["Impulse Drive"].HighACC,{})

	-- Rampage Sets --
	sets.precast.WS["Rampage"] = {
			ammo="Yetshila +1",
			head="Flam. Zucchetto +2",
			neck="Fotia Gorget",
			ear1="Brutal Earring",
			ear2="Moonshade Earring",
			body="Hjarrandi Breast.",
			hands="Flam. Manopolas +2",
			ring1="Regal Ring",
			ring2="Niqmaddu Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
			waist="Fotia Belt",
			legs="Agoge Cuisses +3",
			feet="Boii Calligae +1"	
	}
	sets.precast.WS["Rampage"].MidACC  = set_combine(sets.precast.WS["Rampage"],{})
	sets.precast.WS["Rampage"].HighACC = set_combine(sets.precast.WS["Rampage"].MidACC,{})
	sets.precast.WS["Rampage"].MaxACC = set_combine(sets.precast.WS["Rampage"].HighACC,{})

	-- Savage Blade Sets --
	sets.precast.WS["Black Halo"] = {
			ammo="Knobkierrie",
			head={ name="Agoge Mask +3", augments={'Enhances "Savagery" effect',}},
			body="Pumm. Lorica +3",
			hands={ name="Valorous Mitts", augments={'Weapon skill damage +3%','STR+7','Accuracy+9','Attack+5',}},
			legs={ name="Valorous Hose", augments={'Attack+22','Weapon skill damage +4%','STR+6',}},
			feet="Sulev. Leggings +2",
			neck={ name="War. Beads +2", augments={'Path: A',}},
			waist="Sailfi belt +1",
			left_ear="Thrud Earring",
			right_ear="Moonshade Earring",
			left_ring="Niqmaddu Ring",
			right_ring="Karieyh Ring",
			back={ name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},	
	}
	sets.precast.WS["Black Halo"].MidACC  = set_combine(sets.precast.WS["Black Halo"],{})
	sets.precast.WS["Black Halo"].HighACC = set_combine(sets.precast.WS["Black Halo"].MidACC,{})
	sets.precast.WS["Black Halo"].MaxACC = set_combine(sets.precast.WS["Black Halo"].HighACC,{})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
    sets.midcast.Poisonga = sets.TreasureHunter

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Bathy Choker +1",
        ear1="Eabani Earring",
        ear2="Genmei Earring",
		ring1="Moonbeam Ring",
		ring2="Gelatinous Ring +1",		
--        ring1={name="Chirich Ring +1", bag="wardrobe3"},
--        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Engraved Belt",
		back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        neck="Warder's Charm +1",
        ear1="Sanare Earring",
        ring1="Purity Ring", --0/4
        ring2="Defending Ring", --10/10
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        })

--    sets.idle.Town = set_combine(sets.idle, {
--        main="Vajra",
--        sub="Twashtar",
--		ammo="Yetshila +1",
--       body="Pillager's Vest +3",
--        neck="Combatant's Torque",
--        ear1="Sherida Earring",
--        ear2="Telos Earring",
--        back=gear.THF_TP_Cape,
--        waist="Windbuffet Belt +1",
--        })
   
   sets.idle.Refresh = set_combine(sets.idle, {
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe1"},
        })		

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Fajin Boots"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
        ammo="Aurgelmir orb",
		sub="Utu Grip",
        head="Flam. Zucchetto +2",
        body="Tatena. Harama. +1",
        hands="Sakpata's gauntlets",
        legs="Sakpata's Cuisses",
        feet="Flam. Gambieras +2",
        neck="Vim Torque +1",
        ear1="Telos Earring",
		ear2="Cessance Earring",
		ring1="Niqmaddu Ring",
		ring2="Petrov Ring",
        back={ name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        waist="Ioskeha Belt +1",
        }
	sets.engaged.Chango = {main="Chango"}
    sets.engaged.Montante = {main="Montante +1"}

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ear2="Telos Earring",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ammo="C. Palug Stone",
        head="Dampening Tam",
        body="Pillager's Vest +3",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Mache Earring +1",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        })

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1", --6
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Vim Torque +1",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Gere Ring",
        back= {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 41%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        head="Dampening Tam",
        body="Pillager's Vest +3",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Adhemar Jacket +1", --6
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','DEX+9',}}, --9
        neck="Vim Torque +1",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Gere Ring",
        back= {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 37%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        head="Dampening Tam",
        body="Pillager's Vest +3",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        neck="Anu Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Pillager's Vest +3",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3",
        neck="Vim Torque +1",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Gere Ring",
        back= {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 26%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Pillager's Vest +3",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3",
        neck="Vim Torque +1",
        ear1="Sherida Earring",
        ear2="Eabani Earring", --4
        ring1="Hetairoi Ring",
        ring2="Gere Ring",
        back= {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10
        waist="Reiki Yotai", --7
        } -- 21%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        ammo="Yamarang",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Pillager's vest +3",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        legs="Samnuha Tights",
        feet="Plun. Poulaines +3",
        neck="Vim Torque +1",
        ear1="Sherida Earring",
        ear2="Suppanomimi",
        ring1="Hetairoi Ring",
        ring2="Gere Ring",
        back= {name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}}, --10
        waist="Windbuffet Belt +1",
        } -- 5%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe1"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.Savage = {
 		main="Naegling",
        sub="Twashtar",
        }
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head="Sakpata's Helm",
        body="Sakpata's Plate",
        hands="Sakpata's Gauntlets",
        legs="Sakpata's Cuisses",
        feet="Sakpata's Leggings",
        ear1="Telos Earring",
		ear2="Dedition Earring",
		ring1="Defending Ring", --10/10
--		waist="Windbuffet Belt +1", 
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

     ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    --sets.Reive = {neck="Ygnas's Resolve +1"}
    sets.CP = {back="Mecisto. Mantle"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
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
    if spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Aeolian Edge' then
            -- Matching double weather (w/o day conflict).
            if spell.element == world.weather_element and (get_weather_intensity() == 2 and spell.element ~= elements.weak_to[world.day_element]) then
                equip({waist="Hachirin-no-Obi"})
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

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
    if buff:startswith('Aftermath') then
        state.Buff.Aftermath = gain
        customize_melee_set()
        handle_equipping_gear(player.status)
    end
    if not midaction() then
        handle_equipping_gear(player.status)
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

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, action, spellMap)
    local wsmode

    if spell.type == 'WeaponSkill' and state.AttackMode.value == 'Uncapped' then
        wsmode = 'Uncapped'
    end
    --if state.Buff['Sneak Attack'] then
    --    wsmode = 'SA'
    --end
    --if state.Buff['Trick Attack'] then
    --    wsmode = (wsmode or '') .. 'TA'
    --end

    return wsmode
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
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

function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Twashtar" then
	    meleeSet = sets.engaged.DW.Twashtar.Aftermath
    end
	if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Twashtar" and state.HybridMode.Current == "DT" then
       meleeSet = sets.engaged.DW.Twashtar.Aftermath.DT
	end
	if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Vajra" then
	    meleeSet = sets.engaged.DW.Vajra.Aftermath
    end
	if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Vajra" and state.HybridMode.Current == "DT" then
       meleeSet = sets.engaged.DW.Vajra.Aftermath.DT
	end
	if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    if state.WeaponMode.Current == 'Chango' then
	    meleeSet = set_combine(meleeSet, sets.engaged.Chango)
	elseif state.WeaponMode.Current == 'Montante +1' then
	    meleeSet = set_combine(meleeSet, sets.engaged.Montante)
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

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
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
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
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


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        local allRecasts = windower.ffxi.get_ability_recasts()
        local prestoCooldown = allRecasts[236]
        local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']

        if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
        end
    end
end

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

windower.register_event('zone change',
    function()
        send_command('gi ugs true')
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
    if player.sub_job == 'DNC' then
        set_macro_page(2, 4)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 4)
    else
        set_macro_page(1, 4)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end