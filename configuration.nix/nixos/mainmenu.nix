{ pkgs, ... }:

let
  lab-menu = pkgs.writeShellScriptBin "lab-menu" ''
    say() { ${pkgs.espeak-ng}/bin/espeak-ng -p 40 -s 140 "$1" & }
    
    say "Welcome back. Choose your destination."

    while true; do
      CHOICE=$(${pkgs.gum}/bin/gum choose --header "🛸 SYSTEM COMMAND CENTER" \
        "🚀 Launch Pilot (Read-Only)" \
        "🧬 OpenCode Lab" \
        "📂 Browse Other Flakes" \
        "💻 Standard Terminal" \
        "❌ Exit Menu")

      case "$CHOICE" in
        "🚀 Launch Pilot (Read-Only)")
          say "Inserting cartridge. Launching pilot."
          # Direct Podman execution with the Sovereign flags
          ${pkgs.podman}/bin/podman run -it --rm \
            --name alpha_session \
            --hostname sovereign-pilot \
            --read-only \
            --tmpfs /tmp \
            --tmpfs /run \
            --tmpfs /home/pilot/.cache \
            -v ~/opencode-lab/sockets/workspace:/home/pilot/workspace:Z \
            -v ~/opencode-lab/sockets/brain:/home/pilot/.opencode:Z \
            localhost/opencode-agent /bin/bash
          ;;

        "🧬 OpenCode Lab")
          say "Materializing Open-Code environment."
          cd ~/opencode-lab && nix develop ;;
        
        "📂 Browse Other Flakes")
          FLAKE_DIR=$(find ~ -maxdepth 3 -name "flake.nix" -exec dirname {} \; | ${pkgs.fzf}/bin/fzf --header "Select a Lab")
          if [ -n "$FLAKE_DIR" ]; then
            cd "$FLAKE_DIR" && nix develop
          fi ;;

        "💻 Standard Terminal")
          break ;;

        "❌ Exit Menu")
          say "Goodbye."
          exit 0 ;;
      esac
    done
  '';
in
{
  environment.systemPackages = [ 
    lab-menu 
    pkgs.gum 
    pkgs.fzf 
    pkgs.espeak-ng 
    pkgs.podman # Ensure podman is available to the script
  ];

  programs.bash.interactiveShellInit = ''
    if [[ $- == *i* ]]; then
       # lab-menu
       echo "Type 'lab-menu' to enter your laboratories."
    fi
  '';
}
