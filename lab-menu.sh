#!/usr/bin/env bash
# ~/lab/lab-menu.sh - Amber Master Switchboard

AMBER='\033[38;5;214m'
RESET='\033[0m'

LAB_DIR="$HOME/lab"
DEPARTMENTS=("labs" "tools" "diag")

echo -e "${AMBER}🧊 SOVEREIGN LAB v3: DISCOVERY HUB${RESET}"
echo "--------------------------------------"

# 1. Select Department
echo -e "${AMBER}Select Department:${RESET}"
select DEPT in "${DEPARTMENTS[@]}" "Exit"; do
    [[ "$DEPT" == "Exit" ]] && exit 0
    if [[ -d "$LAB_DIR/$DEPT" ]]; then break; fi
done

# 2. Select Script (Recursive discovery for tools/fridge etc)
echo -e "\n${AMBER}Select $DEPT Logic:${RESET}"
# find all .sh files, excluding the scripts themselves from being recursive targets
FILES=$(find "$LAB_DIR/$DEPT" -name "*.sh")

if [ -z "$FILES" ]; then
    echo "No scripts found in $DEPT"
    exit 1
fi

if command -v gum &> /dev/null; then
    SELECTED=$(echo "$FILES" | sed "s|$LAB_DIR/||" | gum choose)
else
    # Simple numbered list fallback
    PS3="Run which logic? "
    select OPT in $(echo "$FILES" | sed "s|$LAB_DIR/||"); do
        SELECTED=$OPT
        break
    done
fi

# 3. Execution Bridge
if [ -n "$SELECTED" ]; then
    echo -e "${AMBER}▶ Executing $SELECTED...${RESET}"
    bash "$LAB_DIR/$SELECTED"
fi