# Pico-8 Game Boilerplate

A minimal but extensible starting point for Pico-8 games. Provides essential systems with clear expansion points - start simple, grow smart. 

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
│   │   ├── collision.lua  # Collision detection
│   │   ├── timer.lua      # Timer and tween system
│   │   ├── camera.lua     # Camera system
│   │   └── particles.lua  # Particle system
│   └── utils/
│       ├── log.lua        # Logging utility
│       └── math.lua       # Math utilities
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

## Design Philosophy

- **Minimal core** - Essential functionality that works immediately
- **Clear expansion points** - Commented examples show how to grow each system
- **Easy removal** - Components can be removed without breaking others
- **Token efficient** - Optimized for Pico-8's constraints

## Documentation

See [docs/README.md](docs/README.md) for complete documentation.

**Quick Links:**
- [Getting Started](docs/getting-started.md) - Setup and first game state
- [Architecture Guide](docs/architecture.md) - Patterns and optimization
- [API Reference](docs/api/) - Core systems documentation

## Pre-Built Components

### Game State Manager
Simple state management with examples for complex transitions. [Documentation](docs/api/game-state.md)

### Input Manager
Simple input handling with extension points for advanced features. [Documentation](docs/api/input-manager.md)

### Collision System
Basic collision detection with extension points for tilemaps, groups, and optimization. [Documentation](docs/api/collision.md)

### Timer System
Simple timing and animation with extension points for advanced tweening. [Documentation](docs/api/timer.md)

### Camera System
Simple camera control with extension points for advanced behaviors. [Documentation](docs/api/camera.md)

### Particle System
Simple particle effects with extension points for advanced visual effects. [Documentation](docs/api/particles.md)

### Constants System
Centralized configuration that scales from simple to complex games. [Documentation](docs/api/constants.md)

### Math Utilities
Essential 2D game math with extension points for advanced calculations. [Documentation](docs/api/math.md)

### Logging Utility
Simple debug logging that can grow into full debugging tools. [Documentation](docs/api/logging.md)
