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
    state.Buff.Sentinel = buffactive.sentinel or false
    sets.buff['Cover'] = sets.precast.JA['Cover'] or false
    state.Buff.Doom = buffactive.Doom or false
	include('Mote-TreasureHunter')
	lockstyleset = 22
	no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
        "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT', 'Reraise')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'HP', 'Reraise', 'Charm')
    state.MagicalDefenseMode:options('MDT', 'HP', 'Reraise', 'Charm')
    
    state.ExtraDefenseMode = M{['description']='Extra Defense Mode', 'None', 'MP'}
    state.EquipShield = M(false, 'Equip Shield w/Defense')
	state.WeaponLock = M(false, 'Weapon Lock')
    update_defense_mode()
    
	send_command('bind ^` gs c cycle treasuremode')
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind !f11 gs c cycle ExtraDefenseMode')
    send_command('bind @f10 gs c toggle EquipShield')
    send_command('bind @f11 gs c toggle EquipShield')
	send_command('bind @w gs c toggle WeaponLock')
	send_command('bind !x input /ja "Invincible" <me>')
	send_command('bind @z input /item "Hidhaegg\'s Scale" <t>')
	send_command('bind @x input /item "Sovereign\'s Hide" <t>')
	send_command('bind @c input /item "Sarama\'s Hide" <t>')
	send_command('bind @v input /item "Tumult\'s Blood" <t>')
	
    select_default_macro_book()
	set_lockstyle()
	include('Global-Binds.lua')
	include('sendbinds.lua')
end

function user_unload()
    send_command('unbind ^f11')
    send_command('unbind !f11')
    send_command('unbind @f10')
    send_command('unbind @f11')
	send_command('unbind ^`')
	send_command('unbind @w')
	send_command('unbind !x')
	send_command('unbind @z')
	send_command('unbind @x')
	send_command('unbind @c')
	send_command('unbind @v')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------
    sets.Enmity = {
        ammo="Sapience Orb", --2en 0/0/0
        head={ name="Loess Barbuta +1", priority=15},--24en 20dt /0/0 HP105
		body="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, --20en 10dt hp105
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --9en 239hp
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --9en 162hp
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --9en pdt5 227hp
        neck="Moonlight Necklace", --10 0/0/0
        waist="Creed Baudrier", --5en 0/0/0 hp40
        left_ear="Trux Earring", --5en 0/0/0
        right_ear="Cryptic Earring", --4en 3/0/2 hp40
        left_ring="Vengeful ring", --3en 0/0/0 hp20
        right_ring={name="Moonlight Ring",bag="wardrobe5", priority=15}, -- 5dt/0/0 gp110
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}, --10en 0/10pdt/0 hp80
        }
		
    -- Precast sets to enhance JAs
    sets.precast.JA['Invincible'] = set_combine(sets.Enmity, {legs="Cab. Breeches +1"})
    sets.precast.JA['Holy Circle'] = set_combine(sets.Enmity, {feet="Rev. Leggings +3"})
    sets.precast.JA['Shield Bash'] = set_combine(sets.Enmity, {hands="Cab. Gauntlets +1"})
	sets.precast.JA['Intervene'] = sets.precast.JA['Shield Bash']
    sets.precast.JA['Sentinel'] = set_combine(sets.Enmity, {feet="Cab. Leggings +1"})
    sets.precast.JA['Fealty'] = set_combine(sets.Enmity, {body="Cab. Surcoat +1"})
    sets.precast.JA['Divine Emblem'] = set_combine(sets.Enmity, {feet="Chev. Sabatons +1"})
    sets.precast.JA['Rampart'] = set_combine(sets.Enmity, {legs="Cab. Coronet +1"})
    sets.precast.JA['Cover'] = set_combine(sets.precast.JA['Rampart'], {head="Rev. Coronet +1", body="Cab. Surcoat +1"})
	sets.precast.JA['Majesty'] = sets.Enmity
	
    -- add mnd for Chivalry
    sets.precast.JA['Chivalry'] = set_combine(sets.Enmity, {hands="Cab. Gauntlets +1"})

    --sub WAR
    sets.precast.JA['Warcry'] = sets.Enmity
    sets.precast.JA['Defender'] = sets.Enmity
    sets.precast.JA['Provoke'] = sets.Enmity

    ------------------------ Sub RUN ------------------------ 
    sets.precast.JA['Ignis'] = sets.Enmity
    sets.precast.JA['Gelus'] = sets.Enmity
    sets.precast.JA['Flabra'] = sets.Enmity
    sets.precast.JA['Tellus'] = sets.Enmity
    sets.precast.JA['Sulpor'] = sets.Enmity
    sets.precast.JA['Unda'] = sets.Enmity
    sets.precast.JA['Lux'] = sets.Enmity
    sets.precast.JA['Tenebrae'] = sets.Enmity
     
    sets.precast.JA['Vallation'] = sets.Enmity
     
    sets.precast.JA['Pflug'] = sets.Enmity
          
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Reverence Coronet +1",
        body="Gorney Haubert +1",hands="Reverence Gauntlets +1",ring2="Asklepian Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Reverence Breeches +1",feet="Whirlpool Greaves"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}
    
    sets.precast.Step = {waist="Chaac Belt"}
    sets.precast.Flourish1 = {waist="Chaac Belt"}

    -- Fast cast sets for spells
    
 	sets.precast.FC = {
        ammo="Sapience Orb", --2 0/0/0
        head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}}, --14FC HP38
        body={ name="Rev. Surcoat +3", priority=15},--10FC HP254
	    hands="Leyline Gloves", -- 7FC HP25
	    legs="Enif Cosciales", --8FC HP40
        feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}, priority=15}, --8FC HP 95
