extends Node2D

@export var type:int = 1
@export var startHit:bool = false
@onready var animator = $AnimationPlayer
@onready var map = $'../'
@export var objectThatComesOut:PackedScene = preload("res://objects/triggers/presets/Coin.tscn")
var hit = false
@onready var startingPosition = position
func _ready():
	if startHit: hit = true
	animator.play(('idle' + str(type)) if !hit else 'empty' + str(type))

func _physics_process(delta):
	$CharacterBody2D.global_position = global_position
	if !hit:
		$CharacterBody2D.move_and_slide()
	if !hit && $CharacterBody2D.is_on_floor():
		print('owie!')
		animator.play('hit' + str(type))
		hit = true
		var object = objectThatComesOut.instantiate()
		map.add_child(object)
		object.position = position + Vector2(0,-30)
		if object.is_in_group('coinable'):
			object.block()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'hit'+str(type):
		animator.play('empty'+str(type))
