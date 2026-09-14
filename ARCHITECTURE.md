# PCM Tower Climb --- Architecture and Game Systems

## Project overview

PCM Tower Climb is a local multiplayer 2D platformer with an
arcade-style approach to player participation. Multiple participants can
join through independent input devices, and the architecture keeps
participation, player entities, control, spawning, and the currently
loaded world as separate concepts.

The project builds a small gameplay architecture on top of Godot rather
than putting most behaviour directly into scene scripts. Gameplay
entities are composed from focused capabilities, while state machines
coordinate what those entities are currently doing. Player input is
translated into semantic commands before reaching gameplay, which keeps
physical devices separate from the entities they control.

Players belong to the game rather than to an individual level. Levels
provide the playable environment, areas, boundaries, and positions where
players can appear. This allows levels to be replaced while
participating players persist. Movement follows the same separation of
concerns: input expresses intent, states determine current behaviour,
components provide movement capabilities, and Godot resolves physical
movement and collisions.

Audio follows an ownership model as well. Areas define environmental
music, gameplay capabilities or states own the sounds associated with
their behaviour, and global audio managers provide the actual playback
mechanism.

The architecture is intentionally focused on **responsibilities and
intent rather than current implementation details**. Implementations may
remain simple while features are being developed, as long as the
responsibility boundaries remain clear.

## Contents

### Architecture

