# Pico-8 Game Boilerplate

The project is meant to serve as a well structured project starting point for a PICO-8 game. 

## Prerequisites

1. **Pico-8** - Install from [lexaloffle.com](https://www.lexaloffle.com/pico-8.php)
2. **Python 3.4+** - Required for picotool
3. **picotool** - Install from [GitHub](https://github.com/dansanderson/picotool)
3. **Git** (recommended) - For version control

## Project Structure

```
project/
├── src/                   # Source code
│   ├── main.lua           # Entry point with _init, _update, _draw
│   ├── config/
│   │   └── constants.lua  # Flat constants structure
│   ├── entities/          # Game objects (Player, Enemy, etc.)
│   ├── systems/           # Cross-entity mechanics (CollisionSystem, etc.)
│   ├── states/            # Game states (TitleState, GameplayState, etc.)
│   ├── ui/                # Interface components
│   │   ├── draw_utils.lua # Drawing utilities
│   │   └── ui.lua         # UI management
│   └── lib/               # External libraries (gs.lua, im.lua)
├── assets/                # Separate .p8.png files for graphics/audio
├── build/                 # Generated files (dev/prod builds)
├── scripts/               # Build automation
├── config/                # Build configuration
└── docs/                  # Documentation
```


## Workflow

- Edit spritesheet in `assets/sprites.p8`
- Edit audio (sfx and patterns) in `assets/audio.p8`
- Build the project with `./scripts/build.sh`
- Load and run the compiled file in Pico-8

## Documentation

`/docs/design/`
- `game-design-document.md`: a lightweight template for a game design document meant to help with team alignment and prioritization
- `technical-design-document.md`: anothr lightweight template focused on technical requirements for the project

`/docs/src/`
- Intended to mirror the `/src` folder for the project, providing concise documentation and example usage of the various entities, systems, utilities, and core components

`/docs/guidelines.md`
- This boilerplate assumes a certain approach to how the games code will be architected, what patterns the code will follow, and what optimization strategies will be employed. This document serves to outline that approach.


## Pre-Built Components

### Constants System
Centralized configuration for all game parameters using a flat naming structure. [Documentation](docs/src/config/constants.md)

### Game State Manager
A simple game state manager that nearly any games could use. [Documentation](docs/src/core/game-state.md)

### Input Manager
A lightweight input manager for button presses, etc. [[Documentation]](docs/src/core/input-manager.md)

### Logging Utility
A lightweight logging tool [Documentation](docs/src/utils/log.md)