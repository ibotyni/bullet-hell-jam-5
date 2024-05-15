extends Node

#	Common		green
#	Uncommon	blue
#	Rare		purple
#	Epic		red
#	Legendary	golden

@export var weapon_db = {
	Enums.WeaponNames.PLASMA_PULSE: { "name": "Plasma Pulse", "rarity pct": 80, "rarity": "Common", "res": "pulse", "colour": "ffd700", "base rate": 1.0, "level rate": 0.1, "damage":1, "price":500 },
	Enums.WeaponNames.NEUTRINO_SHOT: {"name": "Neutrino Shot", "rarity pct": 80, "rarity": "Common", "res": "shot", "colour": "d7d7ff", "base rate": 0.5, "level rate": 0.05, "damage":2, "price":1600},
	Enums.WeaponNames.VULKAN_CANNON: {"name": "Vulkan Cannon", "rarity pct": 60, "rarity": "Uncommon", "res": "shot", "colour": "ffd700", "base rate": 0.1, "level rate": 0.005, "damage":1, "price":1000 },
	Enums.WeaponNames.DRAXIAN_PULSE: {"name": "Draxian Pulse", "rarity pct": 50, "rarity": "Uncommon", "res": "pulse", "colour": "00d730", "base rate": 0.75, "level rate": 0.075, "damage":1, "price":900 },
	Enums.WeaponNames.THRAGUL_MINES: {"name": "Thra'gul Mines", "rarity pct": 40, "rarity": "Rare", "res": "mines", "colour": "ff0000", "base rate": 5.0, "level rate": 0.5, "damage":10, "price":200 },
	Enums.WeaponNames.MEGA_BLAST: {"name": "Mega Blast", "rarity pct": 30, "rarity": "Rare", "res": "blast", "colour": "ffd700", "base rate": 1, "level rate": 0.075, "damage":4, "price":1000 },
	Enums.WeaponNames.CHRONON_BLAST: {"name": "Chronon Blast", "rarity pct": 20, "rarity": "Epic", "res": "blast", "colour": "ffd7ff", "base rate": 0.2, "level rate": 0.025, "damage":5, "price":2000 },
	Enums.WeaponNames.ION_DISRUPTOR: {"name": "Ion Disruptor", "rarity pct": 10, "rarity": "Epic", "res": "ion", "colour": "ffd7ff", "base rate": 0.2, "level rate": 0.025, "damage":5, "price":2000 },
	Enums.WeaponNames.ZORTHIAN_LASER: {"name": "Zorthian Laser", "rarity pct": 2, "rarity": "Legendary", "res": "laser", "colour": "ffff50", "base rate": 0.05, "level rate": 0.005, "damage":8, "price":5000 }
}
