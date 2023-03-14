--Built off of my BLU GS
---Thanks to various sources such as LS members and BlueGartr for the help building this GearSwap.
--------------------------------------------------------------------------------------------------
--This lua starts off defaulted in tanking TP gear. Press alt + F8 or the following macro to disable tanking TP mode:
---/console gs c toggle TankingTP
 
--Once that is taken off you will automatically be placed back in the TP set index. If you were previously in a set and put tanking gear back on it will resume the previous set in the index.
---Sets between 1H and 2H weapons are automatically activated after the tanking TP set is off, based on your equiped weapon. 2H weapons get the 2HTP sets and 1H the 1H set.
----This occasionally throws an error for the rule somewhere around line 1871 depending on what you edit, when you first load the lua. I have never bothered to address this bug as it doesnt impact anything.
 
--Pressing F9 (or a macro, similar to above for tanking) will toggle the currently active set. If tanking is on F9 will toggle tanking TP and ignore the other sets. If 1H TP is active F9 will toggle that and nothing else.
---If 2H TP is active then it will toggle that and AM3 for Epeo, and vice versa.
 
--Alt + F9 will cycle backwards, F9 just cycles fowards. Useful for pressing buttons once instead of 3 times to cycle one set backwards.
 
--You may cycle tanking TP with alt + f7 regardless of which TPing mode is active. This is useful for using tanking TP sets like MDT or magic evasion as DT sets while DDing with alt + f8 to equip the tanking set back on.
 
 
--Augmented Gear--
 
