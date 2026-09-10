extends Node

signal level(levelId: int)
signal transition_to_area(areaId: int)
signal change_background(areaId: int)

signal freeze_player(freeze: bool)
signal game_paused(isPaused: bool)

#signal spawn_player(player: Player)

signal init_health_bar(entity: CharacterBody2D, startHealth: int)
signal player_died
signal entity_hit(entity: CharacterBody2D, newHealth: int)
signal health_changed(entity: CharacterBody2D, newHealth: int)
signal health_depleted(entity: CharacterBody2D)

signal remove_buddy(buddy: Area2D)

signal play_next_song(songName: String)

signal remove_attack_body
signal interact(canInteract: bool, triggerId: int)
#signal activate_collectable(collectable: CollectableResource)
