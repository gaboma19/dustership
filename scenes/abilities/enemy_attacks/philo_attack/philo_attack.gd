extends EnemyAttack

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var damage: int = 1


func _ready():
	cooldown_timer = $CooldownTimer
	hitbox_component.damage = damage


func attack():
	animation_player.play("default")
	cooldown_timer.start()
