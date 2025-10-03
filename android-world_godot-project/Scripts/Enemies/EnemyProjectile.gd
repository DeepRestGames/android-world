extends RigidBody2D


var player: Player
@export var PROJECTILE_SPEED: float = 500
var direction: Vector2

var projectile_reach = 1000


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	direction = to_local(player.global_position).normalized()
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	var movement_vector = direction * PROJECTILE_SPEED * delta
	var collision = move_and_collide(movement_vector)
	
	if collision != null:
		call_deferred("queue_free")
	
	projectile_reach -= movement_vector.length()
	if projectile_reach <= 0:
		queue_free()
