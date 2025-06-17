extends Control

var selected_character: PlayerCharacter
var toon:Toon

signal Saved()
signal Closed()

var CurrentSkirtColor

@onready var Colorbutton := $Panel/BodyColorPage/Color
@onready var HeadColorbutton := $Panel/BodyColorPage/HeadColor
@onready var BodyColorbutton := $Panel/BodyColorPage/BodyColor
@onready var LegsColorbutton := $Panel/BodyColorPage/LegsColor
@onready var species := $Panel/BodyColorPage/Species
@onready var body_height := $"Panel/BodyColorPage/Body Height"
@onready var head_shape := $"Panel/BodyColorPage/Head Shape"
@onready var eye_lashes := $Panel/BodyColorPage/EyeLashes
@onready var skirttoggle: HBoxContainer = $Panel/ClothesPage/SkirtToggle
@onready var body_color_page: VBoxContainer = $Panel/BodyColorPage

@onready var shirt := $Panel/ClothesPage/Shirt
@onready var shirt_color := $Panel/ClothesPage/ShirtColor
@onready var skirt := $Panel/ClothesPage/Skirt
@onready var skirt_color := $Panel/ClothesPage/SkirtColor
@onready var shorts := $Panel/ClothesPage/Shorts
@onready var shorts_color := $Panel/ClothesPage/ShortsColor

@onready var toon_name: TextEdit = $Panel/InfoPage/HBoxContainer/ToonName



@onready var clothes_page: VBoxContainer = $Panel/ClothesPage
@onready var info_page: VBoxContainer = $Panel/InfoPage



@onready var ShirtFiles := DirAccess.get_files_at('res://objects/toon/clothing/shirts')
@onready var ShortsFiles := DirAccess.get_files_at('res://objects/toon/clothing/shorts')
@onready var SkirtsFiles := DirAccess.get_files_at('res://objects/toon/clothing/skirts')


func GenerateToon(character: PlayerCharacter,TOON: PackedScene):
	selected_character = character
	toon = TOON.instantiate()
	toon.toon_dna = selected_character.dna
	species.current_value = selected_character.dna.species
	body_height.current_value = selected_character.dna.body_type
	head_shape.current_value = selected_character.dna.head_index
	eye_lashes.current_value = selected_character.dna.eyelashes
	skirttoggle.current_value = selected_character.dna.skirt
	shorts_color.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.bottoms.base_color))
	skirt_color.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.bottoms.base_color))
	shirt_color.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.shirt.base_color))
	
	if selected_character.dna.bottoms.color_type == 1:
		skirt_color.Disable()
	else: skirt_color.Enable()
	
	if selected_character.dna.skirt == true:
		shorts.hide()
		shorts_color.hide()
		skirt.show()
		skirt_color.show()
	else:
		shorts.show()
		shorts_color.show()
		skirt.hide()
		skirt_color.hide()

	
	
	Colorbutton.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.head_color))
	
	HeadColorbutton.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.head_color))
	BodyColorbutton.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.torso_color))
	LegsColorbutton.current_value = Globals.dna_colors.keys().find(Globals.dna_colors.find_key(selected_character.dna.leg_color))
	
	
	
	
	%EditorViewPort.add_child(toon)
	toon.construct_toon(toon.toon_dna)
	toon.animator.play('neutral')
	toon.animator.animation_finished.connect(toon.animator.play.bind('neutral').unbind(1))
	
	pass

func ChangeBodyHeight(Index:int):
	print(Index)
	toon.toon_dna.body_type = Index
	RebuildToon()

	pass
func ChangeSpecies(Index:int):
	if Index == ToonDNA.ToonSpecies.MOUSE:
		head_shape.max_value = 1
		head_shape.current_value = 1
	else:
		head_shape.max_value = 3
	toon.toon_dna.species = Index
	RebuildToon()
	pass
func ChangeHeadShape(Index:int):
	toon.toon_dna.head_index = Index
	RebuildToon()
	pass

func ChangeColor(Index:int):
	toon.toon_dna.head_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	toon.toon_dna.torso_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	toon.toon_dna.leg_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	HeadColorbutton.current_value = Index
	BodyColorbutton.current_value = Index
	LegsColorbutton.current_value = Index
	
	RebuildToon()
func ChangeHeadColor(Index:int):
	toon.toon_dna.head_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	Colorbutton.current_value = Index
	RebuildToon()
func ChangeBodyColor(Index:int):
	toon.toon_dna.torso_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	RebuildToon()
