class_name WeaponData
extends Resource

@export var weapon_name: String = "Weapon"
@export var bullet_scene: PackedScene

# Munição
@export var max_ammo: int = 12

# Cadência
@export var fire_cooldown: float = 0.25
@export var automatic: bool = false

# Projétil
@export var pellets: int = 1
@export var spread: float = 0.02
@export var bullet_speed: float = 900.0
@export var bullet_range: float = 600.0
@export var damage: int = 1
@export var piercing: bool = false

# Explosão (RPG)
@export var explosive: bool = false
@export var explosion_radius: float = 0.0

# Sniper laser
@export var show_trajectory: bool = false

# Feel — recuo
@export var recoil_offset: float = 0.0       # pixels que sprite recua
@export var recoil_on_move: bool = false      # revólver: só recua se estiver se movendo
@export var move_spread_bonus: float = 0.0   # spread extra ao se mover

# Feel — screen shake
@export var shake_strength: float = 2.0
@export var shake_duration: float = 0.08