function get_sets()
    maps()
 
    AdhemarJacket = {}
    AdhemarJacket.TP = { name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}
    AdhemarJacket.FC = { name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}}
   
    CarmineMask = {}
    CarmineMask.MND = { name = "Carmine Mask +1", augments = { 'Accuracy+12','DEX+12','MND+20', } }
    CarmineMask.FC = { name = "Carmine Mask +1", augments = { 'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4', } }
   
    HerculeanHelm = {}
    HerculeanHelm.Nuke = { name = "Herculean Helm", augments = { 'Mag. Acc.+18 "Mag.Atk.Bns."+18', '"Fast Cast"+1', 'INT+9', 'Mag. Acc.+9', '"Mag.Atk.Bns."+12', } }
    HerculeanHelm.DT = { name = "Herculean Helm", augments = { 'Attack+12', 'Phys. dmg. taken -4%', 'STR+9', 'Accuracy+8', } }
    HerculeanHelm.Refesh = { name = "Herculean Helm", augments = { 'Weapon skill damage +2%','Pet: Accuracy+11 Pet: Rng. Acc.+11','"Refresh"+2', } }
    HerculeanHelm.WSD = { name = "Herculean Helm", augments = { 'Attack+18','Weapon skill damage +4%','STR+10','Accuracy+12', } }
    HerculeanHelm.WSDAcc = { name = "Herculean Helm", augments = { 'Accuracy+23 Attack+23','Weapon skill damage +3%','STR+3','Accuracy+13','Attack+11', } }
    HerculeanHelm.Reso =  { name="Herculean Helm", augments = {'Accuracy+27','"Triple Atk."+3','STR+3',} }
   
    TaeonHead = {}
    TaeonHead.SIR = { name="Taeon Chapeau", augments = {'Spell interruption rate down -9%',} }
   
    HerculeanVest = {}
    HerculeanVest.WSD = { name="Herculean Vest", augments = {'Accuracy+25','Weapon skill damage +4%','STR+8',}}
    HerculeanVest.Phalanx = { name="Herculean Vest", augments = {'Accuracy+2','DEX+8','Phalanx +2','Accuracy+1 Attack+1','Mag. Acc.+20 "Mag.Atk.Bns."+20',}}
   
    TaeonBody = {}
    TaeonBody.FC = { name="Taeon Tabard", augments={'Accuracy+23','"Fast Cast"+5','HP+36',} }
    TaeonBody.SIR = { name="Taeon Tabard", augments = {'Spell interruption rate down -8%','STR+7 VIT+7'} }
   
    HerculeanGloves = {}
    HerculeanGloves.WSD = { name = "Herculean Gloves", augments = { 'Accuracy+21 Attack+21', 'Weapon skill damage +4%', 'Accuracy+9', 'Attack+10', } }
    HerculeanGloves.DT = { name = "Herculean Gloves", augments = { 'Accuracy+13', 'Damage taken-3%', 'AGI+1', 'Attack+5', } }
    HerculeanGloves.HighAcc = { name = "Herculean Gloves", augments = { 'Accuracy+23 Attack+23', '"Triple Atk."+2', 'DEX+15', 'Accuracy+11', 'Attack+13', } }
    HerculeanGloves.Refresh = { name = "Herculean Gloves", augments = { 'Spell interruption rate down -1%','"Repair" potency +4%','"Refresh"+2','Accuracy+9 Attack+9','Mag. Acc.+16 "Mag.Atk.Bns."+16', } }
    HerculeanGloves.Crit = { name = "Herculean Gloves", augments = { 'Attack+23', 'Crit. hit damage +4%', 'DEX+8', 'Accuracy+11', } }
    HerculeanGloves.Reso = { name="Herculean Gloves", augments={'Accuracy+11 Attack+11','"Triple Atk."+2','STR+10','Accuracy+15','Attack+5', } }
    HerculeanGloves.Phalanx = { name="Herculean Gloves", augments={'INT+5','Pet: "Dbl. Atk."+3','Phalanx +4',}}
   
    HerculeanLegs = {}
    HerculeanLegs.DT = { name = "Herculean Trousers", augments = { 'Accuracy+22', 'Damage taken-2%', 'VIT+6', } }
    HerculeanLegs.WSD = { name = "Herculean Trousers", augments = { 'Attack+28', 'Weapon skill damage +3%', 'STR+10', 'Accuracy+9', } }
    HerculeanLegs.Magic = { name="Herculean Trousers", augments={'"Mag.Atk.Bns."+15','Weapon skill damage +4%','STR+4','Mag. Acc.+15', } }
    HerculeanLegs.Reso = { name="Herculean Trousers", augments={'Attack+21','"Triple Atk."+2','STR+6','Accuracy+13', } }
    HerculeanLegs.TH = { name = "Herculean Trousers", augments = { 'INT+5','MND+6','"Treasure Hunter"+1','Mag. Acc.+17 "Mag.Atk.Bns."+17', } }
   
   
    LustFeet = {}
    LustFeet.STRDEX = { name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}}
    LustFeet.STRDA = { name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}}
   
    HerculeanFeet = {}
    HerculeanFeet.QA = { name = "Herculean Boots", augments = { 'AGI+4', '"Dbl.Atk."+2', 'Quadruple Attack +3', 'Accuracy+4 Attack+4', } }
    HerculeanFeet.TA = { name = "Herculean Boots", augments = { 'Accuracy+14 Attack+14', '"Triple Atk."+4', 'DEX+3', 'Accuracy+2', 'Attack+15' } }
    HerculeanFeet.DT = { name = "Herculean Boots", augments = { 'Accuracy+23', 'Damage taken -3%' } }
    HerculeanFeet.Idle = { name = "Herculean Boots", augments = { 'Crit. hit damage +1%','STR+10','"Refresh"+2','Accuracy+15 Attack+15','Mag. Acc.+17 "Mag.Atk.Bns."+17', } }
    HerculeanFeet.CritDmg = { name = "Herculean Boots", augments = { 'Accuracy+28', 'Crit. hit damage +5%', 'DEX+9', } }
    HerculeanFeet.WSD = { name = "Herculean Boots", augments = { 'Attack+22', 'Weapon skill damage +4%', 'Accuracy+15', } }
    HerculeanFeet.DW = { name = "Herculean Boots", augments = { 'Accuracy+3 Attack+3','"Dual Wield"+4','AGI+3','Accuracy+14' } }
    HerculeanFeet.Phalanx = { name = "Herculean Boots", augments = { '"Store TP"+1','INT+10','Phalanx +3','Accuracy+16 Attack+16','Mag. Acc.+19 "Mag.Atk.Bns."+19' } }
    HerculeanFeet.TH = { name="Herculean Boots", augments = { 'Phys. dmg. taken -2%','Pet: Phys. dmg. taken -2%','"Treasure Hunter"+2','Accuracy+16 Attack+16','Mag. Acc.+18 "Mag.Atk.Bns."+18', } }
   
    Ogma = {}
    Ogma.TP = { name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-10%',} }
    Ogma.Tank = { name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',} }  -- 10% PDT
    Ogma.WSD = { name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',} }
    Ogma.Reso = { name="Ogma's cape", augments={ 'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10', } }
    Ogma.FC = { name = "Ogma's Cape", augments = { 'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10', } }
   
------End of Augmented Gear-----------------------------------------------------------------------------------------------------------------------------
    --Idle Sets--
    sets.Idle = {}
    sets.Idle.index = { 'DT', 'Standard', 'BuffDuration', }
    Idle_ind = 2
    sets.Idle.DT = {
        ammo = "Staunch Tathlum +1",
        head = "Fu. Bandeau +1",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Odnowa Earring +1",
        body = "Futhark Coat +3",
        hands = HerculeanGloves.Refresh,
        ring1 = "Defending ring",
        ring2 = "Shadow Ring",
        back = Ogma.Tank,
        waist = "Flume Belt +1",
        legs = "Carmine Cuisses +1",
        feet = HerculeanFeet.Idle
    }
       
    sets.Idle.Standard = {
        ammo = "Homiliary",
        head = "Turms Cap +1",
        neck = "Loricate Torque +1",
        ear2 = "Genmei Earring",
        ear1 = "Etiolation earring",
        body = "Runeist's Coat +3",
        hands = HerculeanGloves.Refresh,
        ring1 = "Sheltered ring",
        ring2 = "Karieyh Ring",
        back = Ogma.Tank,
        waist = "Flume Belt +21",
        legs = "Carmine Cuisses +1",
        feet = HerculeanFeet.Idle
    }
   
        sets.Idle.BuffDuration = set_combine(sets.Idle.Standard, {
        head = "Erilaz Galea +1",
        ring2 = "Karieyh Ring",
        legs = "Futhark Trousers +1",
    })
   
   
 
        --Dat Waifu--
    sets.Idle.Town = set_combine(sets.Idle.Standard, {
        ring1 = "Matrimony ring",
    })
 
-------TP Sets-------------------------------------------
   
    ---------------------
    --OneHanded TP Sets--
    ---------------------
   
    sets.OneHandedTP = {}
    sets.OneHandedTP.index = { 'DualWield', 'CappedHaste', 'AccuracyLite', 'AccuracyMid', 'AccuracyFull' }
    OneHandedTP_ind = 1
    --+31 needed with just Haste II
    sets.OneHandedTP.DualWield = {
        ammo = "Ginsen",
        head = "Adhemar Bonnet +1",
        neck = "Anu Torque",
        ear1 = "Suppanomimi",
        ear2= "Telos Earring",
        body = AdhemarJacket.TP,
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        ring1 = "Epona's ring",
        ring2 = "Petrov Ring",
        back = Ogma.TP,
        waist="Windbuffet Belt +1",
        legs = "Samnuha Tights",
        feet= { name="Herculean Boots", augments={'"Triple Atk."+3','STR+1','Accuracy+12','Attack+13',}}
    }
   
    sets.OneHandedTP.CappedHaste = {
        ammo = "Ginsen",
        head = "Adhemar Bonnet +1",
        neck = "Anu Torque",
        ear1 = "Suppanomimi",
        ear1 = "Suppanomimi",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Windbuffet Belt +1",
        legs = "Samnuha Tights",
        feet = HerculeanFeet.QA
    }
 
    sets.OneHandedTP.AccuracyLite = {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        neck = "Lissome Necklace",
        ear1 = "Suppanomimi",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Kentarch Belt +1",
        legs = "Samnuha Tights",
        feet = HerculeanFeet.TA
    }
 
    sets.OneHandedTP.AccuracyMid = {
        ammo = "Yamarang",
        head = "Dampening Tam",
        neck = "Combatant's Torque",
        ear1 = "Suppanomimi",
        ear2 = "Telos Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Kentarch Belt +1",
        legs = "Samnuha Tights",
        feet = HerculeanFeet.TA
    }
 
    sets.OneHandedTP.AccuracyFull = {
        ammo = "Yamarang",
        head = CarmineMask.MND,
        neck = "Combatant's Torque",
        ear1 = "Mache Earring +1",
        ear2 = "Telos Earring",
        body = AdhemarJacket.TP,
        hands = HerculeanGloves.HighAcc,
        ring1 = "Cacoethic Ring +1",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Kentarch Belt +1",
        legs = "Carmine Cuisses +1",
        feet = HerculeanFeet.CritDmg
    }
   
    ---------------------
    --TwoHanded TP Sets--
    ---------------------
   
    sets.TwoHandedTP = {}
    sets.TwoHandedTP.index = { 'CappedHaste', 'AccuracyLite', 'AccuracyMid', 'AccuracyFull' }
    TwoHandedTP_ind = 1
 
    sets.TwoHandedTP.CappedHaste = {
        ammo = "Ginsen",
        head = "Adhemar Bonnet +1",
        neck = "Anu Torque",
        ear2= "Cessance Earring",
        ear2 = "Neritic Earring",
        body = AdhemarJacket.TP,
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        ring1 = "Epona's ring",
        ring2 = "Petrov Ring",
        back = Ogma.TP,
        waist = "Windbuffet Belt +1",
        legs = "Samnuha Tights",
        feet= { name="Herculean Boots", augments={'"Triple Atk."+3','STR+1','Accuracy+12','Attack+13',}}
    }
 
    sets.TwoHandedTP.AccuracyLite = {
        ammo = "Yamarang",
        head = "Adhemar Bonnet +1",
        neck = "Lissome Necklace",
        ear1 = "Telos Earring",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Ioskeha Belt +1",
        legs = "Samnuha Tights",
        feet = HerculeanFeet.TA
    }
 
    sets.TwoHandedTP.AccuracyMid = {
        ammo = "Yamarang",
        head = "Dampening Tam",
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Ioskeha Belt +1",
        legs = "Samnuha Tights",
        feet = HerculeanFeet.TA
    }
 
    sets.TwoHandedTP.AccuracyFull = {
        ammo = "Yamarang",
        head = CarmineMask.MND,
        neck = "Combatant's Torque",
        ear1 = "Telos Earring",
        ear2 = "Mache Earring +1",
        body = AdhemarJacket.TP,
        hands = HerculeanGloves.HighAcc,
        ring1 = "Cacoethic Ring +1",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Ioskeha Belt +1",
        legs = "Carmine Cuisses +1",
        feet = HerculeanFeet.CritDmg
    }
 
    -------------------
    --EpeoAM3 TP Sets--
    -------------------
   
    sets.EpeoAM3 = {}
    sets.EpeoAM3.index = { 'CappedHaste', 'AccuracyLite', 'AccuracyMid', 'AccuracyFull' }
    EpeoAM3_ind = 1 -- In the same rule as the 2H TP Toggle so it toggles it at the same time
 
    sets.EpeoAM3.CappedHaste = set_combine(sets.TwoHandedTP.CappedHaste, {     
        body = "Ashera Harness",
        ring1 = "Petrov Ring",
        waist = "Kentarch Belt +1",
        --feet = "Carmine Greaves +1"
       
    })
 
    sets.EpeoAM3.AccuracyLite = set_combine(sets.TwoHandedTP.AccuracyLite, {       
        body = "Ashera Harness",
        ring1 = "Petrov Ring",
        waist = "Kentarch Belt +1",
        --feet = "Carmine Greaves +1"
    })
 
    sets.EpeoAM3.AccuracyMid = set_combine(sets.TwoHandedTP.AccuracyMid, {     
        body = "Ashera Harness",
        ring1 = "Petrov Ring",
        waist = "Kentarch Belt +1"
    })
 
    sets.EpeoAM3.AccuracyFull = set_combine(sets.TwoHandedTP.AccuracyFull, {       
        body = "Ashera Harness",
        ear2 = "Dignitary's Earring",
        waist = "Kentarch Belt +1"
    })
   
    -------------------
    --Tanking TP Sets--
    -------------------
   
    sets.TankingTP = {}
    sets.TankingTP.index = { 'Tank', 'TankHyb', 'DDHyb', 'DDHybAcc'}
    TankingTP_ind = 1
   
    sets.TankingTP.Tank = {
        ammo = "Staunch Tathlum +1",
        head = "Fu. Bandeau +1",
        neck = "Loricate Torque +1",
        ear1 = "Hearty Earring",
        ear2 = "Odnowa Earring +1",
        body = "Erilaz Surcoat +1",
        hands={ name="Herculean Gloves", augments={'Rng.Acc.+16','Damage taken-4%','Accuracy+12','Attack+6',}},
        ring1 = "Defending ring",
        ring2 = "Warden's Ring",
        back = Ogma.Tank,
     --   waist = "Engraved Belt",
         waist = "Flume Belt +1",
        legs = "Erilaz Leg Guards +1",
        feet = "Erilaz Greaves +1"
    }
    --Capped DT with DD Gear
    sets.TankingTP.TankHyb = {
        ammo = "Staunch Tathlum +1",
        head = "Meghanada Visor +2",
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Sherida Earring",
        body = "Ashera Harness",
        hands = HerculeanGloves.HighAcc,
        ring1 = "Defending ring",
        ring2 = "Gelatinous Ring +1",
        back = Ogma.TP,
        waist = "Ioskeha Belt +1",
        legs = "Meg. Chausses +2",
        feet = HerculeanFeet.DT
    }
    --Low DT with DD Gear
    sets.TankingTP.DDHyb = {
        ammo = "Yamarang",
        head = "Dampening Tam",
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Sherida Earring",
        body = "Ashera Harness",
        hands = "Adhemar Wristbands +1",
        ring1 = "Defending ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Ioskeha Belt +1",
        legs = "Meg. Chausses +2",
        feet = HerculeanFeet.TA
    }
    --Mid DT with Acc
    sets.TankingTP.DDHybAcc = {
        ammo = "Yamarang",
        head = CarmineMask.MND,
        neck = "Loricate Torque +1",
        ear1 = "Telos Earring",
        ear2 = "Mache Earring +1",
        body = "Ashera Harness",
        hands = HerculeanGloves.HighAcc,
        ring1 = "Defending ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.TP,
        waist = "Ioskeha Belt +1",
        legs = "Carmine Cuisses +1",
        feet = HerculeanFeet.DT
    }
------End of TP--------------------------------------------------------------------------------------------------------------------
    --WS Sets--
    sets.WS = {}
   
    sets.Requiescat = {}
 
    sets.Requiescat.index = { 'Attack', 'Accuracy' }
    Requiescat_ind = 1
 
    sets.Requiescat.Attack = {
        ammo = "Hydrocera",
        head = "Carmine Mask",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        ring1 = "Epona's ring",
        ring2 = "Regal Ring",
        back = Ogma.Reso,
        waist = "Fotia Belt",
        legs = "Meg. Chausses +2",
        feet = "Carmine Greaves +1"
    }
 
    sets.Requiescat.Accuracy = {
        ammo = "Yamarang",
        head = "Carmine Mask",
        neck = "Fotia Gorget",
        ear1 = "Cessance Earring",
        ear2 = "Telos Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's ring",
        ring2 = "Regal Ring",
        back = " ",
        waist = "Fotia Belt",
        legs = "Telchine Braconi",
        feet = "Carmine Greaves +1"
    }
 
    sets.Resolution = {}
 
    sets.Resolution.index = { 'AttackUncapped', 'AttackCapped', 'Accuracy' }
    Resolution_ind = 1
 
    sets.Resolution.AttackUncapped = {
        ammo = "Knobkierrie",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Sherida Earring",
        body="Adhemar Jacket +1",
        hands= { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        ring1 = "Shukuyu Ring",
        ring2 = "Epona's Ring",
        back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}},
        waist = "Fotia Belt",
        legs = "Meg. Chausses +2",
        feet={ name="Herculean Boots", augments={'Accuracy+30','"Triple Atk."+4','STR+3','Attack+2',}},
    }
 
    sets.Resolution.AttackCapped = {
        ammo = "Knobkierrie",
        head = "Lustratio Cap +1",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Sherida Earring",
        body = "Lustratio Harness +1",
        hands = "Adhemar Wristbands +1",
        ring1 = "Epona's Ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.Reso,
        waist = "Fotia Belt",
        legs = "Samnuha Tights",
        feet = LustFeet.STRDEX
    }
   
    sets.Resolution.Accuracy = {
        ammo = "Seething Bomblet +1",
        head = HerculeanHelm.Reso,
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands = "Adhemar Wristbands +1",
        ring1 = "Regal Ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.Reso,
        waist = "Fotia Belt",
        legs = "Meg. Chausses +2",
        feet = HerculeanFeet.TA
    }
 
    sets.SanguineBlade = {
        ammo = "Pemphredo Tathlum",
        head = "Pixie Hairpin +1",
        neck = "Sanctity Necklace",
        ear1 = "Friomisi Earring",
        ear2 = "Hecate's Earring",
        body = "Samnuha Coat",
        hands = "Leyline Gloves",
        ring1 = "Archon Ring",
        ring2 = "Shiva Ring +1",
        back = "Evasionist's Cape",
        waist = "Eschan Stone",
        legs = "",
        feet = HerculeanFeet.DT
    }
   
    sets.Dimidiation = {}
 
    sets.Dimidiation.index = { 'AttackUncapped', 'AttackCapped', 'Accuracy' }
    Dimidiation_ind = 1
 
    sets.Dimidiation.AttackUncapped = {
        ammo="Knobkierrie",
        head="Adhemar Bonnet +1",
        neck="Fotia Gorget",
        ear1="Moonshade earring",
        ear2="Sherida Earring",
        body=AdhemarJacket.TP,
        hands="Meg. Gloves +2",
        ring2="Epona's Ring",
        ring1="Ilabrat Ring",
        back=Ogma.WSD,
        waist="Fotia Belt",
        legs="Samnuha Tights",
        feet= { name="Herculean Boots", augments={'Accuracy+29','Weapon skill damage +4%','DEX+2','Attack+14',}}
    }
                   
    sets.Dimidiation.AttackCapped = {
        ammo="Knobkierrie",
        head="Lustratio Cap +1",
        neck="Fotia Gorget",
        ear1="Moonshade earring",
        ear2="Sherida Earring",
        body=AdhemarJacket.TP,
        hands="Meg. Gloves +2",
        ring2="Niqmaddu Ring",
        ring1="Epona's Ring",
        back=Ogma.WSD,
        waist="Fotia Belt",
        legs="Lustratio Subligar +1",
        feet=LustFeet.STRDEX
    }                          
                               
    sets.Dimidiation.Accuracy = {
        ammo="Seething Bomblet +1",
        head=HerculeanHelm.WSDAcc,
        neck="Fotia Gorget",
        ear1="Moonshade earring",
        ear2="Mache Earring +1",
        body=AdhemarJacket.TP,
        hands="Meg. Gloves +2",
        ring2="Niqmaddu Ring",
        ring1="Ilabrat Ring",
        back=Ogma.WSD,
        waist="Grunfeld Rope",
        legs="Meg. Chausses +2",
        feet=HerculeanFeet.TA
    }
 
    sets.SavageBlade = {}
 
    sets.SavageBlade.index = { 'Attack', 'Accuracy' }
    SavageBlade_ind = 1
    sets.SavageBlade.Attack = {
        ammo = "Knobkierrie",
        head = { name="Herculean Helm", augments={'Weapon skill damage +4%','AGI+2','Attack+12',}},
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Ishvara Earring",
        body = HerculeanVest.WSD,
        hands = "Meg. Gloves +2",
        ring1 = "Karieyh Ring",
        ring2 = "Rufescent Ring",
        back = Ogma.WSD,
        waist = "Prosilio Belt +1",
        legs = { name="Herculean Trousers", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','Weapon skill damage +3%','MND+2','Mag. Acc.+11','"Mag.Atk.Bns."+2',}},
        feet = { name="Herculean Boots", augments={'Accuracy+29','Weapon skill damage +4%','DEX+2','Attack+14',}}
    }
 
    sets.SavageBlade.Accuracy = {
        ammo = "Seething Bomblet +1",
        head = HerculeanHelm.WSD,
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Telos Earring",
        body = AdhemarJacket.TP,
        hands = "Meg. Gloves +2",
        ring2 = "Karieyh Ring +1",
        ring1 = "Regal Ring",
        back = Ogma.WSD,
        waist = "Prosilio Belt +1",
        legs = HerculeanLegs.WSD,
        feet = HerculeanFeet.WSD
    }
   
        sets.FlashNova = {
        ammo = "Pemphredo Tathlum",
        head = HerculeanHelm.Nuke,
        neck = "Sanctity Necklace",
        ear1 = "Friomisi Earring",
        ear2 = "Hecate's Earring",
        body = "Samnuha Coat",
        hands = "Leyline Gloves",
        ring1 = "Shiva Ring +1",
        ring2 = "Shiva Ring +1",
        back = "Evasionist's Cape",
        waist = "Eschan Stone",
        legs = "",
        feet = HerculeanFeet.DT
    }
   
    sets.BlackHalo = {}
 
    sets.BlackHalo.index = { 'Attack', 'Accuracy' }
    BlackHalo_ind = 1
    sets.BlackHalo.Attack = {
        ammo = "Knobkierrie",
        head = HerculeanHelm.WSD,
        neck = "Caro Necklace",
        ear1 = "Moonshade Earring",
        ear2 = "Sherida Earring",
        body = HerculeanVest.WSD,
        hands = "Meg. Gloves +2",
        ring1 = "Regal Ring",
        ring2 = "Niqmaddu Ring",
        back = Ogma.WSD,
        waist = "Prosilio Belt +1",
        legs = HerculeanLegs.WSD,
        feet = HerculeanFeet.WSD
    }
 
    sets.BlackHalo.Accuracy = set_combine(sets.BlackHalo.Attack, {})
   
    sets.Realmrazer = {}
 
    sets.Realmrazer.index = { 'Attack', 'Accuracy' }
    Realmrazer_ind = 1
    sets.Realmrazer.Attack = {
        ammo = "Hydrocera",
        head = "Carmine Mask",
        neck = "Fotia Gorget",
        ear1 = "Moonshade Earring",
        ear2 = "Sherida Earring",
        body = AdhemarJacket.TP,
        hands = HerculeanGloves.WSD,
        ring1 = "Epona's ring",
        ring2 = "Rufescent Ring",
        back = "Cornflower Cape",
        waist = "Fotia Belt",
        legs = "Telchine Braconi",
        feet = "Carmine Greaves +1"
    }
 
    sets.Realmrazer.Accuracy = set_combine(sets.Realmrazer.Attack, {})
------End of WS------------------------------------------------------------------------------------------
------Magic Sets---
    sets.BlueMagic = {}
 
    sets.BlueMagic.STR = set_combine(sets.Resolution.Attack, {
    })
 
    --Curing Sets--
    sets.Cures = {
        ammo = "Hydrocera",
        head = "Carmine Mask",
        neck = "Phalaina Locket",
        ear1 = "Mendicant's Earring",
        ear2 = "Magnetic Earring",
        body = "Vrikodara Jupon",
        hands = "Rawhide Gloves",
        ring1 = "Stikini Ring",
        ring2 = "Rufescent Ring",
        back = "Solemnity Cape",
        waist = "Luminary Sash",
        legs = "Carmine Cuisses +1",
        feet = "Skaoi Boots"
    }
   
    sets.Cures.SelfCures = set_combine(sets.Cures, {
        ring1 = "Kunaji Ring",
        waist = "Gishdubar Sash",
    })
    --Spell Interruption Rate--
    sets.SIR = {
        ammo="Staunch Tathlum +1",
        head= TaeonHead.SIR,
        neck="Moonbeam Necklace",
        ear1="Magnetic Earring",
        ear2="Cryptic Earring",
        body= TaeonBody.SIR,
        hands="Rawhide Gloves",
        ring1="Defending Ring",
        ring2="Evanescence Ring",
        back="Moonbeam Cape",
        waist="Rumination Sash",
        legs="Carmine Cuisses +1",
        feet = "Taeon Boots"
    }
------End of Magic-------------------------------------------------------------------------------------
    --Enmity Set--
   
    sets.Enmity = {
        ammo = "Sapience Orb",
        head = "Halitus Helm",
        neck = "Unmoving Collar +1",
        ear1 = "Friomisi Earring",
        ear2 = "Cryptic Earring",
        body = "Emet Harness +1",
        hands = "Kurys Gloves",
        ring1 = "Supershear Ring",
        ring2 = "Pernicious Ring",
        back = Ogma.Tank,
        waist = "Kasiri Belt",
        legs = "Erilaz Leg Guards +1",
        feet = "Ahosi Leggings"
    }
   
    --Utility Sets--
   
    sets.Utility = {}
 
    sets.Utility.TH = {
        waist = "Chaac Belt",
        legs = HerculeanLegs.TH,
        feet = HerculeanFeet.TH,
		head = "Wh. Rarab Cap +1"
    }
   
    sets.Utility.Derp = {
        ammo = "Staunch Tathlum +1",
        head = "Turms Cap +1",
        neck = "Warder's Charm +1",
        ear1 = "Genmei Earring",
        ear2 = "Hearty Earring",
        body = "Ashera Harness",
        hands = "Turms Mittens +1",
        ring1 = "Defending ring",
        ring2 = "Gelatinous Ring +1",
        back = Ogma.Tank,
        waist = "Engraved Belt",
        legs = "Erilaz Leg Guards +1",
        feet = "Erilaz Greaves +1"
    }
   
    sets.Utility.MDTTank =  {
        ammo = "Staunch Tathlum +1",
        head = "Erilaz Galea +1",
        neck = "Warder's Charm +1",
        ear1 = "Etiolation Earring",
        ear2 = "Odnowa Earring +1",
        body = "Runeist's Coat +3",
        hands = HerculeanGloves.DT,
        ring1 = "Defending ring",
        ring2 = "Shadow Ring",
        back = Ogma.Tank,
        waist = "Engraved Belt",
        legs = "Erilaz Leg Guards +1",
        feet = "Erilaz Greaves +1"
    }
   
    --Shell V on. Need 23% when 5/5 with pants, 21% with sheltered (24% with sheltered and trust/self cast)--
    sets.Utility.MDTV = {
        ammo = "Floestone",
        head = "Amalric Coif",
        neck = "Warder's Charm +1",
        ear1 = "Eabani Earring",
        ear2 = "Etiolation Earring",
        body = "Amalric Doublet",
        hands = HerculeanGloves.DT,
        ring1 = "Defending ring",
        ring2 = "Shadow Ring",
        back = "Mubvumbamiri Mantle",
        waist = "Carrier's Sash",
        legs = "Amalric Slops",
        feet = "Hashishin Basmak +1"
    }
 
    --Shell II only--
    sets.Utility.MDTII = {
        ammo = "Floestone",
        head = "Dampening Tam",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Odnowa Earring +1",
        body = "Amalric Doublet",
        hands = HerculeanGloves.DT,
        ring1 = "Defending ring",
        ring2 = "Dark ring",
        back = "Engulfer Cape +1",
        waist = "Carrier's Sash",
        legs = HerculeanLegs.DT,
        feet = HerculeanFeet.DT
    }
 
    --No Shell--
    sets.Utility.MDTNO = {
        ammo = "Floestone",
        head = "Dampening Tam",
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Odnowa Earring +1",
        body = "Amalric Doublet",
        hands = HerculeanGloves.DT,
        ring1 = "Defending ring",
        ring2 = "Dark ring",
        back = "Engulfer Cape +1",
        waist = "Carrier's Sash",
        legs = HerculeanLegs.DT,
        feet = HerculeanFeet.DT
    }
 
    --Telchine with proper ball busting augments is the best for magic evasion--
    sets.Utility.MEVA = {
        ammo = "Floestone",
        head = "Amalric Coif",
        neck = "Loricate Torque +1",
        ear1 = "Eabani Earring",
        ear2 = "Hearty Earring",
        body = "Amalric Doublet",
        hands = "Leyline Gloves",
        ring1 = "Shiva Ring +1",
        ring2 = "Purity Ring",
        back = "Mubvumbamiri Mantle",
        waist = "Carrier's Sash",
        legs = "Amalric Slops",
        feet = "Ahosi Leggings"
    }
 
    ---------------------------------------------------------------
   
    sets.Utility.Charm = {
        ammo = "Staunch Tathlum +1",
        head = "Meghanada Visor +2",
        neck = "Unmoving Collar +1",
        ear1 = "Genmei Earring",
        ear2 = "Hearty Earring",
        body = "Ashera Harness", --Just for the Orc Ambuscade
        --body = "Runeist's Coat +3",
        hands = "Erilaz Gauntlets +1",
        ring1 = "Defending Ring",
        ring2 = "Wuji Ring",
        back = "Solemnity Cape",
        waist = "Flume Belt",
        legs = "Runeist's Trousers +3",
        feet = "Erilaz Greaves +1"
    }
   
    sets.Utility.Doom = {
        ring1 = "Purity Ring",
        ring2 = "Saida Ring",
        waist = "Gishdubar Sash"
    }
   
    --Enhancing Sets--
   
    sets.Enhancing = {}
   
    sets.Enhancing.Skill = {
        ammo = "Sapience Orb",
        head = CarmineMask.MND,
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Loquacious Earring",
        body = "Manasa Chasuble",
        hands = "Runeist's Mitons +2",
        ring1 = "Defending Ring",
        ring2 = "Stikini Ring",
        back = "Moonbeam Cape",
        waist = "Flume Belt",
        legs = "Carmine Cuisses +1",
        feet = "Erilaz Greaves +1"
    }
   
    sets.Enhancing.Duration = {
        ammo = "Sapience Orb",
        head = "Erilaz Galea +1",
        neck = "Incanter's Torque",
        ear1 = "Andoaa Earring",
        ear2 = "Loquacious Earring",
        body = "Futhark Coat +3",
        hands = "Runeist's Mitons +2",
        ring1 = "Defending Ring",
        ring2 = "Stikini Ring",
        back = "Moonbeam Cape",
        waist = "Flume Belt",
        legs = "Futhark Trousers +1",
        feet = "Erilaz Greaves +1"
    }
   
    sets.Enhancing.Phalanx = set_combine(sets.Enhancing.Duration, {
        head = "Futhark Bandeau +2",
        body = HerculeanVest.Phalanx,
        hands = HerculeanGloves.Phalanx,
        feet = HerculeanFeet.Phalanx
    })
   
    sets.Enhancing.Refresh = set_combine(sets.Enhancing.Duration, {
        waist = "Gishdubar Sash",
    })
   
    sets.Enhancing.Regen = set_combine(sets.Enhancing.Duration, {
        head = "Runeist's Bandeau +3",
    })
   
    sets.Enhancing.ProShell = set_combine(sets.Enhancing.Duration, {
        Ring2 = "Sheltered Ring",
    })
   
    sets.Enhancing.Foil = set_combine(sets.Enmity, {
        head = "Erilaz Galea +1",
        legs = "Futhark Trousers +1"
    })
   
    --Job Ability Sets--
 
    sets.JA = {}
   
    sets.JA.Lunge = {
        ammo = "Pemphredo Tathlum",
        head = HerculeanHelm.Nuke,
        neck = "Baetyl Pendant",
        ear1 = "Friomisi Earring",
        ear2 = "Hecate's Earring",
        body = "Samnuha Coat",
        hands = "Leyline Gloves",
        ring1 = "Shiva Ring +1",
        ring2 = "Shiva Ring +1",
        back = "Evasionist's Cape",
        waist = "Eschan Stone",
        legs = HerculeanLegs.Magic,
        feet = "Adhemar Gamashes +1"
    }
 
    sets.JA.Sforzo = set_combine(sets.Enmity, {
        body = "Futhark Coat +3"
    })
 
    sets.JA.Swordplay = set_combine(sets.Enmity, {
        hands = "Futhark Mitons +1"
    })
   
    sets.JA.Vallation = set_combine(sets.Enmity, {
        body = "Runeist's Coat +3",
        legs = "Futhark Trousers +1",
        back = "Ogma's Cape"
    })
   
    sets.JA.Pflug = set_combine(sets.Enmity, {
        feet = "Runeist's Boots +2"
    })
   
    sets.JA.Valiance = set_combine(sets.Enmity, {
        body = "Runeist's Coat +3",
        legs = "Futhark Trousers +1",
        back = Ogma.Tank
    })
   
    sets.JA.Embolden = set_combine(sets.Enmity, {
    })
   
    sets.JA.Pulse = set_combine(sets.Enmity, {
        head = "Erilaz Galea +1",
        neck = "Incanter's Torque",
        ring2 = "Stikini Ring",
        legs = "Runeist's Trousers +3"
    })
   
    sets.JA.Gambit = set_combine(sets.Enmity, {
        hands = "Runeist's Mitons +2"
    })
   
    sets.JA.Battuta = set_combine(sets.Enmity, {
        head =  "Futhark Bandeau +1"
    })
   
    sets.JA.Rayke = set_combine(sets.Enmity, {
        feet = "Futhark Boots +1"
    })
   
    sets.JA.Liement = set_combine(sets.Enmity, {
        body = "Futhark Coat +3"
    })
    --One For All is HP * .2 = Magic Damage Reduction--
    sets.JA.One = set_combine(sets.Enmity, {
        ammo = "Falcon Eye",
        head = "Halitus Helm",
        neck = "Sanctity Necklace",
        ear1 = "Etiolation Earring",
        ear2 = "Odnowa Earring +1",
        body = "Runeist's Coat +3",
        hands = "Runeist's Mitons +2",
        ring1 = "Regal Ring",
        ring2 = "Ilabrat Ring",
        back = "Moonbeam Cape",
        waist = "Kasiri Belt",
        legs = "Erilaz Leg Guards +1",
        Feet = "Carmine Greaves +1"
    })
   
    sets.JA.Subterfuge = set_combine(sets.Enmity, {})
   
    ---SAM---
    sets.JA.Meditate = set_combine(sets.Enmity, {})
   
    ---WAR---
    sets.JA.Provoke = set_combine(sets.Enmity, {})
 
    sets.JA.Warcry = set_combine(sets.Enmity, {})
   
    --Precast Sets--
    sets.precast = {}
 
    sets.precast.FastCast = {}
 
    sets.precast.FastCast.Standard = {
        ammo = "Sapience Orb",
        head = "Runeist's Bandeau +3",
        neck = "Orunmila's Torque",
        ear1 = "Etiolation Earring",
        ear2 = "Loquac. Earring",
        body = AdhemarJacket.FC,
        hands = "Leyline Gloves",
        ring1 = "Kishar Ring",
        ring2 = "Rahab Ring",
        back = Ogma.FC,
        waist = "Kasiri Belt",
        legs = "Ayanmo Cosciales +2",
        feet = "Carmine Greaves +1"
    }
   
    sets.precast.FastCast.Enhancing = set_combine(sets.precast.FastCast.Standard, {
        legs = "Futhark Trousers +1",
        ring2 = "Defending Ring"
    })
end
 
---End of Gear---------------------------------------------------------------------------------------------------------------------------------------------------------
 
-------------------------------------
---------                   ---------
------                         ------
---         Start of Maps         ---
------                         ------
---------                   ---------
-------------------------------------
 
-------------------------
--   BLU Spells List   --
-------------------------
 
TwoHandedWeapons = S {
    'Aettir', 'Epeolatry', 'Lionheart', 'Beheader +1', 'Takoba', 'Zulqifar', 'Bidenhander',
    'Montante', 'Montante +1', 'Humility', 'Nibiru Faussar', 'Macbain', 'Soulcleaver',
    'Kaqulijaan', 'Beorc Sword', 'Trial Blade', 'Sword of Trials', 'Irradiance Blade',
    'Greatsword', 'Parashu'
}
 
-------------------------
--   BLU Spells List   --
-------------------------
 
function maps()
    PhysicalSpells = S {
        'Bludgeon', 'Body Slam', 'Feather Storm', 'Mandibular Bite', 'Queasyshroom',
        'Power Attack', 'Screwdriver', 'Sickle Slash', 'Smite of Rage',
        'Terror Touch', 'Battle Dance', 'Claw Cyclone', 'Foot Kick', 'Grand Slam',
        'Sprout Smack', 'Helldive', 'Jet Stream', 'Pinecone Bomb', 'Wild Oats', 'Uppercut'
    }
   
    BlueMagic_Buffs = S {
        'Refueling',
    }
 
    BlueMagic_Healing = S {
        'Healing Breeze', 'Pollen', 'Wild Carrot'
    }
 
    BlueMagic_Enmity = S {
        'Blank Gaze', 'Jettatura', 'Geist Wall', 'Sheep Song', 'Soporific', 'Cocoon', 'Stinking Gas'
    }
   
    RUNMagic_Enmity = S {
        'Flash', 'Stun'
    }
end
 
------------------------
--   Town Gear List   --
------------------------
 
Town = S {
    "Ru'Lude Gardens", "Upper Jeuno", "Lower Jeuno", "Port Jeuno",
    "Port Windurst", "Windurst Waters", "Windurst Woods", "Windurst Walls", "Heavens Tower",
    "Port San d'Oria", "Northern San d'Oria", "Southern San d'Oria", "Chateau d'Oraguille",
    "Port Bastok", "Bastok Markets", "Bastok Mines", "Metalworks",
    "Aht Urhgan Whitegate", "Nashmau",
    "Selbina", "Mhaura", "Norg",  "Kazham", "Tavanazian Safehold",
    "Eastern Adoulin", "Western Adoulin", "Celennia Memorial Library", "Mog Garden"
}
 
---End of Maps----------------------------------------------------------------------------------------------------------------------------------------------------------
 
function msg(str)
    send_command('@input /echo <----- ' .. str .. ' ----->')
end
 
------------------------------------------
-- Macro and Style Change on Job Change
------------------------------------------
function set_macros(sheet,book)
    if book then
        send_command('@input /macro book '..tostring(book)..';wait .1;input /macro set '..tostring(sheet))
        return
    end
    send_command('@input /macro set '..tostring(sheet))
end
 
function set_style(sheet)
    send_command('@input ;wait 5.0;input /lockstyleset '..sheet)
    add_to_chat (21, 'Your lockstyle looks like shit, and you should feel bad')
    add_to_chat (55, 'You are on '..('RUN '):color(5)..''..('btw. '):color(55)..''..('Macros set!'):color(121))
--  add_to_chat (60, 'Eat tendies in moderation')
end
 
--Page, Book--
set_macros(1,10)
--Use the Lockstyle Number--
set_style(98)
------------------------------------------
-- Variables
------------------------------------------
SetLocked = false --Used to Check if set is locked before changing equipment
LockedEquipSet = {} --Placeholder to store desired lock set
LockGearSet = {}
equipSet = {} --Currently Equiped Gearset
LockGearIndex = false
LockGearIndex = false
TargetDistance = 0
TH = false -- Defaults
SIR = false -- Spell Interruption Rate
TankingTP = true -- If true, default set is tanking TP array.
TwoHandedTP = true -- TP set order, looks for Tanking TP set before 2H TP before 1H DW TP.
------------------------------------------
-- Windower Hooks              --
------------------------------------------
 
function buff_change(n, gain, buff_table)
    local name
    name = string.lower(n)
    if S{"terror","petrification","sleep","stun"}:contains(name) then
        if gain then
            ChangeGear(sets.Utility.Derp)
        elseif not has_any_buff_of({"terror","petrification","sleep","stun"}) then
            if player.status == 'Engaged' then
                if LockGearIndex then
                    ChangeGear(LockGearSet)
                elseif not LockGearIndex then
                    if TankingTP == true then
                        ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
                    elseif EpeoAM3 == true then
                        ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
                    elseif TwoHandedTP == true then
                        ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
                    else
                        ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[OneHandedTP_ind]])
                    end
                end
            elseif player.status == 'Idle' then
                if LockGearIndex then
                    ChangeGear(LockGearSet)
                elseif not LockGearIndex then
                    ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
                end
            end
        end
    elseif name == "doom" then
        if gain then
            ChangeGear(sets.Utility.Doom)
            send_command('@input /p Doomed {~o~:} !')
            disable('ring1','ring2','waist')
        else
            if player.status == 'Engaged' then
                if LockGearIndex then
                    send_command('@input /p Doom is off {^_^}')
                    enable('ring1','ring2','waist')
                    ChangeGear(LockGearSet)
                else
                    send_command('@input /p Doom is off {^_^}')
                    enable('ring1','ring2','waist')
                    if TankingTP == true then
                        ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
                    elseif EpeoAM3 == true then
                        ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
                    elseif TwoHandedTP == true then
                        ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
                    else
                        ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[OneHandedTP_ind]])
                    end
                end
            elseif player.status == 'Idle' then
                if LockGearIndex then
                    send_command('@input /p Doom is off {^_^}')
                    enable('ring1','ring2','waist')
                    ChangeGear(LockGearSet)
                else
                    send_command('@input /p Doom is off {^_^}')
                    enable('ring1','ring2','waist')
                    ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
                end
            end
        end
    elseif name == "charm" then
        if gain then
            send_command('@input /p Charmed {<3_<3:} !')
        else
            send_command('@input /p Charm is off {~_^}')
        end
    elseif name == "weakness" then
        if gain then
            enable('ring1','ring2','waist')
        end
    elseif name ==  "embolden" then
        if gain then
        ChangeGear(set_combine(equipSet, {back="Evasionist's Cape"}))
        else
            if player.status == 'Engaged' then
                if LockGearIndex then
                    ChangeGear(LockGearSet)
                elseif not LockGearIndex then
                    if TankingTP == true then
                        ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
                    elseif EpeoAM3 == true then
                        ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
                    elseif TwoHandedTP == true then
                        ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
                    else
                        ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[OneHandedTP_ind]])
                    end
                end
            elseif player.status == 'Idle' then
                if LockGearIndex then
                    ChangeGear(LockGearSet)
                elseif not LockGearIndex then
                    ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
                end
            end
        end
    elseif name == "hasso" then
        if gain then
        do return end
    else
        send_command('gs c -cd Hasso Lost!')
        end
    end
   
    if name == "aftermath: lv.3" and player.equipment.main == 'Epeolatry' then -- Mythic AM3
        if gain then
            EpeoAM3 = true
            send_command('timers create "Mythic AM3" 180 down')
             if LockGearIndex then
                ChangeGear(LockGearSet)
            elseif TankingTP == true then
                ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
            else
                ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
            end
        else
            EpeoAM3 = false
            send_command('timers delete "Mythic AM3";gs c -cd AM3 Lost!!!')
        end
    end
