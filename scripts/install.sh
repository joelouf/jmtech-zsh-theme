#!/usr/bin/env bash

set -e

THEME_NAME="jmtech"
OHMYZSH="${ZSH:-$HOME/.oh-my-zsh}"
OHMYZSH_CUSTOM="${ZSH_CUSTOM:-$OHMYZSH/custom}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}=== JMTech Theme Installer ===${NC}"

if [ ! -d "$OHMYZSH" ]; then
  echo "Error: Cannot find Oh My Zsh in $OHMYZSH."
  echo "       Make sure Oh My Zsh is installed or set the \$ZSH variable."
  exit 1
fi

DEST_DIR="$OHMYZSH_CUSTOM/themes"
mkdir -p "$DEST_DIR"

echo -e "${BLUE}Installing JMTech theme to: $DEST_DIR${NC}"

cp -v "$SCRIPT_DIR/../src/${THEME_NAME}.zsh-theme" "$DEST_DIR/${THEME_NAME}.zsh-theme"
cp -rv "$SCRIPT_DIR/../src/lib" "$DEST_DIR/"

cat <<EOF

${GREEN}Installation complete!${NC}

${BLUE}Configuration Steps:${NC}

1) Open your ~/.zshrc file

2) ${GREEN}Optional:${NC} To use fallback Unicode symbols instead of Nerd Font icons,
   add the following ${GREEN}before${NC} the ZSH_THEME setting:
   ${GREEN}export JMTECH_USE_NERD_FONTS="false"${NC}

3) Apply the theme by setting:
   ${GREEN}ZSH_THEME="${THEME_NAME}"${NC}

4) Restart the terminal or reload zsh with:
   ${GREEN}source ~/.zshrc${NC}

Note: This theme uses Nerd Font icons by default. For the best experience:
- Install a Nerd Font from: https://www.nerdfonts.com
- Set it as your terminal font
- If you don't want to use Nerd Fonts, set JMTECH_USE_NERD_FONTS="false"

Enjoy!
EOF