-   [Entities, Components and
    Capabilities](#entities-components-and-capabilities)
-   [Entity State Machines](#entity-state-machines)
-   [Player Movement and Physics](#player-movement-and-physics)

### Multiplayer

-   [Player Input and Control](#player-input-and-control)
-   [Player Lifecycle and Spawning](#player-lifecycle-and-spawning)

### World

-   [Levels, Areas and World
    Boundaries](#levels-areas-and-world-boundaries)
-   [Level Loading and Transitions](#level-loading-and-transitions)

### Audio

-   [Music and Sound Effects](#music-and-sound-effects)

------------------------------------------------------------------------

# Entities, Components and Capabilities

Gameplay entities are composed from small, reusable capabilities rather
than implementing all behaviour directly in the entity itself.

``` text
Entity
 ├── Physics
 ├── Jump
 ├── Health
 ├── ...
 └── State Machine
```

The exact components differ between entities. An entity only receives
the capabilities it needs.

### Entities

An **entity** is an object that exists and participates in gameplay,
such as a player or enemy.

The entity represents the whole gameplay object and owns its components,
but should contain as little capability-specific behaviour as possible.

``` text
Player
 ├── Jump capability
 ├── Physics capability
 └── ...

Enemy
 ├── Physics capability
 └── ...
```

Entities therefore define **what something is**, while components define
**what it can do**.

### Components

A **component** provides a focused piece of reusable behaviour or state.

For example, a jump component knows how to perform a jump, while a
physics component provides movement-related behaviour.

Components should not decide **when** their capability is used. They
provide the behaviour so another part of the entity can coordinate it.

``` text
JumpComponent
      ↑
      │ use
      │
JumpState
```

This keeps capabilities independent from the situations in which they
are used.

### Capabilities through composition

Capabilities are added through composition rather than through
increasingly specialized entity classes.

Instead of:

``` text
Entity
  ↓
MovingEntity
  ↓
JumpingEntity
  ↓
Player
```

the project favors:

``` text
Player
 ├── Physics
 └── Jump
```

Another entity can reuse the same capability where its behaviour is
compatible.

This makes it possible to add, remove or replace gameplay capabilities
without redesigning the entity hierarchy.

### Coordination

Components provide capabilities, but they do not coordinate the entity
as a whole.

That responsibility belongs to higher-level behaviour such as the
entity's state machine.

For example:

``` text
PlayerCommand
      ↓
Player State
      ↓
Components
      ↓
Godot
```

A state may interpret the current situation and use several capabilities
together, such as applying air movement while a jump is in progress.

This separates three concerns:

``` text
Entity       → what exists
State        → what it is currently doing
Component    → what it is capable of doing
```

### Godot integration

Components ultimately build on Godot functionality rather than replacing
it.

For example, a physics capability can manipulate velocity while the
entity's `CharacterBody2D` remains responsible for Godot's collision and
movement behaviour.

The component layer gives the game a reusable gameplay abstraction
around those Godot features.

### Design intent

The goal is not to turn every piece of logic into a component.

A component is useful when a behaviour represents a distinct capability
that benefits from being isolated, composed or reused.

Entity-specific coordination can remain with the entity or its states,
while reusable gameplay behaviour belongs in components.

This keeps entities small and allows new gameplay objects to be built
primarily by composing the capabilities they need.

------------------------------------------------------------------------

# Entity State Machines

Entities use state machines to represent **what they are currently
doing** and to coordinate the capabilities required for that behaviour.

``` text
Entity
  ↓
State Machine
  ↓
Current State
  ↓
Components
```

A state is therefore not a capability itself. It decides how existing
capabilities should be used in a particular situation.

### States represent behaviour

A state describes a meaningful mode of behaviour, such as:

``` text
Idle
Running
Jumping
Falling
Programming
Dead
```

While a state is active, it is responsible for the behaviour that
belongs to that situation.

For example, a jumping state may apply air movement, monitor vertical
velocity and decide when the entity should start falling.

### States coordinate capabilities

Components provide reusable capabilities such as movement, jumping or
physics.

States decide **when and how those capabilities are combined**.

``` text
JumpState
 ├── uses Jump capability
 ├── uses Physics capability
 └── decides when to transition to Fall
```

This prevents components from needing to understand the complete
behaviour of the entity.

The relationship is:

``` text
Component → can do something
State     → decides what should happen now
```

### Transitions

States do not normally replace themselves directly.

Instead, they indicate that a transition should happen.

``` text
Idle
  ↓ movement starts
Run
  ↓ jump starts
Jump
  ↓ vertical movement turns downward
Fall
  ↓ ground reached
Idle
```

The state machine owns changing the active state.

This keeps the lifecycle of states centralized and makes transitions
easier to reason about.

### Input and state

Input expresses player intent through commands such as move, jump or
interact.

The current state interprets that intent according to the entity's
current situation.

``` text
PlayerCommand
      ↓
Current State
      ↓
Capabilities
```

The same command can therefore result in different behaviour depending
on the active state.

For example, a jump command while standing may start a jump, while the
same command during another state may be ignored or interpreted
differently.

### State lifecycle

States can react when they become active, while they remain active, and
when they are left.

Conceptually:

``` text
enter
  ↓
update / physics update
  ↓
transition
  ↓
exit
```

This gives behaviour a clear lifetime.

Temporary behaviour can initialize itself on entry and clean itself up
when another state takes over.

### Entity-specific behaviour

Not every entity needs the same states.

``` text
Player
 ├── Idle
 ├── Run
 ├── Jump
 └── Fall

Enemy
 ├── Patrol
 ├── Chase
 └── Stunned
```

The state machine provides the structure, while each entity defines the
behaviour relevant to it.

### Design intent

State machines are used to keep behaviour explicit and mutually
understandable.

They are especially useful when an entity has several modes that should
not all run at the same time.

The intended separation is:

``` text
Entity       → what exists
State        → what it is currently doing
Component    → what it is capable of doing
Input        → what the participant wants to do
```

The goal is not to create a state for every small action.

States should represent meaningful behavioural modes where separating
lifecycle, rules and transitions makes the entity easier to understand
and extend.

------------------------------------------------------------------------

# Player Movement and Physics

Player movement separates **player intent**, **gameplay behaviour**, and
**physical movement**.

``` text
PlayerCommand
      ↓
Current State
      ↓
Movement capabilities
      ↓
Velocity
      ↓
Godot physics
```

Input does not move the player directly. It describes what the
participant wants to do, while the player's current state determines how
that intent affects movement.

### Movement intent

Player input is translated into semantic commands such as:

``` text
move left/right
jump pressed
jump held
interact
```

These commands contain intent rather than physics.

For example, moving right does not directly change the player's
position. It tells the current player state that movement to the right
is requested.

This keeps physical input devices independent from player movement.

### States determine movement behaviour

The active player state determines how movement should behave in the
current situation.

``` text
Grounded state
      ↓
ground movement

Jump state
      ↓
air movement + upward velocity

Fall state
      ↓
air movement + falling
```

The same movement command can therefore behave differently depending on
whether the player is standing, jumping, falling or in another state.

States coordinate movement but delegate reusable physical behaviour to
components.

### Movement capabilities

Components provide focused movement capabilities such as applying
horizontal movement, jumping, gravity or stopping upward movement.

Conceptually:

``` text
State
 ├── movement capability
 ├── jump capability
 └── physics capability
```

This allows states to describe behaviour without implementing all of the
underlying movement calculations themselves.

It also allows movement capabilities to be reused or changed
independently from the state machine.

### Velocity and position

Gameplay movement primarily works by changing **velocity**, rather than
directly changing the player's position.

``` text
Player intent
      ↓
desired movement
      ↓
velocity
      ↓
move_and_slide()
      ↓
position + collisions
```

The game determines how the player should move. Godot then resolves that
velocity against the physical world.

This distinction is important: gameplay code expresses movement
behaviour, while Godot remains responsible for collision-aware movement.

### Fixed physics updates

Physical movement runs on Godot's fixed physics updates.

The physics delta represents the amount of simulated time for the
current physics step.

Movement calculations that depend on time use this delta so behaviour
remains based on elapsed time rather than the number of updates
performed.

``` text
physics tick
    ↓
read current command
    ↓
update state / velocity
    ↓
perform physical movement
    ↓
resolve collisions
```

Gameplay state transitions can then react to the resulting physical
situation.

### Collisions inform behaviour

Godot's physics results provide information such as whether the player
is on the floor, against a wall or touching a ceiling.

States can use this information to decide what should happen next.

``` text
Jump
  ↓
ceiling reached / upward movement ends
  ↓
Fall
  ↓
floor reached
  ↓
Grounded
```

Collision detection therefore belongs to the physical world, while
interpreting those collisions belongs to gameplay behaviour.

### Design intent

Player movement is deliberately split across several responsibilities:

``` text
Input       → what the participant wants
State       → how movement behaves right now
Component   → reusable movement capabilities
Velocity    → requested physical motion
Godot       → movement and collision resolution
```

No single layer should need to understand the entire movement system.

This makes it possible to change movement rules, introduce new player
states or reuse physical capabilities without coupling input, gameplay
behaviour and Godot physics together.

------------------------------------------------------------------------

# Player Input and Control

The game supports multiple local input devices and allows each joined
participant to be controlled independently.

Input is separated into three concerns:

``` text
Physical device
    ↓
PlayerInputSession
    ↓
Game context
    ↓
Session context
    ↓
Control target
```

### PlayerInputSession

A `PlayerInputSession` represents a joined participant and their input
device. Physical device details stay in the input layer; gameplay
receives semantic `PlayerCommand`s such as move, jump and interact.

A session does not fundamentally imply that a `Player` entity exists.

### Input contexts

Contexts determine **what input currently means**.

The **game context** applies to the game as a whole, for example
`GAMEPLAY`, `MAIN_MENU`, `PLAYER_SELECT` or `PAUSE_MENU`.

A **session context** can temporarily override gameplay for one
participant, for example while that player uses an inventory.

``` text
Game: GAMEPLAY
P1: INVENTORY
P2: <none>

P1 → inventory
P2 → gameplay
```

Game and session contexts are stacks, so closing a temporary context
restores the previous one.

### Control targets

Control targets determine **which gameplay entity a participant
controls**.

``` text
[Player]
[Player, Crane]
```

The top target receives the session's `PlayerCommand`. Popping it
restores control to the previous target.

Context and control-target stacks are independent: opening a menu does
not change the controlled entity, and temporarily controlling another
entity does not change the input context.

Player creation, spawning and positioning are documented separately
under **Player Lifecycle and Spawning**.

------------------------------------------------------------------------

# Player Lifecycle and Spawning

Player participation, player entities, and spawning are separate
lifecycle concepts.

`text id="zzwwu8" Participant joins     ↓ PlayerInputSession exists     ↓ Player entity exists     ↓ Player is spawned into a level`

These steps may happen together, but they do not fundamentally depend on
each other.

### Joining

Joining represents a participant entering the game with an input device.

A joined participant is represented by a `PlayerInputSession` and
receives an available player slot.

This can happen before a `Player` entity exists. For example,
participants may join on a player-select screen before gameplay starts.

### Player creation

A `Player` is the participant's gameplay entity.

Creating a Player and joining are separate concerns:

\`\`\`text id="6uslht" PlayerInputSession = participant/input

Player = gameplay entity


    This allows game flow to decide when a joined participant actually needs a Player.

    ### Spawning

    Spawning places an existing or newly created Player into the current level.

    Levels define suitable spawn positions. The spawning system decides which position belongs to each player and positions players without making the level responsible for player lifecycle.

    This supports multiple players independently:

    ```text id="slgg2c"
    Level
        ├── spawn position P1
        ├── spawn position P2
        ├── spawn position P3
        └── spawn position P4

The same principle can later be used for level transitions, checkpoints
and respawning: the Player belongs to the game, while the loaded level
provides the location where that Player should appear.

### Level independence

Players live outside loaded levels:

`text id="axt1gu" Main ├── PlayerContainer │   ├── Player 1 │   └── Player 2 │ └── LevelContainer     └── CurrentLevel`

Loading or replacing a level therefore does not inherently create or
destroy the players.

This keeps these responsibilities separate:

`text id="wfl7un" PlayerInputSession  → who joined Player              → gameplay entity Level               → playable environment and spawn locations SpawnManager        → player creation/positioning LevelManager        → loaded level`

### Current implementation

Currently, joining during gameplay immediately creates/spawns a `Player`
and establishes it as the session's base control target.

This is intentionally simpler than the lifecycle model above. When
player selection or other pre-game flows are introduced, joining, Player
creation and spawning can be separated without changing their
responsibilities.

------------------------------------------------------------------------

# Levels, Areas and World Boundaries

Levels describe the playable world and expose the spatial information
that gameplay systems need.

A level is more than a visual scene. It defines the environment in which
gameplay takes place, including usable areas, boundaries and spawn
locations.

``` text
Level
 ├── Areas
 ├── World geometry
 ├── Boundaries
 └── Spawn positions
```

### Levels

A **level** represents a playable environment.

It owns the world-specific objects and geometry that belong to that
environment, but it does not own persistent player lifecycle.

``` text
Game
 ├── Players
 └── Current Level
       ├── geometry
       ├── enemies
       ├── areas
       └── spawn positions
```

Replacing a level therefore changes the environment without
fundamentally changing who the players are.

### Areas

A level can be divided into **areas** when different parts of the level
need their own spatial rules.

An area represents a meaningful section of the playable world.

``` text
Level
 ├── Area A
 ├── Area B
 └── Area C
```

Areas can be used to describe where gameplay is currently taking place
without requiring every system to understand the entire level scene.

For example, an area may define the space relevant to the current
camera, encounters or local level behaviour.

### World boundaries

Playable areas need explicit boundaries.

These boundaries describe the usable world space rather than relying on
assumptions about sprite sizes, collision geometry or scene coordinates.

``` text
Area
 ├── left
 ├── right
 ├── top
 └── bottom
```

Other systems can use these boundaries to understand the available
space.

For example, a camera can remain inside the current playable area
without knowing how that area was constructed.

### Boundaries are gameplay information

Collision shapes and world boundaries are related but serve different
purposes.

Collision geometry determines what physical objects collide with.

World boundaries describe the meaningful extent of a playable area.

``` text
Collision geometry
      → what blocks movement

Area boundaries
      → where the playable area exists
```

They may sometimes occupy the same physical location, but one should not
have to be derived implicitly from the other.

### Spawn locations

Levels also provide suitable positions where players or other gameplay
entities can appear.

``` text
Level
 ├── Player 1 start
 ├── Player 2 start
 ├── Player 3 start
 └── Player 4 start
```

The level defines **where** an entity can appear.

The spawning system remains responsible for deciding **which entity**
should be placed there.

This keeps level design independent from player lifecycle.

### Level-specific knowledge stays in the level

Systems outside the level should not need to know the internal node
structure of a specific level.

Instead, the level exposes meaningful information such as:

``` text
current area
area boundaries
player spawn position
```

This creates a stable contract between level design and gameplay
systems.

The internal scene structure can then evolve without requiring unrelated
systems to be rewritten.

### Design intent

The intended responsibility split is:

``` text
Level        → playable environment
Area         → meaningful section of that environment
Boundaries   → usable spatial extent
Spawn points → valid positions for entering the world
Game systems → consume this information without owning it
```

The goal is to make levels self-describing.

A developer creating or modifying a level should define the spatial
information that gameplay depends on as part of that level, instead of
relying on hidden assumptions elsewhere in the project.

------------------------------------------------------------------------

# Level Loading and Transitions

The game separates the lifecycle of the playable environment from the
lifecycle of players.

A level can be loaded, replaced or transitioned without recreating the
players participating in the game.

``` text
Players persist

Level A
   ↓
Level transition
   ↓
Level B
```

### The current level

At any moment, the game has a **current level** that represents the
active playable environment.

``` text
Game
 ├── Players
 └── Current Level
```

Level management is responsible for changing that environment.

Other systems can work with the current level without needing to know
how it was loaded or where its scene is stored.

### Loading a level

Loading establishes a new playable environment.

Conceptually:

``` text
Level requested
      ↓
Previous level removed
      ↓
New level loaded
      ↓
New level becomes current
      ↓
Players positioned in level
```

Loading the scene and placing players are related steps, but they remain
separate responsibilities.

The level provides the environment and valid positions. Player lifecycle
and spawning determine which players should appear there.

### Players exist outside levels

Players are not fundamentally children of the currently loaded level.

``` text
Main
├── PlayerContainer
│    ├── Player 1
│    └── Player 2
│
└── LevelContainer
     └── CurrentLevel
```

This allows the environment to be replaced while player entities
continue to exist.

A level transition therefore means:

``` text
replace environment
+
reposition players
```

rather than:

``` text
destroy players
+
destroy level
+
create level
+
create players
```

### Entering the new level

Once a level becomes active, participating players need suitable
positions within it.

The new level provides those positions.

``` text
Player 1 ──→ Level spawn position 1
Player 2 ──→ Level spawn position 2
```

The transition system does not need to know the internal structure of
the level to determine these coordinates.

It asks the level for meaningful world information and uses the
spawning/lifecycle system to position the players.

### Transition destinations

Not every transition needs to mean starting a level from its default
beginning.

The same model can support different destinations:

``` text
Level transition
      ↓
destination
      ↓
start / entrance / checkpoint / other position
```

The destination describes **where players should enter**, while level
loading remains concerned with **which environment should be active**.

This allows transition rules to evolve independently from the
level-loading mechanism.

### Level-local state

Objects that belong specifically to a level normally share that level's
lifetime.

``` text
Level
 ├── world geometry
 ├── enemies
 ├── local objects
 └── areas
```

Replacing the level removes that level-local world.

Objects that should survive transitions need to belong to a longer-lived
game-level system instead.

This makes scene ownership communicate lifecycle.

### Transition responsibility

A transition coordinates several existing responsibilities rather than
owning all of them.

``` text
Level management
      → changes the environment

Level
      → describes valid world positions

Player lifecycle
      → determines participating players

Spawning
      → positions those players
```

Keeping these responsibilities separate prevents level loading from
becoming responsible for player creation, input or gameplay state.

### Design intent

The central rule is:

``` text
Players belong to the game.
Levels belong to the current environment.
```

Level transitions replace the environment around persistent game-level
entities.

The goal is for gameplay systems to depend on the concept of a **current
level**, rather than on a particular scene tree or loading
implementation. This allows the loading mechanism, transition effects
and level structure to evolve without changing the fundamental lifecycle
model.

------------------------------------------------------------------------

# Music and Sound Effects

Audio is separated into **music ownership**, **sound-effect ownership**,
and **playback**.

Gameplay systems decide **what should be heard**, while global audio
managers are responsible for **how it is played**.

``` text
Environment                         Gameplay
     │                                  │
   Area                        Component / State
     │                                  │
     ▼                                  ▼
MusicManager                       SfxManager
     │                                  │
     └────────── audio playback ────────┘
```

### Music

Music belongs to the environment in which gameplay takes place.

An **Area** defines the music associated with that part of the world.

``` text
Level
 ├── Area 1 → tower music
 ├── Area 2 → factory music
 └── Area 3 → boss music
```

When the active area changes, its music becomes the desired music for
the game.

The Area determines **what should be playing**. It does not manage audio
playback itself.

### MusicManager

`MusicManager` provides global music playback.

``` text
Area
  ↓
desired music
  ↓
MusicManager
  ↓
audio playback
```

It owns the lifetime of music independently from individual levels and
areas.

This allows music to continue, stop or change when the environment
changes without making level objects responsible for managing an
`AudioStreamPlayer`.

The manager deals with playback behaviour. Areas only provide the
desired `AudioStream`.

### Sound effects

Sound effects belong to the gameplay behaviour that causes them.

For capability-related actions, the sound is normally owned by the
corresponding component.

``` text
JumpComponent
 ├── performs jump
 └── jump sound

HealthComponent
 ├── applies damage
 └── damage sound
```

This means the sound occurs when the capability actually performs its
behaviour, rather than because another system assumes that behaviour
happened.

### State sounds

Some sounds belong to a behavioural state rather than an individual
capability.

This is appropriate when the lifetime of the sound corresponds to the
lifetime of the state.

``` text
ProgrammingState

enter
  ↓
start programming sound

exit
  ↓
stop programming sound
```

The distinction is based on ownership:

``` text
Component → sound belongs to performing a capability

State     → sound belongs to being in a behavioural state
```

The goal is not to enforce one location for all sound effects, but to
keep each sound with the gameplay concept responsible for it.

### SfxManager

`SfxManager` provides global playback for short gameplay sounds.

``` text
Gameplay behaviour
       ↓
   AudioStream
       ↓
   SfxManager
       ↓
available audio player
       ↓
     playback
```

Gameplay objects do not need to create and manage their own
`AudioStreamPlayer`s for ordinary one-shot effects.

The manager maintains multiple audio players so independent sounds can
overlap.

If all available players are occupied, new one-shot sounds may be
discarded rather than delayed. Immediate gameplay feedback is generally
more important than playing every requested sound later.

### Audio resources

Gameplay objects reference `AudioStream` resources rather than
filesystem paths.

For example, a component can expose its sound as configuration:

``` text
JumpComponent
 └── jump_sfx: AudioStream
```

The scene determines which actual audio resource is assigned.

This keeps resource selection configurable through Godot while keeping
filesystem knowledge out of gameplay behaviour.

### Ownership

Audio follows the same ownership principles as the rest of the gameplay
architecture.

``` text
Area
  → music associated with a location

Component
  → SFX associated with performing a capability

State
  → SFX associated with a behavioural state

MusicManager
  → global music playback

SfxManager
  → global concurrent SFX playback
```

Managers do not know what jumping, programming, enemies or areas mean.

Likewise, gameplay systems do not need to know how audio players are
allocated or managed.

### Design intent

The central separation is:

``` text
Gameplay
   → decides WHAT should be heard

Audio managers
   → decide HOW it is played
```

Audio should be attached to the gameplay concept that owns it rather
than to whichever script happens to have convenient access to an audio
player.

This allows audio resources and playback implementation to change
without coupling them to gameplay behaviour.

------------------------------------------------------------------------

## Required implementation work

The current audio managers originate from the earlier Annihilation
implementation. The following changes bring the implementation in line
with the architecture described above.

### Use AudioStream resources

`MusicManager` and `SfxManager` currently accept resource paths and load
the audio when playback is requested.

Replace path-based playback:

``` text
"path/to/jump_sound"
       ↓
load()
       ↓
play
```

with resource-based playback:

``` text
AudioStream
    ↓
play
```

Components, states and areas should expose their audio as exported
`AudioStream` properties where appropriate.

For example:

``` gdscript
@export var jump_sfx: AudioStream
```

and conceptually call:

``` gdscript
SfxManager.play(jump_sfx)
```

### Associate music with Areas

Areas should be able to define their desired music.

Conceptually:

``` gdscript
@export var music: AudioStream
```

When an Area becomes active, its music should be passed to
`MusicManager`.

``` text
Area becomes active
       ↓
Area.music
       ↓
MusicManager
```

The Area should not directly operate an `AudioStreamPlayer`.

The existing Area activation/lifecycle mechanism should be used to
connect area changes to music selection rather than introducing a
separate audio-specific world lifecycle.

### Move gameplay SFX to their owners

Existing and future sound effects should be placed with the gameplay
behaviour that owns them.

For example:

``` text
jump        → JumpComponent
damage      → relevant damage/health capability
stomp       → stomp capability
```

Sounds whose lifetime corresponds to a state should instead be
controlled by that state.

``` text
enter state → start sound
exit state  → stop sound
```

This should be decided according to behavioural ownership rather than by
placing all audio in either components or states.

### Retain SFX player pooling

`SfxManager` should retain a pool of `AudioStreamPlayer`s so multiple
one-shot sounds can play simultaneously.

``` text
SfxManager
 ├── Player
 ├── Player
 ├── Player
 └── ...
```

A requested sound receives an available player, which returns to the
pool when playback finishes.

The size of the pool remains an implementation/configuration choice
rather than part of the gameplay architecture.

### Remove delayed SFX queuing

The existing queue should not cause ordinary gameplay sounds to play
significantly after the action that produced them.

The intended behaviour is:

``` text
SFX requested
      ↓
player available?
   ↙        ↘
 yes        no
  ↓          ↓
play       discard
```

More advanced policies such as priorities or replacing less important
sounds can be introduced later if they become necessary.

### Keep the managers generic

While refactoring the managers, avoid introducing gameplay-specific
knowledge into them.

The desired interfaces remain conceptually small:

``` text
MusicManager
 ├── play(stream)
 ├── stop()
 └── music playback behaviour

SfxManager
 └── play(stream)
```

Additional playback options can be added when actual gameplay
requirements demand them.

The managers should not contain concepts such as players, levels, areas,
jumping, enemies or states.

Once these changes are complete, the audio system follows the same
architectural principle used throughout the project: **gameplay objects
own gameplay meaning, while shared infrastructure provides the mechanism
needed to perform it.**