end
 
------------------------------------------
--               Binds                  --
------------------------------------------
send_command('bind f9 gs c toggle TP set') --This means if you hit f9 it toggles the sets
send_command('bind f10 gs c toggle GS WS set') --Changes Reso and Dimidiation sets
send_command('bind f11 gs c ') --Empty
send_command('bind f12 gs c toggle Idle set')
send_command('bind ^f8 gs c toggle SIR') -- Turns Spell Interruption Rate set on
send_command('bind ^f9 input /ws "Resolution" <t>') --^ means cntrl
send_command('bind ^f10 input /ws "Dimidiation" <t>')
send_command('bind ^f11 input /ws "Ground Strike" <t>')
send_command('bind ^f12 input /ws "Savage Blade" <t>')
send_command('bind !f7 gs c toggle TankingTP set') --! means alt, this exists only for toggling outside of this mode being active, otherwise f9
send_command('bind !f8 gs c toggle TankingTP') --! turns tanking tp off
send_command('bind !f9 gs c toggle backwards')
send_command('bind !f10 gs c toggle Other WS set') -- Changes affiliated sword ws sets
send_command('bind !f11 ') --Empty
send_command('bind !f12 gs c lockgearindex')
 
send_command('bind !e input /item "Echo Drops" <me>')
send_command('bind !r input /item "Remedy" <me>')
send_command('bind !p input /item "Panacea" <me>')
send_command('bind !h input /item "Holy Water" <me>')
send_command('bind !w input /equip ring2 "Warp Ring"; /echo Warping; wait 11; input /item "Warp Ring" <me>;')
send_command('bind !q input /equip ring2 "Dim. Ring (Holla)"; /echo Reisenjima; wait 11; input /item "Dim. Ring (Holla)" <me>;')
send_command('bind !t gs c toggle TH') -- alt + t toggles TH mode
 
