-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Magic Burst Mode Toggle
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Full Circle
--              [ CTRL+B ]          Blaze of Glory
--              [ CTRL+A ]          Ecliptic Attrition
--              [ CTRL+D ]          Dematerialize
--              [ CTRL+L ]          Life Cycle
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad0 ]    Myrkr
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


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
    indi_timer = ''
    indi_duration = 180

    state.CP = M(false, "Capacity Points Mode")
    lockstyleset = 4

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')

    -- Additional local binds
 --   include('Global-Binds.lua') -- OK to remove this line
--    include('Global-COR-Binds.lua') -- OK to remove this line
    include('sendbindsanti.lua')
    send_command('bind ^` input /ja "Full Circle" <me>')
    send_command('bind ^b input /ja "Blaze of Glory" <me>')
    send_command('bind ^a input /ja "Ecliptic Attrition" <me>')
    send_command('bind ^d input /ja "Dematerialize" <me>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')
	send_command('bind !z input /ma "Frazzle" <t>')
	send_command('bind !x input /ma "Distract" <t>')
	send_command('bind !a input /ma "Paralyze" <t>')
	send_command('bind !s input /ma "Slow" <t>')
	
	
    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind ^b')
    send_command('unbind ^b')
    send_command('unbind ^a')
    send_command('unbind ^d')
    send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')

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
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Precast Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +1"}
    sets.precast.JA['Life Cycle'] = {body="Geomancy Tunic +3", back="Nantosuelta's Cape"}

    -- Fast cast sets for spells

    sets.precast.FC = {
    --  /RDM --15
        range="Dunna", --3
        head={ name="Merlinic Hood", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+15',}}, --11
        body={ name="Merlinic Jubbah", augments={'Accuracy+19','"Fast Cast"+7','INT+4',}}, --13
        hands="Merlinic Dastanas", --6
        legs="Geomancy Pants +3", --15
        feet="Regal Pumps +1", --6
 --       neck="Regal Pumps +1", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
--        ring2="Weather. Ring +1", --5
        back="Lifestream Cape", --7
        waist="Witful Belt", --3/(3)
		-- 62 without subjob
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        waist="Siegel Sash",
        back="Perimede Cape",
        })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {hands="Bagua Mitaines +1"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --(2)
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +1",
        legs="Telchine Braconi",
        feet="Jhakri Pigaches +2",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Rufescent Ring",
        ring2="Shukuyu Ring",
        back="Relucent Cape",
        waist="Fotia Belt",
        }


    ------------------------------------------------------------------------
    ----------------------------- Midcast Sets -----------------------------
    ------------------------------------------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        main="Oranyan",
        sub="Clerisy Strap +1",
        head="Amalric Coif +1",
        hands="Merlinic Dastanas",
        legs="Geo. Pants +1",
        feet="Volte Gaiters",
        ear1="Loquacious Earring",
        ear2="Etiolation Earring",
        ring1="Kishar Ring",
        back="Lifestream Cape",
        } -- Haste

   sets.midcast.Geomancy = {
        main="Idris",
        sub="Genmei Shield",
        range="Dunna",
        head="Azimuth Hood +1",
        body="Vedic Coat",
        hands="Geomancy Mitaines +3",
        legs={ name="Vanya Slops", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
        feet="Azimuth Gaiters +1",
        neck="Bagua Charm +2",
        ear1="Gifted Earring",
        ear2="Calamitous Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe"},
        ring2="Mephitas's Ring +1",
        back="Lifestream Cape",
        waist="Shinjutsu-no-Obi +1",
        }

    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        head={ name="Vanya Hood", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
		hands="Geomancy Mitaines +3",
        legs="Bagua Pants +2",
        })
	 sets.midcast.Geomancy.Indi.Entrust = set_combine(sets.midcast.Geomancy.Indi, {
        main={ name="Gada", augments={'Indi. eff. dur. +10','VIT+3','Mag. Acc.+13','DMG:+13',}},
        })

    sets.midcast.Cure = {
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','CHR+14','Mag. Acc.+9','"Mag.Atk.Bns."+13',}},
        sub="Sors Shield", --3/(-5)
        head={ name="Vanya Hood", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
        body={ name="Vanya Robe", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
        hands={ name="Vanya Cuffs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
        legs={ name="Vanya Slops", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Incanter's Torque",
        ear1="Mendi. Earring", --5
        ear2="Loquacious Earring",
        ring1="Lebeche Ring", --3/(-5)
        ring2="Haoma's Ring",
        back="Oretan. Cape +1", --6
        waist="Bishop's Sash",
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        neck="Nuna Gorget +1",
        ring1={name="Stikini Ring +1", bag="wardrobe"},
        ring2={name="Stikini Ring +1", bag="wardrobe2"},
        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        main=gear.Gada_ENF,
        sub="Ammurapi Shield",
        head="Vanya Hood",
        body="Vanya Robe",
        hands="Hieros Mittens",
        feet="Vanya Clogs",
        neck="Debilis Medallion",
        ear1="Beatific Earring",
        ear2="Healing Earring",
        ring1="Menelaus's Ring",
        ring2="Haoma's Ring",
        })

    sets.midcast['Enhancing Magic'] = {
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','CHR+14','Mag. Acc.+9','"Mag.Atk.Bns."+13',}},
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        ear1="Augment. Earring",
        ear2="Andoaa Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe"},
        ring2={name="Stikini Ring +1", bag="wardrobe2"},
        back="Fi Follet Cape +1",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        main={ name="Gada", augments={'Enh. Mag. eff. dur. +5','CHR+14','Mag. Acc.+9','"Mag.Atk.Bns."+13',}},
        sub="Ammurapi Shield",
        head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +8',}},
        body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +8',}},
        hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
        legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +8',}},
        feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +9',}},
		waist="Embla Sash",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        body="Telchine Chas.",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif +1",
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        main="Vadose Rod",
        sub="Ammurapi Shield",
        head="Amalric Coif +1",
        waist="Emphatikos Rope",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast.MndEnfeebles = {
        main="Contemplator +1",
    	sub="Enki Strap",
        head="Geo. Galero +3",
        body="Geomancy Tunic +3",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Geo. Sandals +3",
        neck="Incanter's Torque",
        ear1="Regal Earring",
        ear2="Vor Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe"},
        ring2={name="Stikini Ring +1", bag="wardrobe2"},
        back={ name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10',}},
        waist="Luminary Sash",
        } -- MND/Magic accuracy

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
--        main=gear.Grioavolr_MB,
--        sub="Enki Strap",
        body="Amalric Doublet +1",
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        }) -- INT/Magic accuracy

    sets.midcast['Dark Magic'] = {
        main="Rubicundity",
        sub="Ammurapi Shield",
        head="Merlinic Hood",
        body="Amalric Doublet +1",
        hands="Ea Cuffs",
        legs="Azimuth Tights +1",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        ear1="Mani Earring",
        ear2="Regal Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe"},
        ring2="Evanescence Ring",
        back="Perimede Cape",
        waist="Luminary Sash",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Bagua Galero +1",
        feet="Merlinic Crackows",
        ear1="Hirudinea Earring",
        ring2="Archon Ring",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        feet="Volte Gaiters",
        })

    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
        main=gear.Grioavolr_MB,
        sub="Niobid Strap",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +1",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Sanctity Necklace",
        waist="Channeler's Stone",
        left_ear="Mendi. Earring",
        right_ear="Regal Earring",
        ring1="Freke Ring",
        ring2={name="Stikini Ring +1", bag="wardrobe"},
        back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
        }

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        back="Aurist's Cape +1",
        waist="Yamabuki-no-Obi",
        })

    sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {
        main="Solstice",
        sub="Ammurapi Shield",
        ring1="Fenrir Ring +1",
        ring2="Fenrir Ring +1",
        })

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        sub="Enki Strap",
        body="Seidr Cotehardie",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Sanctity Necklace",
        })

    sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {
        main="Solstice",
        sub="Ammurapi Shield",
        body="Seidr Cotehardie",
        neck="Erra Pendant",
        ring1="Fenrir Ring +1",
        ring2="Fenrir Ring +1",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Niobid Strap",
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ Idle Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Bolelabunga",
        sub="Genmei Shield",
        ranged="Dunna",
        head="Befouled Crown",
        body="Geomancy Tunic +3",
        hands="Geomancy Mitaines +3",
        legs="Assid. Pants +1",
        feet="Geo. Sandals +3",
        neck="Bathy Choker +1",
        ear1="Etiolation Earring",
        ear2="Odnowa Earring +1",
        ring1={name="Stikini Ring +1", bag="wardrobe"},
        ring2="Defending Ring",
        back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Pet: "Regen"+10','Pet: "Regen"+5',}},
        waist="Austerity Belt +1",
        }

    sets.resting = set_combine(sets.idle, {
        main="Chatoyant Staff",
        waist="Shinjutsu-no-Obi +1",
        })

    sets.idle.DT = set_combine(sets.idle, {
        main="Idris",
        sub="Genmei Shield", --10/0
        head="Volte Cap",
        body="Mallquis Saio +2", --8/8
        feet="Volte Boots",
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Slipor Sash", --0/3
        })

    sets.idle.Weak = sets.idle.DT

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, {
        -- Pet: -DT (37.5% to cap) / Pet: Regen
        main="Idris", --0/0/25/0
        sub="Genmei Shield", --10/0/0/0
        range="Dunna", --5/0
        head="Azimuth Hood +1", --0/3
        body={ name="Telchine Chas.", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}}, --0/3
        neck="Bagua Charm +2",
		hands="Geomancy Mitaines +3", --13/0
        legs= { name="Telchine Braconi", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}}, --0/3
        feet={ name="Telchine Pigaches", augments={'Pet: "Regen"+3','Pet: Damage taken -4%',}}, --0/3
        ear1="Etiolation Earring",
        ear2="Odnowa Earring +1", --3
        ring1="Gelatinous Ring +1", --7/(-1)/0/0
        ring2="Defending Ring", --10/10/0/0
		back={ name="Nantosuelta's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Pet: "Regen"+10','Pet: "Regen"+5',}}, --0/10
        waist="Isa Belt" --3/1
		-- Self DT 33
        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
        body="Mallquis Saio +2", --8/8
        legs="Psycloth Lappas", --4/0
        neck="Loricate Torque +1", --6/6
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        })

    -- .Indi sets are for when an Indi-spell is active.
