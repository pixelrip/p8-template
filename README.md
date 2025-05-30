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
│   ├── core/              # Core systems
│   │   ├── game-state.lua # State management
│   │   └── input-manager.lua # Input handling
│   ├── entities/          # Game objects (empty - add your entities)
│   ├── states/            # Game states
│   │   └── title.lua      # Title screen example
│   ├── systems/           # Game systems
│   │   └── collision.lua  # Collision detection
│   └── utils/
│       └── log.lua        # Logging utility
├── assets/                # Separate .p8 files for graphics/audio
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

See [docs/README.md](docs/README.md) for complete documentation.

**Quick Links:**
- [Getting Started](docs/getting-started.md) - Setup and first game state
- [Architecture Guide](docs/architecture.md) - Patterns and optimization
- [API Reference](docs/api/) - Core systems documentation

## Pre-Built Components

### Game State Manager
Simple state management system. [Documentation](docs/api/game-state.md)

### Input Manager
Advanced input handling with cooldowns and patterns. [Documentation](docs/api/input-manager.md)

### Collision System
Basic collision detection with extension points. [Documentation](docs/api/collision.md)

### Constants System
Centralized configuration using flat naming. [Documentation](docs/api/constants.md)

### Logging Utility
Simple debug logging. [Documentation](docs/api/logging.md)
