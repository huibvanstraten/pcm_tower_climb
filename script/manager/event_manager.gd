extends Node

signal level(levelId: int)
signal transition_to_area(areaId: int)

signal freeze_player(freeze: bool)

signal player_session_joined(player_slot: int)
signal player_session_waiting(player_slot: int)

signal player_joined(player: Player)
signal player_died(player: Player)
signal player_respawned(player: Player)

signal init_health_bar(entity: CharacterBody2D, startHealth: int)
signal entity_hit(entity: CharacterBody2D, newHealth: int)
signal health_changed(entity: CharacterBody2D, newHealth: int)
signal health_depleted(entity: CharacterBody2D)

signal remove_attack_body

signal programming_started(player: Player)
signal programming_cancelled(player: Player)
signal programming_finished(player: Player)

signal respawn_requested(spawn_positions: Array[Vector2])

signal state_changed(state: GameState.Type)
