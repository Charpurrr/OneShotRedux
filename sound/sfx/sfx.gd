class_name SFX
extends Resource


## Play (create) a sound effect and destroy it when finished.
static func play_sfx(sound: AudioStreamWAV, node: Object, bus: StringName):
	var player := AudioStreamPlayer.new()

	node.call_deferred("add_child", player)
	player.stream = sound
	player.bus = bus
	player.autoplay = true

	player.connect(&"finished", player.queue_free)
