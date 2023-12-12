extends "res://scripts/interactable.gd"

func inspect():
	$Sprite2D/StaticBody2D/CollisionShape2D.disabled = true
	$Sprite2D.hide()
	$Button.modulate = Color(0.5, 0.5, 0.5, 1)