--Unload Binds
function file_unload()
    send_command('unbind ^f9')
    send_command('unbind ^f10')
    send_command('unbind ^f11')
    send_command('unbind ^f12')
    send_command('unbind !f9')
    send_command('unbind !f10')
    send_command('unbind !f11')
    send_command('unbind !f12')
    send_command('unbind f9')
    send_command('unbind f10')
    send_command('unbind f11')
    send_command('unbind f12')
   
    send_command('unbind !e')
    send_command('unbind !r')
    send_command('unbind !p')
    send_command('unbind !h')
    send_command('unbind !w')
    send_command('unbind !q')
    send_command('unbind !t')
end
 
------------------------------------------
-- Console Commands             --
------------------------------------------
function self_command(command)
    if command == 'togglelock' then
        if SetLocked == false then
            msg("Equipment Set LOCKED!")
        else
            SetLocked = false
            msg("Equipment Set UNLOCKED!")
        end
    elseif command == 'lockgearindex' then
        if LockGearIndex == false then
            LockGearIndex = true
            LockGearSet = {
                ammo = player.equipment.ammo,
                head = player.equipment.head,
                neck = player.equipment.neck,
                ear1 = player.equipment.left_ear,
                ear2 = player.equipment.right_ear,
                body = player.equipment.body,
                hands = player.equipment.hands,
                ring1 = player.equipment.left_ring,
                ring2 = player.equipment.right_ring,
                back = player.equipment.back,
                waist = player.equipment.waist,
                legs = player.equipment.legs,
                feet = player.equipment.feet
            }
            msg("Gear Index Locked")
        else
            LockGearIndex = false
            msg("Gear Index Unlocked")
            if player.status == 'Engaged' then
                if TankingTP == true then
                    ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
                elseif EpeoAM3 == true then
                        ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
                elseif TwoHandedTP == true then
                    ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
                else
                    ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[OneHandedTP_ind]])
                end
            else
                ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
            end
        end
    end
    if command == 'toggle TP set' then
        if TankingTP == true then
            TankingTP_ind = TankingTP_ind + 1
            if TankingTP_ind > #sets.TankingTP.index then TankingTP_ind = 1 end
            send_command('@input /echo <----- TankingTP Set changed to ' .. sets.TankingTP.index[TankingTP_ind] .. ' ----->')
            if player.status == 'Engaged' then
                ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
            end
        elseif TankingTP == false then
            if TwoHandedTP == true then
                TwoHandedTP_ind = TwoHandedTP_ind + 1
                EpeoAM3_ind = EpeoAM3_ind +1
                if TwoHandedTP_ind > #sets.TwoHandedTP.index then TwoHandedTP_ind = 1 end
                if EpeoAM3_ind > #sets.EpeoAM3.index then EpeoAM3_ind = 1 end
                send_command('@input /echo <----- 2H TP Set changed to ' .. sets.TwoHandedTP.index[TwoHandedTP_ind] .. ' ----->')  
                if player.status == 'Engaged' then
                    if EpeoAM3 == true then
                        ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
                    else
                        ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
                    end
                end
            elseif TwoHandedTP == false then
                OneHandedTP_ind = OneHandedTP_ind + 1
                if OneHandedTP_ind > #sets.OneHandedTP.index then OneHandedTP_ind = 1 end
                send_command('@input /echo <----- 1H TP Set changed to ' .. sets.OneHandedTP.index[OneHandedTP_ind] .. ' ----->')
                if player.status == 'Engaged' then
                    ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[OneHandedTP_ind]])
                end
            end    
        end
    elseif command == 'toggle Idle set' then
        Idle_ind = Idle_ind + 1
        if Idle_ind > #sets.Idle.index then Idle_ind = 1 end
        send_command('@input /echo <----- Idle Set changed to ' .. sets.Idle.index[Idle_ind] .. ' ----->')
        ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
    elseif command == 'toggle GS WS set' then
        Resolution_ind = Resolution_ind + 1
        Dimidiation_ind = Dimidiation_ind + 1
        if Resolution_ind > #sets.Resolution.index then Resolution_ind = 1 end
        if Dimidiation_ind > #sets.Dimidiation.index then Dimidiation_ind = 1 end
        send_command('@input /echo <----- Reso/Dimi Sets changed to ' .. sets.Resolution.index[Resolution_ind] .. ' ----->')
    elseif command == 'toggle Other WS set' then
        SavageBlade_ind = SavageBlade_ind + 1
        Requiescat_ind = Requiescat_ind + 1
        BlackHalo_ind = BlackHalo_ind + 1
        Realmrazer_ind = Realmrazer_ind + 1
        if SavageBlade_ind > #sets.SavageBlade.index then SavageBlade_ind = 1 end
        if Requiescat_ind > #sets.Requiescat.index then Requiescat_ind = 1 end
        if BlackHalo_ind > #sets.BlackHalo.index then BlackHalo_ind = 1 end
        if Realmrazer_ind > #sets.Realmrazer.index then Realmrazer_ind = 1 end
        send_command('@input /echo <----- Sword/Club WS Set changed to ' .. sets.SavageBlade.index[SavageBlade_ind] .. ' ----->')
    elseif command == 'toggle TankingTP set' then
        TankingTP_ind = TankingTP_ind + 1
        if TankingTP_ind > #sets.TankingTP.index then TankingTP_ind = 1 end
        send_command('@input /echo <----- TankingTP Set changed to ' .. sets.TankingTP.index[TankingTP_ind] .. ' ----->')
        if player.status == 'Engaged' then
            ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
        end
    elseif command == 'toggle TankingTP' then
        if TankingTP == true then
            TankingTP = false
            send_command('@input /echo <----- Tanking TP: [Off] ----->')
        else
            TankingTP = true
            send_command('@input /echo <----- Tanking TP: [On] ----->')
        end
        status_change(player.status)
    elseif command == 'toggle TwoHandedTP' then
        if TwoHandedTP == true then
            TwoHandedTP = false
            send_command('@input /echo <----- 2H TP: [Off] ----->')
        else
            TwoHandedTP = true
            send_command('@input /echo <----- 2H TP: [On] ----->')
        end
        status_change(player.status)
    elseif command == 'toggle SIR' then
        if SIR == true then
            SIR = false
            send_command('@input /echo <----- Spell Interruption Rate: [Off] ----->')
        else
            SIR = true
            send_command('@input /echo <----- Spell Interruption Rate: [On] ----->')
        end
        status_change(player.status)
    elseif command == 'toggle TH' then
        if TH == true then
            TH = false
            send_command('@input /echo <----- Treasure Hunter TP: [Off] ----->')
        else
            TH = true
            send_command('@input /echo <----- Treasure Hunter TP: [On] ----->')
        end
        status_change(player.status)
    elseif command == 'toggle backwards' then
        if TankingTP == true then
            TankingTP_ind = TankingTP_ind -1
            if TankingTP_ind == 0 then
                TankingTP_ind = #sets.TankingTP.index
            end
            send_command('@input /echo <----- TankingTP Set changed to ' .. sets.TankingTP.index[TankingTP_ind] .. ' ----->')
            if player.status == 'Engaged' then
                ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
            end
        elseif TankingTP == false then
            if TwoHandedTP == true then
                TwoHandedTP_ind = TwoHandedTP_ind -1
                EpeoAM3_ind = EpeoAM3_ind -1
                if TwoHandedTP_ind == 0 then
                    TwoHandedTP_ind = #sets.TwoHandedTP.index
                end
                if EpeoAM3_ind == 0 then
                    EpeoAM3_ind = #sets.EpeoAM3.index
                end
                send_command('@input /echo <----- 2H TP Set changed to ' .. sets.TwoHandedTP.index[TwoHandedTP_ind] .. ' ----->')  
                if player.status == 'Engaged' then
                    if EpeoAM3 == true then
                        ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])
                    else
                        ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
                    end
                end
            elseif TwoHandedTP == false then
                OneHandedTP_ind = OneHandedTP_ind -1
                if OneHandedTP_ind == 0 then
                    OneHandedTP_ind = #sets.OneHandedTP.index
                end
                if player.status == 'Engaged' then
                    ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[TP_ind]])
                end
            end
        end
    elseif command == 'ZoneChange' then
        IdleState()
    elseif string.sub(command, 0, 4) == '-cd ' then     --If the first 4 characters of the command are '-cd '
        add_to_chat (30, string.sub(command, 5, string.len(command)))      --add everything after '-cd ' to a message in the chat
    end
