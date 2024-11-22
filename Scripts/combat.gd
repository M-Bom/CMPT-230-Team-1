extends Node

const Battle_Units = preload("res://Resources/Battle_Units.tres")

## Get instance from game
#Buttons
@onready var battle_action_buttons = $UI/BattleActionButtons
@onready var power_up_button = $UI/BattleActionButtons/Power_Up_Button
@onready var companion_button = $UI/BattleActionButtons/Companion_Button

@onready var player_animations = $Player/Player_Animations
@onready var message_state = $Message
@onready var end_turn_message = $"UI/End Turn Message"

# Music
@onready var battle_music = $BattleMusic


func _ready():
	visible_buttons()
	battle_music.play()
	message_state.hide()
	start_player_turn()

func visible_buttons():
	if Global.found_companion == false:
		companion_button.hide()
		
	if Global.found_power_up == false:
		power_up_button.hide()
		

func start_enemy_turn():
	battle_action_buttons.hide() #Hide combat buttons
	var enemy = Battle_Units.Enemy
	if enemy != null and not(Global.dead): #Check if enemy exists
		enemy.choose_move() #Run attack function
		await(enemy.end_turn)
	start_player_turn()


func start_player_turn():
	battle_action_buttons.show() #Show combat buttons
	var player_states = Battle_Units.PlayerState
	if not(player_states.is_dead()):
		player_states.ap = player_states.max_ap #Reset Action points
		await(player_states.end_turn) #Wait until action point equal zero
		start_enemy_turn()

#When enemy dies
func _on_enemy_died(): #Win function
	battle_action_buttons.hide()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_player_states_died():
	battle_action_buttons.hide()
	get_tree().change_scene_to_file("res://Scenes/LoadingScreens/LoadGame.tscn")


# Easy Debug Exit
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func _on_enemy_def_bulk():
	end_turn_message.show()
	await(get_tree().create_timer(0.4).timeout)
	end_turn_message.hide()
	pass # Replace with function body.
