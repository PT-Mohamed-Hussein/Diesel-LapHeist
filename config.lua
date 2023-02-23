Config = {}

Config.MaxInventoryWeight = 120000 -- Max weight a player can carry (default 120kg, written in grams)

Config.C4PlantingObject = -686494084

Config.C4BombItem = 'c4_bomb'

Config.RequiredPoliceCount = 0

Config.LaptopHack = 'hackinglaptop'

Config.CoolDown = 60 --one hour 

Config.MiddleStageReward = {
	name = 'uranium',
	count = 4
}

Config.LastStageItems = {
	name = 'nuclearcode',
	count = 4
}

Config.CodesPrice = 10000

Config.TakeAdminPrevillage = {
	sourceped = {
		pos = vector4(-50.48, -1851.37, 25.2, 28.23),
		model = `ig_mp_agent14`
	},
	destinationped = vector3(2118.39, 1727.05, 101.92),		
}

Config.StartHeistPed = {
	pos = vector4(3455.25, 3747.34, 29.65, 78.56),
	model = `s_m_y_airworker`
}

Config.C4Zones = {
	[1] = {
		pos = vector3(3437.85, 3751.03, 30.51),
		heading = 300,
		length = 3.8,
		width = 1.6,
		minz = 28.11,
		maxz = 32.11,
		name = '1stc4zone',
		plant = false,
	},
	[2] = {
		pos = vector3(3452.9, 3712.3, 31.6),
		heading = 260,
		length = 3.8,
		width = 1.6,
		minz = 28.11,
		maxz = 32.11,
		name = '2ndc4zone',
		plant = false,
	},
	[3] = {
		pos = vector3(3450.1, 3646.56, 42.6),
		heading = 260,
		length = 3.8,
		width = 1.6,
		minz = 40.02,
		maxz = 44.2,
		name = '3rdc4zone',
		plant = false,
	},
	[4] = {
		pos = vector3(3476.62, 3661.3, 41.34),
		heading = 260,
		length = 3.8,
		width = 1.6,
		minz = 38.94,
		maxz = 42.94,
		name = '4thc4zone',
		plant = false,
	},
	[5] = {
		pos = vector3(3527.49, 3651.38, 41.34),
		heading = 260,
		length = 3.8,
		width = 1.6,
		minz = 38.94,
		maxz = 42.94,
		name = '5thc4zone',
		plant = false,
	},
	[6] = {
		pos = vector3(3583.71, 3648.1, 33.89),
		heading = 350,
		length = 3.8,
		width = 1.6,
		minz = 31.49,
		maxz = 35.49,
		name = '6thc4zone',
		plant = false,
	},
	[7] = {
		pos = vector3(3590.27, 3694.76, 36.64),
		heading = 260,
		length = 3.8,
		width = 1.6,
		minz = 34.24,
		maxz = 38.24,
		name = '7thc4zone',
		plant = false,
	},
	[8] = {
		pos = vector3(3620.85, 3724.25, 35.16),
		heading = 235,
		length = 3.8,
		width = 1.6,
		minz = 33.36,
		maxz = 37.36,
		name = '8thc4zone',
		plant = false,
	},
}

Config.LaptopAnimation = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s',
        'hei_prop_hst_laptop',
        'hei_prop_heist_card_hack_02'
    },
    ['animations'] = {
        {'hack_enter', 'hack_enter_bag', 'hack_enter_laptop', 'hack_enter_card'},
        {'hack_loop', 'hack_loop_bag', 'hack_loop_laptop', 'hack_loop_card'},
        {'hack_exit', 'hack_exit_bag', 'hack_exit_laptop', 'hack_exit_card'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}

Config.Planting = {
    ['objects'] = {
        'hei_p_m_bag_var22_arm_s'
    },
    ['animations'] = {
        {'thermal_charge', 'bag_thermal_charge'}
    },
    ['scenes'] = {},
    ['sceneObjects'] = {}
}

Config.MiddleStageItem = {
    ['objects'] = {
        'prop_cs_vial_01',
        'p_chem_vial_02b_s',
    },
    ['animations'] = {
        {'take_chemical_player0', 'take_chemical_tube', 'take_chemical_vial'}
    },
    ['scenes'] = {

    },
    ['sceneObjects'] = {

    }
}