end
 
------------------------------------------
-- Character States                     --
------------------------------------------
function IdleState()
    if LockGearIndex then
        ChangeGear(LockGearSet)
    elseif not LockGearIndex then
        ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
    end
   
    if player.mpp <= 50 and Idle_ind == 2 then --standard idle
        ChangeGear({head = HerculeanHelm.Refesh, waist = "Fucho-no-obi"})
    elseif player.mpp <= 50 and Idle_ind == 3 then -- buff duration
        ChangeGear({waist = "Fucho-no-obi"})
    end
       
    if Town:contains(world.area) and player.mpp < 75 then
        ChangeGear(set_combine(sets.Idle.Town, sets.Idle.Refresh))
        elseif Town:contains(world.area) then
        ChangeGear(sets.Idle.Town)
    end
   
    if buffactive['Embolden'] then
        ChangeGear(set_combine(equipSet, {back="Evasionist's Cape"}))
    end
   
end
 
windower.raw_register_event('zone change',function()
windower.send_command('@wait 9; input //gs c ZoneChange')
end)
 
function RestingState()
 
end
 
function EngagedState()
    if LockGearIndex then
        ChangeGear(LockGearSet)
    elseif not LockGearIndex then
        if TankingTP == true then
            ChangeGear(sets.TankingTP[sets.TankingTP.index[TankingTP_ind]])
        elseif buffactive["Aftermath: Lv.3"] and player.equipment.main == 'Epeolatry' then --am3
            EpeoAM3 = true
            ChangeGear(sets.EpeoAM3[sets.EpeoAM3.index[EpeoAM3_ind]])  
        elseif TwoHandedTP == true then
            EpeoAM3 = false
            ChangeGear(sets.TwoHandedTP[sets.TwoHandedTP.index[TwoHandedTP_ind]])
        else
            EpeoAM3 = false
            ChangeGear(sets.OneHandedTP[sets.OneHandedTP.index[OneHandedTP_ind]])
        end
    end
