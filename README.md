# JMTech Zsh Theme

A multi-line zsh theme with Git integration and command status indicators.

## Features

- Multi-line prompt with clean, modern aesthetics
- Path truncation
- Comprehensive Git status information:
  - Branch name
  - Staged, unstaged, and untracked changes
  - Stash count
  - Ahead/behind status
  - GPG signing information
- Command execution status with visual indicators
- Timestamp reflects when each command is executed
- Cached Git operations for better performance
- Customizable colors and symbols

## Preview

![JMTech Zsh Theme Screenshot](docs/screenshots/jmtech-zsh-theme-1.png)

## Requirements

- Zsh
- Oh My Zsh framework
- A [Nerd Font](https://www.nerdfonts.com/) for Git status icons (recommended)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/jmaaltech/jmtech-zsh-theme.git
   cd jmtech-zsh-theme
   ```

2. Run the installation script:
   ```bash
   ./scripts/install.sh
   ```

3. Set the following in your ~/.zshrc:
   ```bash
   ZSH_THEME="jmtech"
   ```
   
   **Note: For terminals without Nerd Fonts, add `export JMTECH_USE_NERD_FONTS="false"` before the theme setting**

4. Restart your terminal or reload your cofiguration:
   ```bash
   source ~/.zshrc
   ```

## Customization

You can customize the theme by modifying the following files:

- `lib/config.zsh`: Colors, symbols, and general settings.
- `lib/path.zsh`: Path display preferences.
- `lib/git.zsh`: Git integration.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Created by jmaaltech.