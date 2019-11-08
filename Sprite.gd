extends Node2D

var speed_max = 150 #the maximum speed
var s = 0 #the actual speed
onready var car = preload("res://car_enemi.tscn")

func _process(delta):
	if (Input.is_action_pressed("move")): #control
		if s < speed_max: #less from the maximum speed
			s += 0.5 #accel
		else: #at the maximum speed
			s = speed_max # stay at max speed
	elif s > 0: #more from the minimum speed
		s -= 0.9 #decelerate
	elif s <= 0: #at the minimum speed
		s = 0 #stop
	position.y += s #apply speed
	var x = (((s - speed_max) / speed_max * 100) -100 * -1) #get the percentage of the lenght from the speed and the max_speed values
	var a = 2 +((2 - 1) * x / 100) #get the max zoom / unzoom value from the speed perecentage
	$Camera2D.zoom = Vector2(a,a) #set the camera zoom
	$Camera2D.offset =  Vector2(randf(), randf()) * 10 * x / 100 #set the screen shake value
	get_node("../window/vignette").modulate = Color(1,1,1,1 * x / 100) #set the modulate's alpha value of the vignette screen border effect texture 
	$Sprite.scale.y = 1 + (0.1 * x / 100) #set the scale.y value  
	$Sprite.get_material().set_shader_param("amount",3 * x / 100) #set the shader parameter "amount" for the chromatic aberation
	get_node("../ParallaxBackground/ParallaxLayer/TextureRect").get_material().set_shader_param("amount",1.5 * x / 100)
	print(str(int(x)) + "% of the maximum speed")

#side cars spawn
func spawn_car(point,timer):
	var node = car.instance()
	get_tree().get_root().add_child(node)
	node.global_position = get_node(point).global_position
	get_node(timer).start(rand_range(0.2,2))

func _on_Timer_timeout():
	spawn_car("car1","Timer")

func _on_Timer2_timeout():
	spawn_car("car2","Timer2")