end
 
-----------------------------
--      Spell control      --
-----------------------------
unusable_buff = {
    spell={'Charm','Mute','Omerta','Petrification','Silence','Sleep','Stun','Terror'},
    ability={'Amnesia','Charm','Impairment','Petrification','Sleep','Stun','Terror'}}
  --check_recast('ability',spell.recast_id)  check_recast('spell',spell.recast_id)
function check_recast(typ,id) --if spell can be cast(not in recast) return true
    local recasts = windower.ffxi['get_'..typ..'_recasts']()
    if id and recasts[id] and recasts[id] == 0 then
        return true
    else
        return false
    end
end
 --return true if spell/ability is unable to be used at this time
function spell_control(spell)
    if spell.type == "Item" then
        return false
    --Stops spell if you do not have a target
    elseif spell.target.name == nil and not spell.target.raw:contains("st") then
        return true
    --Stops spell if a blocking buff is active
    elseif spell.action_type == 'Ability' and spell.type ~= 'WeaponSkill' and (has_any_buff_of(unusable_buff.ability) or not check_recast('ability',spell.recast_id)) then
        return true
    elseif spell.type == 'WeaponSkill' and player.tp < 1000 then
        return true
    elseif spell.type == 'WeaponSkill' and (has_any_buff_of(unusable_buff.ability)) then
        msg("Weapon Skill Canceled, Can't")
        return true
    elseif spell.action_type == 'Magic' and (has_any_buff_of(unusable_buff.spell)
      or not check_recast('spell',spell.recast_id)) then
        return true
    --Stops spell if you do not have enuf mp/tp to use
    elseif spell.mp_cost and spell.mp_cost > player.mp and not has_any_buff_of({'Manawell','Manafont'}) and not spell.action_type == 'Ability' then
        msg("Spell Canceled, Not Enough MP")
        return true
    end
    --Calculate how many finishing moves your char has up to 6
    local fm_count = 0
    for i, v in pairs(buffactive) do
        if tostring(i):startswith('finishing move') or tostring(i):startswith('?????????') then
            fm_count = tonumber(string.match(i, '%d+')) or 1
        end
    end
    --Stops flourishes if you do not have enough finishing moves
    local min_fm_for_flourishes = {['Animated Flourish']=1,['Desperate Flourish']=1,['Violent Flourish']=1,['Reverse Flourish']=1,['Building Flourish']=1,
                                   ['Wild Flourish']=2,['Climactic Flourish']=1,['Striking Flourish']=2,['Ternary Flourish']=3,}
    if min_fm_for_flourishes[spell.en] then
        if min_fm_for_flourishes[spell.en] > fm_count and not buffactive[507] then
            return true
        end
    end
    --Reomves Sneak when casting Spectral Jig
    if spell.en == 'Spectral Jig' then
        send_command('cancel 71')
    end
    if spell.name == 'Utsusemi: Ichi' and overwrite and buffactive['Copy Image (3)'] then
        return true
    end
    if player.tp >= 1000 and player.target and player.target.distance and player.target.distance > 7 and spell.type == 'WeaponSkill' then
        msg("Weapon Skill Canceled  Target Out of Range")
        return true
    end
