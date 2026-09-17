# AGENTS.md

## Project

PCM Tower Climb is a local multiplayer 2D tower-climbing game built in Godot 4.

The project is designed for up to four players and supports players joining
during gameplay.

## Development principles

Before proposing architectural changes:

- Inspect the existing implementation.
- Prefer extending existing abstractions over introducing parallel systems.
- Do not move responsibilities between systems without discussing the reason.
- Keep solutions generic when a mechanic is expected to be reused.
- Implement changes incrementally and verify each meaningful step.

## Core architecture

### Players

Players are persistent entities owned by `PlayerContainer`.

Players are independent from loaded levels and areas.

Player movement is implemented through:

Player
→ PlayerStateMachine
→ PlayerState
→ Components
→ CharacterBody2D

States decide behavior.
Components implement reusable mechanics.

Do not put state-specific behavior directly in `Player` when it belongs
in a state or component.

### Input

Physical input devices do not directly control Player entities.

Input flows through:

Physical device
→ PlayerInputDevice
→ ControllerInputSource
→ PlayerCommand
→ PlayerInputSession
→ control target

Input sessions are dynamically created when devices join.

Control targets use a stack so that control can temporarily move from
the Player to another object.

Examples include programming blocks, cranes, menus, or other interactables.

### Input contexts

Input behavior depends on context.

Examples:

- Gameplay
- Player selection
- Inventory
- Pause

Do not bypass the context/session system with direct input handling unless
the input is intentionally global.

### Levels

Players do not belong to levels.

Levels provide the world in which persistent players operate.

Spawn points and checkpoints belong to the level.

### Programming and interaction

Programming is a Player state initiated through interaction with an
interactable world object.

Entering programming temporarily stop player movement and transfer
the player's input session to another control target.

Keep the programming system generic so it can support different
programmable/interactable objects.

## GDScript conventions

Use tabs for indentation.

Prefer typed variables, parameters, and return values.

Use `class_name` for reusable domain/gameplay types where appropriate.

Keep state transitions inside the state-machine architecture.

Prefer signals/events for communication between systems that should not
directly depend on each other.

## Working with this repository

Do not assume the implementation from documentation alone.

Inspect the relevant scripts/scenes before proposing a change.

When debugging:

1. Trace the existing execution path.
2. Identify which abstraction owns the behavior.
3. Add diagnostics when necessary.
4. Fix the problem at that abstraction level.
5. Avoid unrelated refactoring.
