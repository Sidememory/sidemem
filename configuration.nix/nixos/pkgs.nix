{ pkgs, ... }: {
  # General packages for TUI tools and Terminals
  environment.systemPackages = with pkgs; [
    neofetch
    foot
    alacritty
    wezterm
    superfile
    helix
    zenith
    kitty
    #  podman            # The Chassis engine ## found in configuration.nix already
    podman-tui        # TUI for manual container oversight
    inotify-tools     # For the real-time Fridge/Mirror triggers
    util-linux        # For 'mount -o loop' and 'truncate'
    e2fsprogs         # For 'mkfs.ext4' and 'fsck'
    gum               # For the Amber TUI menus (optional but recommended)
    fzf               # For the script discovery/wrangler
    zip               # For the Archive Fridge state
    libguestfs-with-appliance # For scientific disk image manipulation
    micro 
    #yazi ## Disabled
    #msedit ## found in configuration.nix already
    #wget ## found in configuration.nix already
    #bottom ## found in configuration.nix already
    #git ## found in configuration.nix already
    qemu-utils
    ranger
    #inotify-tools ## found in configuration.nix already
    #tmux ## found in configuration.nix already
    #btop ## found in configuration.nix already
    #kmscon ## Disabled 
    #zellij ## Disabled 
  ];

  #Optional: Add fonts here from previous steps if needed)
  fonts.packages = with pkgs; [
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
  ];

}