end
 
------------------------------------------
--              Precast                 --
------------------------------------------
function has_any_buff_of(buff_set)--returns true if you have any of the buffs given
    for i,v in pairs(buff_set) do
        if buffactive[v] ~= nil then return true end
    end
end
--JA Sets--
function pc_JA(spell, act)
    if spell.english == 'Elemental Sforzo' then
        ChangeGear(sets.JA.Sforzo)
    elseif spell.english == 'Swordplay' then
        ChangeGear(sets.JA.Swordplay)
    elseif spell.english == 'Vallation' or spell.english == 'Valiance' then
        ChangeGear(sets.JA.Vallation)
    elseif spell.english == 'Pflug' then
        ChangeGear(sets.JA.Pflug)
    elseif spell.english == 'Embolden' then
        ChangeGear(sets.JA.Embolden)
    elseif spell.english == 'Vivacious Pulse' then
        ChangeGear(sets.JA.Pulse)
    elseif spell.english == 'Gambit' then
        ChangeGear(sets.JA.Gambit)
    elseif spell.english == 'Battuta' then
        ChangeGear(sets.JA.Battuta)
    elseif spell.english == 'Rayke' then
        ChangeGear(sets.JA.Rayke)
    elseif spell.english == 'Liement' then
        ChangeGear(sets.JA.Liement)
    elseif spell.english == 'One For All' then
        ChangeGear(sets.JA.One)
    elseif spell.english == 'Odyllic Subterfuge' then
        ChangeGear(sets.JA.Subterfuge)
    elseif spell.english == 'Lunge' or spell.english == 'Swipe' then
        ChangeGear(sets.JA.Lunge)
    elseif spell.english == 'Meditate' then
        ChangeGear(sets.JA.Meditate)
    elseif spell.english == 'Provoke' then
        ChangeGear(sets.JA.Provoke)
    elseif spell.english == 'Warcry' then
        ChangeGear(sets.JA.Warcry)
    end
   
    --These spells can't override each other, and must be canceled--
    if spell.name == 'Valiance' or spell.name == 'Vallation' or spell.name == 'Liement' then
        if buffactive['Valiance'] then
            cast_delay(0.2)
            windower.ffxi.cancel_buff(535)
        elseif buffactive['Vallation'] then
            cast_delay(0.2)
            windower.ffxi.cancel_buff(531)
        elseif buffactive['Liement'] then
            cast_delay(0.2)
            windower.ffxi.cancel_buff(537)
        end
    end
 
    IgnoreWS = S { "Sanguine Blade", "Red Lotus Blade", "Flash Nova", "Realmrazer" }  -- Excluded from Moonshade TP override rule.
    BrutalWS = S { "Resolution"}
    STRWS = S {"Vorpal Blade", "Fell Cleave", "Circle Blade", "Swift Blade", "Shockwave" } -- Just uses the Resolution Set
   
   
    if spell.type == 'WeaponSkill' then
        if spell.english == 'Requiescat' then
            ChangeGear(sets.Requiescat[sets.Requiescat.index[Requiescat_ind]])
        elseif spell.english == 'Dimidiation' or spell.english == 'Ground Strike' then
            ChangeGear(sets.Dimidiation[sets.Dimidiation.index[Dimidiation_ind]])
        elseif spell.english == 'Resolution' or STRWS:contains(spell.english) then
            ChangeGear(sets.Resolution[sets.Resolution.index[Resolution_ind]])
        elseif spell.english == 'Savage Blade' then
            ChangeGear(sets.SavageBlade[sets.SavageBlade.index[SavageBlade_ind]])
        elseif spell.english == 'Realmrazer' then
            ChangeGear(sets.Realmrazer[sets.Realmrazer.index[Realmrazer_ind]])
        elseif spell.english == 'Black Halo' or 'Judgement' then
            ChangeGear(sets.BlackHalo[sets.BlackHalo.index[BlackHalo_ind]])
        elseif spell.english == 'Flash Nova' or spell.english == 'Red Lotus Blade' then
            ChangeGear(sets.FlashNova)
        elseif spell.english == 'Sanguine Blade' then
            ChangeGear(sets.SanguineBlade)
        end
        if player.tp > 2025 and player.equipment.main == 'Lionheart' and buffactive['TP Bonus'] then
            if IgnoreWS:contains(spell.english) then
                do return end
            elseif BrutalWS:contains(spell.english) then
                equip(set_combine(equipSet, { ear1 = "Brutal Earring" })) --Watch for ear conflicts between TP sets and WS sets
                msg("Brutal Earring equiped !!!!")
            else
                equip(set_combine(equipSet, { ear1 = "Ishvara Earring" }))
                msg("Ishvara Earring equiped !!!!")
            end
        elseif player.tp > 2275 and player.equipment.main == 'Lionheart' then
            if IgnoreWS:contains(spell.english) then
                do return end
            elseif BrutalWS:contains(spell.english) then
                equip(set_combine(equipSet, { ear1 = "Brutal Earring" })) --Watch for ear conflicts between TP sets and WS sets
                msg("Brutal Earring equiped !!!!")
            else
                equip(set_combine(equipSet, { ear1 = "Ishvara Earring" }))
                msg("Ishvara Earring equiped !!!!")
            end
        elseif player.tp > 2550 and buffactive['TP Bonus'] then
            if IgnoreWS:contains(spell.english) then
                do return end
            elseif BrutalWS:contains(spell.english) then
                equip(set_combine(equipSet, { ear1 = "Brutal Earring" })) --Watch for ear conflicts between TP sets and WS sets
                msg("Brutal Earring equiped !!!!")
            else
                equip(set_combine(equipSet, { ear1 = "Ishvara Earring" }))
                msg("Ishvara Earring equiped !!!!")
            end
        elseif player.tp > 2775 then
            if IgnoreWS:contains(spell.english) then
                do return end
            elseif BrutalWS:contains(spell.english) then
                equip(set_combine(equipSet, { ear1 = "Brutal Earring" })) --Watch for ear conflicts between TP sets and WS sets
                msg("Brutal Earring equiped !!!!")
            else
                equip(set_combine(equipSet, { ear1 = "Ishvara Earring" }))
                msg("Ishvara Earring equiped !!!!")
            end
        end
    end
 
    if string.find(spell.english,'Step') then
        ChangeGear(set_combine(sets.TwoHandedTP.AccuracyFull, sets.Utility.TH))
    elseif spell.english == 'Animated Flourish' then
        ChangeGear(sets.Enmity)
    end