func ChangeLegsColor(Index:int):
	toon.toon_dna.leg_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	RebuildToon()



func SaveAndClose():
	Saved.emit()
	
func Close():
	Closed.emit()


func ToggleAdvancedColor(Index:bool):
	if Index == true:
		Colorbutton.Disable()
		HeadColorbutton.show()
		BodyColorbutton.show()
		LegsColorbutton.show()
	else:
		Colorbutton.Enable()
		HeadColorbutton.hide()
		BodyColorbutton.hide()
		LegsColorbutton.hide()
	
	pass

func ChangePage(Index:int):
	match Index:
		0: 
			body_color_page.show()
			info_page.hide()
			clothes_page.hide()
			$Panel/PageButton/Label2.text = "Body & Color"
		1:
			body_color_page.hide()
			clothes_page.show()
			info_page.hide()
			$Panel/PageButton/Label2.text = "Clothes"
		2:
			info_page.show()
			body_color_page.hide()
			clothes_page.hide()
			$Panel/PageButton/Label2.text = "Name & info"
			
			
func ChangeShirt(Index:int):
	var CurrentColor := toon.toon_dna.shirt.base_color
	toon.toon_dna.shirt = Util.universal_load('res://objects/toon/clothing/shirts/'+ShirtFiles[Index]).duplicate()
	toon.toon_dna.shirt.base_color = CurrentColor
	toon.toon_dna.shirt.sleeve_color = toon.toon_dna.shirt.base_color
	RebuildToon()

func ChangeShirtColor(Index:int):
	
	toon.toon_dna.shirt.base_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	toon.toon_dna.shirt.sleeve_color = toon.toon_dna.shirt.base_color
	RebuildToon()


func ChangeShorts(Index:int):
	var CurrentColor := toon.toon_dna.bottoms.base_color
	toon.toon_dna.bottoms = Util.universal_load('res://objects/toon/clothing/shorts/'+ShortsFiles[Index]).duplicate()
	toon.toon_dna.bottoms.base_color = CurrentColor
	RebuildToon()



func ChangeShortsColor(Index:int):
	toon.toon_dna.bottoms.base_color = Globals.dna_colors[Globals.dna_colors.keys()[Index]]
	RebuildToon()

func ChangeSkirt(Index:int):
	if toon.toon_dna.bottoms.color_type == 0:
		CurrentSkirtColor = toon.toon_dna.bottoms.base_color
	
	toon.toon_dna.bottoms = Util.universal_load('res://objects/toon/clothing/skirts/'+SkirtsFiles[Index]).duplicate()
	
	if toon.toon_dna.bottoms.color_type == 1:
		toon.toon_dna.bottoms.base_color = Color("FFFFFF")
		skirt_color.Disable()
	else:
		if CurrentSkirtColor:
			toon.toon_dna.bottoms.base_color = CurrentSkirtColor
		skirt_color.Enable()
		
	RebuildToon()
	





func ToggleSkirt(Index:int):
	toon.toon_dna.skirt = bool(Index)
	var CurrentColor := toon.toon_dna.bottoms.base_color
	if Index == 1:
		$Panel/ClothesPage/Shorts.hide()
		$Panel/ClothesPage/ShortsColor.hide()
		$Panel/ClothesPage/Skirt.show()
		$Panel/ClothesPage/SkirtColor.show()
		toon.toon_dna.bottoms = Util.universal_load('res://objects/toon/clothing/skirts/'+SkirtsFiles[0]).duplicate()
		RebuildToon()
	else:
		$Panel/ClothesPage/Shorts.show()
		$Panel/ClothesPage/ShortsColor.show()
		$Panel/ClothesPage/Skirt.hide()
		$Panel/ClothesPage/SkirtColor.hide()
		toon.toon_dna.bottoms = Util.universal_load('res://objects/toon/clothing/shorts/'+ShortsFiles[0]).duplicate()
		RebuildToon()
		
	toon.toon_dna.bottoms.base_color = CurrentColor
	RebuildToon()

func ToggleLashes(Index:int):
	toon.toon_dna.eyelashes = bool(Index)
	RebuildToon()
	
	
func RebuildToon():
	toon.construct_toon(toon.toon_dna)
	toon.animator.play('neutral')
	toon.animator.animation_finished.connect(toon.animator.play.bind('neutral').unbind(1))

func get_editor_dna() -> ToonDNA:
	return toon.toon_dna 

func get_editor_name() -> String:
	return toon_name.text
