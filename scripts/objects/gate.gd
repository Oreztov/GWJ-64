extends "res://scripts/interactable.gd"

func inspect():
	super()
	$AnimatedSprite2D/StaticBody2D/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("open")
	$Button.modulate = Color(0.5, 0.5, 0.5, 1)
	$sfxButton.play()