end
 
function pc_Magic(spell, act)
    if spell.skill == 'Enhancing Magic' then
        ChangeGear(sets.precast.FastCast.Enhancing)
    else
        ChangeGear(sets.precast.FastCast.Standard)
     end
end
 
function pc_Item(spell, act)
end
 
 
------------------------------------------
-- Midcast                 --
------------------------------------------
function mc_JA(spell, act)
end
 
function mc_Magic(spell, act)
    if spell.skill == 'Enhancing Magic' then
        if buffactive['Embolden'] then
            if spell.english == 'Phalanx' then
                ChangeGear(set_combine(sets.Enhancing.Phalanx, {back="Evasionist's Cape"}))
            elseif string.find(spell.english,'Shell') or string.find(spell.english,'Protect') then
                ChangeGear(set_combine(sets.Enhancing.ProShell, {back="Evasionist's Cape"}))
            else
                ChangeGear(set_combine(sets.Enhancing.Duration, {back="Evasionist's Cape"}))
            end
        elseif spell.english == 'Aquaveil' then
            ChangeGear(sets.SIR)
        elseif spell.english == 'Refresh' then
            ChangeGear(sets.Enhancing.Refresh)
        elseif string.find(spell.english,'Regen')then
            ChangeGear(sets.Enhancing.Regen)
        elseif string.find(spell.english,'Bar') or spell.english=="Temper" then
            ChangeGear(sets.Enhancing.Skill)
        elseif spell.english == 'Phalanx' then
            ChangeGear(sets.Enhancing.Phalanx)
        elseif spell.english == 'Foil' then
            ChangeGear(sets.Enhancing.Foil)
        elseif string.find(spell.english,'Shell') or string.find(spell.english,'Protect') then
            ChangeGear(sets.Enhancing.ProShell)
        else
            ChangeGear(sets.Enhancing.Duration)
        end
    elseif spell.skill == 'Healing Magic' then
        if spell.target and spell.target.type == 'SELF' then
            ChangeGear(sets.Cures.SelfCures)
        else
            ChangeGear(sets.Cures)
        end
    elseif spell.skill == 'Enfeebling Magic' then
        if spell.english == 'Sleepga' or spell.english == 'Poisonga' and TH == true then --For tanking/pulling Divergence to TH tag everything
            ChangeGear(set_combine(sets.Enmity, sets.Utility.TH))
        end
    end
 
    if BlueMagic_Enmity:contains(spell.english) then
        ChangeGear(sets.Enmity)
    elseif BlueMagic_Buffs:contains(spell.english) then
        ChangeGear(sets.TankingTP.Tank)
    elseif PhysicalSpells:contains(spell.english) then
        ChangeGear(sets.BlueMagic.STR)
    elseif BlueMagic_Healing:contains(spell.english) then
        if spell.target and spell.target.type == 'SELF' then
            ChangeGear(sets.Cures.SelfCures)
        else
            ChangeGear(sets.Cures)
        end
    elseif RUNMagic_Enmity:contains(spell.english) then
        ChangeGear(sets.Enmity)
    end
   
    if buffactive['Tenebrae'] and spell.english == 'Lunge' or spell.english == 'Swipe' then
        equip(sets.JA.Lunge,{head="Pixie Hairpin +1"})
    end
   
end
 
function mc_Item(spell, act)
end
 
 
------------------------------------------
-- After Cast               --
------------------------------------------
function ac_JA(spell)
end
 
function ac_Magic(spell)
end
 
function ac_Item(spell)
end
 
function ac_Global()
    if LockGearIndex == true then
        ChangeGear(LockGearSet)
        msg("Lock Gear is ON -- Swapping Gear")
    else
        if player.status == 'Engaged' then
            EngagedState()
        else
            IdleState()
        end
    end
end
 
------------------------------------------
-- Framework Core            --
------------------------------------------
function status_change(new, old)
    if new == 'Idle' then
        IdleState()
    elseif new == 'Resting' then
        RestingState()
    elseif new == 'Engaged' then
        EngagedState()
    end
   
    if player.status == 'Engaged' and TH == true then
        ChangeGear(set_combine(equipSet, sets.Utility.TH))         
    end
   
    if S{1,4,6,7,8,10,12}:contains(gearswap.res.items:with('en', player.equipment.main).skill) then --Checks mainhand weapon for TP set choice. See below for notes on #s
        TwoHandedTP = true 
    else
        TwoHandedTP = false
    end
   
end
 
--Numbers in the 1H 2H TP mode rule:
--1 = Hand-to-Hand
--2 = Dagger
--3 = Sword
--4 = Great Sword
--5 = Axe
--6 = Great Axe
--7 = Scythe
--8 = Polearm
--9 = Katana
--10 = Great Katana
--11 = Club
--12 = Staff
 
 
function precast(spell, act)
    if spell_control(spell) then
        cancel_spell()
        return
    end
    if spell.action_type == 'Ability' then
        pc_JA(spell, act)
    elseif spell.action_type == 'Magic' then
        pc_Magic(spell, act)
    else
        pc_Item(spell, act)
    end
end
 
function midcast(spell, act)
    IgnoreSIRSpell = S { "Phalanx", "Temper", "Refresh", "Regen"}  -- Excluded from Spell Interruption Rate override rule.
    if spell.action_type == 'Ability' then
        mc_JA(spell, act)
    elseif spell.action_type == 'Magic' then
        if SIR == true then
            if IgnoreSIRSpell:contains(spell.english) and not string.find(spell.english,'Bar') then
                mc_Magic(spell, act)
            else
                ChangeGear(sets.SIR)
            end
        else
            mc_Magic(spell, act)
        end
    else
        mc_Item(spell, act)
    end
end
 
function aftercast(spell, act)
    if spell.action_type == 'Ability' then
        ac_JA(spell)
    elseif spell.action_type == 'Magic' then
        ac_Magic(spell)
    else
        ac_Item(spell)
    end
    ac_Global()
   
    --Countdowns--
    if not spell.interrupted then
        if spell.english == "Meditate" then
            send_command('wait 170;gs c -cd '..spell.name..': [Ready In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Ready !]')
        elseif spell.english == "Sekkanoki" then
            send_command('wait 290;gs c -cd '..spell.name..': [Ready In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Ready !]')
        elseif spell.english == "Swordplay" then
            send_command('wait 290;gs c -cd '..spell.name..': [Ready In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Ready !]')
        elseif spell.english == "One for All" then
            send_command('wait 290;gs c -cd '..spell.name..': [Ready In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Ready !]')
        elseif spell.english == "Battuta" then
            send_command('wait 290;gs c -cd '..spell.name..': [Ready In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Ready !]')
        elseif spell.english == "Liement" then
            send_command('wait 170;gs c -cd '..spell.name..': [Ready In 10 Seconds!];wait 10;gs c -cd '..spell.name..': [Ready !]')
        end
    end
   
    if S{4,6,7,8,10,12}:contains(gearswap.res.items:with('en', player.equipment.main).skill) then --Checks mainhand weapon for TP set choice. See bottom for notes on #s
        TwoHandedTP = true
    else
        TwoHandedTP = false
    end
   
end
   
   
function ChangeGear(GearSet)
    equipSet = GearSet
    equip(GearSet)
end
 
function LockGearSet(GearSet)
    LockedEquipSet = GearSet
    equip(GearSet)
    SetLocked = true
end
 
function UnlockGearSet()
    locked = false
    equip(equipSet)
end