--    sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants +1"})
--    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants +1"})
--    sets.idle.DT.Indi = set_combine(sets.idle.DT, {legs="Bagua Pants +1"})
--    sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {legs="Bagua Pants +1"})

    sets.idle.Town = set_combine(sets.idle, {
        main="Idris",
        sub="Ammurapi Shield",
        head="Azimuth Hood +1",
        body="Amalric Doublet +1",
        hands="Amalric Gages +1",
        legs="Amalric Slops +1",
        neck="Incanter's Torque",
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Fenrir Ring +1",
        ring2="Weather. Ring +1",
		feet="Geo Sandals +3"
        })

    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {
        feet="Geo. Sandals +3"
        }

    sets.latent_refresh = {
        waist="Fucho-no-obi"
        }

    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +1",
        feet="Jhakri Pigaches +2",
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Hetairoi Ring",
        ring2="Chirich Ring +1",
        back="Relucent Cape",
        waist="Windbuffet Belt +1",
        }


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.magic_burst = {
        body=gear.Merl_MB_body, --10
        hands="Amalric Gages +1", --(6)
        feet="Merlinic Crackows", --11
        neck="Mizu. Kubikazari", --10
        ring1="Mujin Band", --(5)
        back="Seshaw Cape", --5
        }

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Eshmun's Ring", --20
        ring2="Eshmun's Ring", --20
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
	end	
	if spell.english:startswith('Indi') and buffactive['Entrust'] then
        equip(sets.midcast.Geomancy.Indi.Entrust)	
	end	
    
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            --send_command('@timers d "'..indi_timer..'"')
            --indi_timer = spell.english
            --send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.skill == 'Elemental Magic' then
 --           state.MagicBurst:reset()
        end
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end

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
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' then
            if spellMap == 'GeoElem' then
                return 'GeoElem'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
	if world.area:endswith('Adoulin') then
	    idleSet = set_combine(idleSet,{body="Councilor's Garb"})
	end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 2)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end