--        feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+8','"Fast Cast"+6','MND+3',}}, --11
	    neck="Unmoving Collar +1", -- HP 200
--        waist={ name="Creed Baudrier", priority=15},--HP40
		waist={ name="Gold Mog. Belt", priority=15},--HP40
  		left_ear="Tuisto Earring", --HP 150
--        right_ear="Odnowa Earring +1", -- HP 110
        right_ear="Etiolation Earring", -- HP 50
        left_ring="Gelatinous Ring +1", -- HP 135
        right_ring="Weather. Ring +1",  --6 / 4
        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
       }	
     --FC 64
	 --HP 1167
	sets.precast.FC.DT = set_combine(sets.precast.FC, { 
--        ammo="Sapience Orb", --2 0/0/0
--        head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}}, --14
--         body={ name="Rev. Surcoat +3", priority=254}, --10
--	    hands="Leyline Gloves", -- 7
--	    legs="Enif Cosciales", --8
--        feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}, priority=15},
--        --feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+8','"Fast Cast"+6','MND+3',}}, --11
--	    neck={ name="Unmoving Collar +1", priority=15},
--        waist="Creed Baudrier",
--		left_ear={name="Tuisto Earring", priority=15},
--        right_ear={name="Odnowa Earring +1", priority=15},
--        left_ring={name="Gelatinous Ring +1", priority=15},
--        right_ring="Weather. Ring +1",  --6 / 4
--        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}}, --10,
        })
	
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
         
    sets.precast.FC.Cure = set_combine(sets.precast.FC, { 
--        ammo="Sapience Orb",
--        head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
--        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
--        legs={ name="Odyssean Cuisses", augments={'AGI+1','Pet: DEX+1','"Fast Cast"+7','Mag. Acc.+9 "Mag.Atk.Bns."+9',}},
--        feet="Carmine Greaves +1", --8
--        neck="Baetyl Pendant",
--        waist="Gold Mog. Belt",
--        left_ear="Nourish. Earring +1",
--        right_ear="Mendi. Earring",
--        left_ring="Kishar Ring",
--        right_ring={name="Moonlight Ring",bag="wardrobe5", priority=15},
--        back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
        })      

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
     sets.precast.WS = {
    	ammo="Coiste Bodhar",
        head="Nyame Helm", --HP91
        body="Nyame Mail", --HP136
        hands="Nyame Gauntlets", --HP91
        legs="Nyame Flanchard", --HP114
        feet="Nyame sollerets", --HP68
        neck="Unmoving Collar +1",--HP200
        waist="Fotia Belt",
        left_ear="Tuisto Earring",--HP150
        right_ear="Odnowa Earring +1",--HP110
        left_ring="Gelatinous Ring +1",--HP135
        right_ring={name="Moonlight Ring",bag="wardrobe5",},--110
        back={ name="Rudianos's Mantle", augments={'HP+60','Accuracy+20 Attack+20','HP+20','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
		}	

    sets.precast.WS.Acc = {ammo="Ginsen",
        head="Yaoyotl Helm",neck=gear.ElementalGorget,ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Gorney Haubert +1",hands="Buremte Gloves",ring1="Rajas Ring",ring2="Patricius Ring",
        back="Atheling Mantle",waist=gear.ElementalBelt,legs="Cizin Breeches",feet="Whirlpool Greaves"}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {ring1="Leviathan Ring",ring2="Aquasoul Ring"})
    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS.Acc, {ring1="Leviathan Ring"})

   sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
		ammo="Aurgelmir Orb +1",
		head="Flam. Zucchetto +2",
		body="Hjarrandi Breastplate",
		hands="Flamma Manopolas +2",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet="Flamma Gambieras +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		right_ear="Thrud Earring",
		left_ring="Flamma Ring",
		right_ring="Regal Ring",
		back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Phys. dmg. taken-10%',}},
		})

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS.Acc, {waist="Zoran's Belt"})
	
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
	    waist="Sailfi Belt +1",
		})

    sets.precast.WS['Sanguine Blade'] = {ammo="Ginsen",
        head="Reverence Coronet +1",neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Shiva Ring",ring2="K'ayres Ring",
        back="Toro Cape",waist="Caudata Belt",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    
	sets.precast.WS['Atonement'] = set_combine(sets.Enmity, {
--		ammo="Iron Gobbet",
--      head="Reverence Coronet +1",
--        neck=gear.ElementalGorget,
--		ear1="Creed Earring",
--		ear2="Steelflash Earring",
--      body="Souv. Cuirass +1",
--		hands="Reverence Gauntlets +1",
--		ring1="Rajas Ring",
--		ring2="Vexer Ring",
--      back="Fierabras's Mantle",
--		waist=gear.ElementalBelt,
--		legs="Reverence Breeches +1",
--		feet="Caballarius Leggings"}
    })
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = sets.precast.FC
        
    sets.midcast.Enmity = sets.Enmity
    
	sets.midcast.SpellInterrupt = {
		ammo="Staunch Tathlum +1", --11
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --20
		hands="Regal Gauntlets", --10
		legs="Founder's Hose", --30
--		legs="Carmine Cuisses +1", --20
		feet={ name="Odyssean Greaves", augments={'"Mag.Atk.Bns."+8','"Fast Cast"+6','MND+3',}}, --20
		neck="Moonlight Necklace", --15
		waist="Audumbla Sash", --10
		}

    sets.midcast.Divine = {
		main="Brilliance",
		head="Jumalik Helm",
		body="Rev. Surcoat +3",
		hands="Eschite Gauntlets",
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},
		neck="Incanter's Torque",
		waist="Asklepian Belt",
		right_ear="Odnowa Earring +1",
		left_ear="Etiolation Earring",
		back="Moonlight Cape",
		}

    sets.midcast.Divine.DT = {
		ammo="Staunch Tathlum +1",
		head={ name="Jumalik Helm", augments={'MND+10','"Mag.Atk.Bns."+15','Magic burst dmg.+10%','"Refresh"+1',}},
		body="Rev. Surcoat +3",
		hands={ name="Eschite Gauntlets", augments={'Mag. Evasion+15','Spell interruption rate down +15%','Enmity+7',}},
		legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},
		neck="Incanter's Torque",
		waist="Asklepian Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Saxnot Earring",
		left_ring={name="Stikini Ring +1",bag="wardrobe2"},
		right_ring={name="Stikini Ring +1",bag="wardrobe3"},
		back="Moonlight Cape",
		}

	
	--skill 430
	sets.midcast['Enhancing Magic'] ={
		ammo="Staunch Tathlum +1",
        head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --HP280
--		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}}, --HP38
        body="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'},--HP171
