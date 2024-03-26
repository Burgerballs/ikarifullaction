extends Node2D

@export var type:int = 1
@export var startHit:bool = false
@onready var animator = $AnimationPlayer
@onready var map = $'../'

var hit = false
@onready var startingPosition = position
func _ready():
	if startHit: hit = true
	animator.play(str(type))

func _physics_process(delta):
	if !hit:
		$CharacterBody2D.move_and_slide()
	if !hit && $CharacterBody2D.is_on_floor():
		print('owie!')
		hit = true
		queue_free()
		Globals.blockey(position)
		queue_free()
		
	$CharacterBody2D.global_position = global_position

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'hit'+str(type):
		animator.play('empty'+str(type))
