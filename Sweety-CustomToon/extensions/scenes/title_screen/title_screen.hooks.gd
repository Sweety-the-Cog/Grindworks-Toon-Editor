extends Node

# Yes this is all rather jank isn't it? My apologizes.

const ToonEditor : PackedScene = preload("res://mods-unpacked/Sweety-CustomToon/Resources/Scenes/toon_editor.tscn")
const CUSTOMIZE_BUTTON = preload("res://mods-unpacked/Sweety-CustomToon/Resources/Scenes/Editor Buttons/Customize_button.tscn")
var CustomizeButton
var Editor

func toon_clicked(chain: ModLoaderHookChain, toon: Toon, character: PlayerCharacter) -> void:
	chain.execute_next([toon,character])
	var self_ref = chain.reference_object
	if self_ref.selected_character.character_name == "RandomToon":
		CustomizeButton.show()
		CustomizeButton.pressed.connect(ShowEditor.bind(self_ref.TOON,self_ref.selected_character))
	else:
		CustomizeButton.hide()
	
func new_game_pressed(chain: ModLoaderHookChain):
	await chain.execute_next_async([])
	var self_ref = chain.reference_object
	if !Editor:
		Editor = ToonEditor.instantiate()
		self_ref.new_game_menu.get_parent().add_child(Editor)
		Editor.Saved.connect(UpdateToon.bind(chain))
	Editor.hide()
	
	var SummaryButtons = self_ref.toon_summary.find_child("HBoxContainer")
	if !CustomizeButton:
		CustomizeButton = CUSTOMIZE_BUTTON.instantiate()
		SummaryButtons.add_child(CustomizeButton)
	CustomizeButton.hide()
	
func ShowEditor(toon: PackedScene, character: PlayerCharacter):
	Editor.show()
	Editor.GenerateToon(character,toon)
	
func UpdateToon(chain: ModLoaderHookChain):
	Editor.hide()
	Editor.toon.queue_free()
	var self_ref = chain.reference_object
	self_ref.selected_character.dna = Editor.get_editor_dna()
	self_ref.selected_character.random_character_stored_name = Editor.get_editor_name()
	self_ref.toon_summary.find_child("ToonName").text = Editor.get_editor_name()
	
	self_ref.selected_toon.construct_toon(self_ref.selected_character.dna)
	self_ref.selected_toon.animator.play('neutral')
	self_ref.selected_toon.animator.animation_finished.connect(self_ref.selected_toon.animator.play.bind('neutral').unbind(1))
	
	
