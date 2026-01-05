# Nice iTerm2 Themes

A collection of retro-styled iTerm2 color themes inspired by classic computer terminals and video games.

## Themes Included

### 1. Retro Amber

Classic amber phosphor monitor aesthetic. Reminiscent of vintage terminals from the 70s and 80s.

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│   INFERENCE MEMORY ESTIMATE FOR                          │
│   https://hf.co/MiniMaxAI/MiniMax-M2.1 @ main            │
│                                                          │
│   TOTAL MEMORY        214.32 GB (228.7B params)          │
│   REQUIREMENTS        ████████████████████████████████   │
│                                                          │
│   F32                 0.2 / 214.3 GB                     │
│   62.7M PARAMS        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   │
│                                                          │
│   F8_E4M3             211.8 / 214.3 GB                   │
│   227.4B PARAMS       ████████████████████████████████   │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

**Colors:**
- Background: `#1C1C1C` (Dark charcoal)
- Foreground: `#E8A734` (Amber/Gold)
- All ANSI colors are amber variations for a monochromatic look

---

### 2. Pip-Boy (Fallout)

Inspired by the iconic Pip-Boy terminal from the Fallout video game series. Features the classic green phosphor look with a custom prompt showing system stats.

```
╔══════════════════════════════════════════════════════════════════════╗
║  ╔═══════╗  ╔═══════╗  ╔═══════╗  ╔═══════╗  ╔═══════╗              ║
║  ║ STAT  ║  ║  INV  ║  ║ DATA  ║  ║  MAP  ║  ║ RADIO ║              ║
║  ╚═══════╝  ╚═══════╝  ╚═══════╝  ╚═══════╝  ╚═══════╝              ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║                  ██████╗ ██╗██████╗       ██████╗  ██████╗ ██╗   ██╗ ║
║                  ██╔══██╗██║██╔══██╗      ██╔══██╗██╔═══██╗╚██╗ ██╔╝ ║
║                  ██████╔╝██║██████╔╝█████╗██████╔╝██║   ██║ ╚████╔╝  ║
║                  ██╔═══╝ ██║██╔═══╝ ╚════╝██╔══██╗██║   ██║  ╚██╔╝   ║
║                  ██║     ██║██║           ██████╔╝╚██████╔╝   ██║    ║
║                  ╚═╝     ╚═╝╚═╝           ╚═════╝  ╚═════╝    ╚═╝    ║
║                                                                      ║
║                              ,---.                                   ║
║                             /     \                                  ║
║                             | o o |                                  ║
║                             |  >  |                                  ║
║                              \___/                                   ║
║                             /|   |\                                  ║
║                            / |   | \                                 ║
║                               | |                                    ║
║                              /   \                                   ║
║                                                                      ║
║                           user@hostname                              ║
║                                                                      ║
╠══════════════════════════════════════════════════════════════════════╣
║  CPU  15%  [====-----------]  MEM  42%  [=======---------]  DISK 67% ║
╠══════════════════════════════════════════════════════════════════════╣
║  BATT 100%            UPTIME 3 days, 4:20                            ║
╚══════════════════════════════════════════════════════════════════════╝
```

**Colors:**
- Background: `#0A1410` (Dark greenish black)
- Foreground: `#1AFF59` (Pip-Boy green)
- All ANSI colors are green variations

**Features:**
- Full Pip-Boy interface on terminal start
- Live system stats (CPU, Memory, Disk, Battery, Uptime)
- Custom prompt with system monitoring

---

## Installation

### Color Themes

#### Option 1: Double-click (Easiest)
Simply double-click on any `.itermcolors` file to import it automatically.

#### Option 2: Manual Import
1. Open iTerm2
2. Go to `Settings` → `Profiles` → `Colors`
3. Click `Color Presets...` → `Import...`
4. Select the `.itermcolors` file
5. Select the theme from `Color Presets...`

### Pip-Boy Prompt (Optional)

The Pip-Boy theme includes a custom shell prompt with system stats.

**For Zsh (default on macOS):**

```bash
# Add to your ~/.zshrc
source /path/to/nice-iterm2/pipboy-prompt.sh
```

**For Bash:**

```bash
# Add to your ~/.bashrc
source /path/to/nice-iterm2/pipboy-prompt.sh
```

Then reload your shell:
```bash
source ~/.zshrc  # or ~/.bashrc
```

---

## Commands (Pip-Boy Theme)

| Command | Description |
|---------|-------------|
| `pipboy` | Display full Pip-Boy interface |
| `vault` | Alias for `pipboy` |
| `stats` | Show system statistics |

---

## System Stats Displayed

Instead of HP/Level/AP from the game, the prompt shows real system metrics:

| Stat | Description |
|------|-------------|
| **CPU** | Current CPU usage percentage |
| **MEM** | RAM usage percentage |
| **DISK** | Disk usage percentage |
| **BATT** | Battery level (or "AC" if plugged in) |
| **UPTIME** | System uptime |

---

## Recommended Fonts

For the best experience, use a monospace font with good Unicode support:

- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- [Fira Code](https://github.com/tonsky/FiraCode)
- [SF Mono](https://developer.apple.com/fonts/)
- [Hack](https://sourcefoundry.org/hack/)

---

## Compatibility

- **macOS**: Full support
- **Linux**: Supported (some stats may vary)
- **Shells**: Zsh, Bash

---

## File Structure

```
nice-iterm2/
├── README.md
├── RetroAmber.itermcolors    # Amber phosphor theme
├── PipBoy.itermcolors        # Fallout Pip-Boy green theme
└── pipboy-prompt.sh          # Custom prompt with Vault Boy & stats
```

---

## License

MIT License - Feel free to use, modify, and share!

---

## Contributing

Found a bug or want to add a new theme? PRs are welcome!

---

Made with terminal love by [@eyrockscript](https://github.com/eyrockscript)