--		body="Shab. Cuirass +1",
		hands={ name="Regal Gauntlets", priority=14},--HP205
		legs={ name="Founder's Hose", priority=14},--20 --0/0/0 0/0 --HP54
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},--HP162
		neck="Moonlight Necklace",
		waist="Audumbla sash",
        left_ear="Tuisto Earring", --HP 150
        right_ear={name="Odnowa Earring +1", priority=14},--HP110
--		left_ear="Andoaa Earring",
--		right_ear="Mimir Earring",
--        right_ear={name="Odnowa Earring +1", priority=15},
        left_ring={name="Gelatinous Ring +1", priority=14},--HP135
		right_ring={name="Moonlight Ring",bag="wardrobe5", priority=14},--HP110
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}},--HP80
		}
	--HP 1273
    
	sets.midcast.Crusade = set_combine(sets.midcast['Enhancing Magic'], {
--		neck="Moonlight Necklace",--15
		})
	--HP 1273

	sets.midcast.MAB = {
		ammo="Pemphredo Tathlum",
		head={ name="Odyssean Helm", augments={'Attack+18','"Mag.Atk.Bns."+29','Accuracy+5 Attack+5','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
		body={ name="Found. Breastplate", augments={'Accuracy+11','Mag. Acc.+10','Attack+10','"Mag.Atk.Bns."+9',}},
		hands={ name="Odyssean Gauntlets", augments={'"Mag.Atk.Bns."+29','DEX+9','Accuracy+15 Attack+15','Mag. Acc.+15 "Mag.Atk.Bns."+15',}},
		legs={ name="Odyssean Cuisses", augments={'"Mag.Atk.Bns."+29','Accuracy+24','Accuracy+17 Attack+17','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		feet={ name="Founder's Greaves", augments={'VIT+10','Accuracy+15','"Mag.Atk.Bns."+15','Mag. Evasion+15',}},
		neck="Eddy Necklace",
		waist="Orpheus's Sash",
		left_ear="Crematio Earring",
		right_ear="Friomisi Earring",
		left_ring="Metamor. Ring +1",
		right_ring="Metamor. Ring +1",
		back={ name="Rudianos's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Weapon skill damage +10%','Mag. Evasion+15',}},
		}	
	
    sets.midcast.Flash = sets.midcast.Enmity
    
    sets.midcast.Stun = sets.midcast.Flash

    sets.midcast.Enlight = sets.midcast.Divine --+95 accu
    sets.midcast['Enlight II'] = sets.midcast.Enlight--+142 accu (+2 acc each 20 divine skill)
    
--    sets.midcast.Reprisal =	set_combine(sets.midcast['Enhancing Magic'], {
--		neck="Knight's bead necklace +2",
--		waist="Creed Baudrier",
--        left_ear="Tuisto Earring", --HP 150
--        right_ear="Odnowa Earring +1", -- HP 110
--		left_ring={name="Moonlight Ring",bag="wardrobe5", priority=15},
--		right_ring={name="Moonlight Ring",bag="wardrobe5", priority=15},
--		back="Moonlight Cape", --10
--		})

    sets.midcast.Phalanx = {
		main="Sakpata's Sword", 																							--5p 0SID HP100
		sub="Priwen", 																										--2p 0SID 
		ammo="Staunch Tathlum +1", 																							--0p 11SID
		head={ name="Yorium Barbuta", priority=15}, 																		--3p 9SID  HP41
		body="Yorium Cuirass", 																								--3p 10SID HP113
		hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},--5p 0SID HP239
		legs={ name="Sakpata's Cuisses",  priority=15},																			--5p 0SID HP114
		feet={ name="Souveran Schuhs +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --5p 0SID HP1262
		neck="Unmoving Collar +1",
		waist="Audumbla Sash", 																								--0p 10SID
		left_ear="Tuisto Earring",   																						--0p 0SID
		right_ear="Odnowa Earring +1", 																						
		left_ring="Gelatinous Ring +1",
		right_ring={name="Moonlight Ring",bag="wardrobe5", priority=15},
		back="Weard Mantle",																								--5p 0SID
		} --33p 350base +8=358 30+33 63p


    sets.midcast.Holy = sets.midcast.MAB
    sets.midcast['Holy II'] = sets.midcast.Holy

-- Cure1=120; Cure2=266; Cure3=600; Cure4=1123; cure potency caps at 50/50% received caps at 32/30%. sans signet 
    sets.midcast.Cure = {
		ammo="Staunch Tathlum +1", --11 --3/0/0 0/0
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, --20 --0/0/0 0/15 HP280
		body="Souv. Cuirass +1", --10/0/0 11/15 HP171
        hands={ name="Souv. Handsch. +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15}, -- 239hp
--		hands={ name="Macabre Gauntlets +1", priority=15},--4/0/0 11/0 HP89
		legs={ name="Founder's Hose", priority=15},--20 --0/0/0 0/0 --HP54
		feet={ name="Odyssean Greaves", augments={'"Cure" potency +5%','Accuracy+15',}}, --20 --0/0/0 12/0 HP20
		neck="Moonlight Necklace", --15 --0/0/0 0/0
		waist="Audumbla Sash", --10 --0/4/0 0/0
		left_ear="Nourish. Earring +1", --0/0/0 6/0
		right_ear="Odnowa Earring +1", --0 --3/0/0 0/0
		left_ring="Gelatinous Ring +1", --5/0/0 0/0 HP135
--		right_ring="Defending Ring", --0/0/0 0/0
        right_ring={name="Moonlight Ring", bag="wardrobe5", priority=15},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Cure" potency +10%','Phys. dmg. taken-10%',}},
		}

    sets.midcast.Cure.DT = sets.midcast.Cure

-- 630 HP (curecheat)
	sets.self_healing = sets.midcast.Cure

--CureP: 47%
--CureR: 30%	
	
	sets.self_healing.DT = sets.midcast.Cure

    sets.midcast.Protect = set_combine(sets.midcast.SpellInterrupt, {
		sub="Srivatsa",
		right_ring="Sheltered Ring",
--		body="Shabti Cuirass +1",
		})
		sets.midcast.Shell = sets.midcast.Protect
		sets.midcast.Raise = sets.SID
		sets.midcast.Stun = sets.midcast.Flash

		sets.RefreshPotencyRecieved = {
		hands="Regal Gauntlets",
		feet="Shabti Sabatons +1",
		waist="Gishdubar Sash",
		}


---------- NIN Spell	--------------
	sets.midcast.Utsusemi = {
		ammo="Staunch Tathlum +1",
		head={ name="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},
		body={ name="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},
		hands="Regal Gauntlets",
		legs={ name="Founder's Hose", augments={'MND+8','Mag. Acc.+14','Attack+13','Breath dmg. taken -3%',}},
		feet={ name="Odyssean Greaves", augments={'"Cure" potency +5%','Accuracy+15',}},
		neck="Incanter's Torque",
		waist="Audumbla Sash",
		left_ear="Halasz Earring",
		right_ear="Knightly Earring",
		left_ring="Evanescence Ring",
		right_ring="Defending Ring",
		back="Solemnity Cape",
		}

	
---------- BLU Spell	--------------
    sets.midcast['Geist Wall'] = set_combine(sets.midcast.SpellInterrupt, {--+10 --111
		body="Souv. Cuirass +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, --10/0/0
  		left_ear="Tuisto Earring", --HP 150
        right_ear="Odnowa Earring +1", -- HP 110
		left_ring="Gelatinous Ring +1",
		right_ring={name="Moonlight Ring", bag="wardrobe5", priority=15}, --10/0/0/0
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}, --0/10/0
		})
	--25/21/4 +4souv

    sets.midcast['Sheep Song'] = sets.midcast['Geist Wall']

	sets.midcast['Soporific'] = sets.midcast['Geist Wall']

	sets.midcast['Stinking Gas'] = sets.midcast['Geist Wall']

    sets.midcast['Bomb Toss'] = sets.midcast['Geist Wall']

	sets.midcast['Grand Slam'] = sets.midcast['Geist Wall']

	sets.midcast['Jettatura'] = sets.midcast['Geist Wall']

	sets.midcast['Blank Gaze'] = sets.midcast['Geist Wall']
	
	sets.midcast['Cocoon'] = sets.midcast['Geist Wall']
	
	sets.midcast['Sound Blast'] = sets.midcast['Geist Wall']
	
	sets.midcast['Frightful Roar'] = sets.midcast['Geist Wall']
    
	sets.midcast.Banish = sets.midcast['Geist Wall']
	
	--+10 --111
	sets.midcast.Banishga = sets.midcast.Banish
	
    sets.midcast['Banish II'] = set_combine(sets.midcast.MAB, {right_ring="Fenian Ring"})    
    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

   sets.TreasureHunter = {
	     head="Wh. Rarab Cap +1",
	     waist="Chaac Belt",
		 ammo="Per. Lucky Egg",
	     }

    sets.Reraise = {
	    head="Twilight Helm",
		body="Twilight Mail"
		}
    
    sets.resting = {
	    neck="Creed Collar",
        ring1="Sheltered Ring",ring2="Paguroidea Ring",
        waist="Austerity Belt"
		}
    

    -- Idle sets
    sets.idle = {
		main="Burtgang",
		sub="Priwen",
		ammo="Homiliary",
		head="Sakpata's Helm",
		body="Sakpata's Breastplate",
		hands="Regal Gauntlets",
		legs="Carmine Cuisses +1",
		feet="Sakpata's Leggings",
		neck="Creed Collar",
		waist="Fucho-no-Obi",
		left_ear="Infused Earring",
		right_ear="Ethereal Earring",
        left_ring={name="Stikini Ring +1", bag="wardrobe3"},
        right_ring={name="Stikini Ring +1", bag="wardrobe1"},
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}},
		}

	sets.idle.Town = set_combine (sets.idle, {
		main="Burtgang",
		sub="Ochain",
		legs="Carmine Cuisses +1",
		})
    
    sets.idle.Weak = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Creed Collar",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Sheltered Ring",ring2="Meridian Ring",
        back="Fierabras's Mantle",waist="Flume Belt",legs="Crimson Cuisses",feet="Reverence Leggings +1"}
    
    sets.idle.Weak.Reraise = set_combine(sets.idle.Weak, sets.Reraise)
    
    sets.Kiting = set_combine( sets.defense.PDT, {
		sub="Srivatsa", --0/0/0/0
		legs="Carmine Cuisses +1", --4/0/0/0
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}},
		})

    sets.latent_refresh = {waist="Fucho-no-obi"}


    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Extra defense sets.  Apply these on top of melee or defense sets.
    sets.Knockback = {back="Repulse Mantle"}
	
    sets.MP = {
	sub="Ochain",
--	neck="Creed Collar",
    feet="Rev. Leggings +3",
    left_ear="Thureous Earring",
	waist="Flume Belt +1",
	back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Chance of successful block +5',}},
	}
    sets.MP_Knockback = {neck="Creed Collar",waist="Flume Belt",back="Repulse Mantle"}
    
    -- If EquipShield toggle is on (Win+F10 or Win+F11), equip the weapon/shield combos here
    -- when activating or changing defense mode:
    sets.PhysicalShield = {sub="Priwen"} -- Ochain
    sets.MagicalShield = {sub="Aegis"} -- Aegis

    -- Basic defense sets.
        
    sets.defense.PDT = {
	    ammo="Staunch Tathlum +1",
		main="Burtgang",
		sub="Priwen",--9/0/0/0 HP80
		head="Sakpata's Helm", --HP91
--      head="Souv. Schaller +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, --HP 280
		body="Sakpata's Breastplate",--HP136
		hands={ name="Sakpata's Gauntlets", priority=14},--HP91
		legs={ name="Sakpata's Cuisses", priority=15},--HP114
--        legs={ name="Souv. Diechlings +1", augments={'HP+105','Enmity+9','Potency of "Cure" effect received +15%'}, priority=15},--HP162
		feet={ name="Sakpata's Leggings", priority=15}, --HP68
		neck={ name="Unmoving Collar +1", priority=15},--HP200
		waist={ name="Carrier's Sash", priority=15},--HP20
		left_ear={name="Tuisto Earring", priority=15},--HP150
        right_ear={name="Odnowa Earring +1", priority=14},--HP110
		left_ring="Gelatinous Ring +1",--HP135
		right_ring={name="Moonlight Ring",bag="wardrobe5", priority=14},--110
		back={ name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}},
		} --total HP 1622
    sets.defense.HP = {ammo="Iron Gobbet",
        head="Reverence Coronet +1",neck="Twilight Torque",ear1="Creed Earring",ear2="Bloodgem Earring",
        body="Reverence Surcoat +1",hands="Reverence Gauntlets +1",ring1="Defending Ring",ring2="Meridian Ring",
        back="Weard Mantle",waist="Creed Baudrier",legs="Reverence Breeches +1",feet="Reverence Leggings +1"}
    sets.defense.Reraise = set_combine(sets.defense.PDT, {sets.Reraise})
    -- To cap MDT with Shell IV (52/256), need 76/256 in gear.
    -- Shellra V can provide 75/256, which would need another 53/256 in gear.
    sets.defense.MDT = set_combine(sets.defense.PDT, {
	    sub="Aegis",
	    })


    --------------------------------------
    -- Engaged sets
    --------------------------------------
    
     sets.engaged = { --1124 / 1264 avec enlight up
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Sanctity Necklace",
		waist="Sailfi Belt +1",
		left_ear="Cessance Earring",
		right_ear="Telos Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}

    sets.engaged.Acc = {ammo="Ginsen",
        head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Gorney Haubert +1",hands="Buremte Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Weard Mantle",waist="Zoran's Belt",legs="Cizin Breeches",feet="Whirlpool Greaves"}

	sets.engaged.DW = {
--		main="Burtgang",
--		sub="Machaera +2",
--		sub="Ceremonial Dagger",
--		sub="Ternion Dagger +1",
		ammo="Coiste Bodhar",
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
		neck="Sanctity Necklace",
--		head="Hjarrandi Helm",
--		body="Hjarrandi Breastplate",
--		hands="Flamma Manopolas +2",
--		legs="Flamma Dirs +2",
--		feet="Flamma Gambieras +2",
--		waist="Reiki Yotai",
		waist="Sailfi Belt +1",
		left_ear="Eabani Earring",
		right_ear="Telos Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring +1",
--		back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		back={ name="Rudianos's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
		}

    sets.engaged.DW.Acc = {ammo="Ginsen",
        head="Yaoyotl Helm",neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Gorney Haubert +1",hands="Buremte Gloves",ring1="Rajas Ring",ring2="K'ayres Ring",
        back="Weard Mantle",waist="Zoran's Belt",legs="Cizin Breeches",feet="Whirlpool Greaves"}

--    sets.engaged.PDT = set_combine(sets.engaged, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
	sets.engaged.PDT = sets.defense.PDT
	sets.engaged.MDT = sets.engaged.PDT
    sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.Reraise = set_combine(sets.engaged, sets.Reraise)
    sets.engaged.Acc.Reraise = set_combine(sets.engaged.Acc, sets.Reraise)

    sets.engaged.DW.PDT = set_combine(sets.engaged.DW, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.DW.Acc.PDT = set_combine(sets.engaged.DW.Acc, {body="Reverence Surcoat +1",neck="Twilight Torque",ring1="Defending Ring"})
    sets.engaged.DW.Reraise = set_combine(sets.engaged.DW, sets.Reraise)
    sets.engaged.DW.Acc.Reraise = set_combine(sets.engaged.DW.Acc, sets.Reraise)


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Doom = {ring2="Saida Ring"}
    sets.buff.Cover = sets.precast.JA['Cover']
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_midcast(spell, action, spellMap, eventArgs)
    -- If DefenseMode is active, apply that gear over midcast
    -- choices.  Precast is allowed through for fast cast on
    -- spells, but we want to return to def gear before there's
    -- time for anything to hit us.
    -- Exclude Job Abilities from this restriction, as we probably want
    -- the enhanced effect of whatever item of gear applies to them,
    -- and only one item should be swapped out.
--    if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
--        handle_equipping_gear(player.status)
--        eventArgs.handled = true
--    end
--	if state.DefenseMode.value ~= 'None' and spell.english == 'Phalanx' then
--        eventArgs.handled = true
--		equip(sets.midcast.Phalanx)
--    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(stateField, field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.ExtraDefenseMode.current)
    if state.EquipShield.value == true then
        classes.CustomDefenseGroups:append(state.DefenseMode.current .. 'Shield')
    end

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.ExtraDefenseMode.current)
	if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
	update_combat_form()
end
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_defense_mode()
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
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
    if world.area:endswith('Adoulin') then
	    idleSet = set_combine(idleSet,{body="Councilor's Garb"})
	end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
    
    return meleeSet
end

function customize_defense_set(defenseSet)
    if state.ExtraDefenseMode.value ~= 'None' then
        defenseSet = set_combine(defenseSet, sets[state.ExtraDefenseMode.value])
    end
    
    if state.EquipShield.value == true then
        defenseSet = set_combine(defenseSet, sets[state.DefenseMode.current .. 'Shield'])
    end
    
    if state.Buff.Doom then
        defenseSet = set_combine(defenseSet, sets.buff.Doom)
    end
    
    return defenseSet
end


function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end

    if state.ExtraDefenseMode.value ~= 'None' then
        msg = msg .. ', Extra: ' .. state.ExtraDefenseMode.value
    end
    
    if state.EquipShield.value == true then
        msg = msg .. ', Force Equip Shield'
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_defense_mode()
    if player.equipment.main == 'Kheshig Blade' and not classes.CustomDefenseGroups:contains('Kheshig Blade') then
        classes.CustomDefenseGroups:append('Kheshig Blade')
    end
    
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        if player.equipment.sub and not player.equipment.sub:contains('Shield') and
           player.equipment.sub ~= 'Aegis' and player.equipment.sub ~= 'Ochain' then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
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
        set_macro_page(1, 8)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 8)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 8)
    else
        set_macro_page(1, 8)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end