{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-wsl/modules>
    ./mainmenu.nix
    ./podman.nix  # We link the new file here
    ./var.nix # Env variables
    ./pkgs.nix
    ./tmux.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  boot.kernelModules = [ "nbd" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.nixos = {
    isNormalUser = true; 
    extraGroups = [ "podman" "wheel" ];
  };

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
  #libguestfs-with-appliance
  tmux
  #micro
  #yazi ## Disabled
  wget
  #bottom ## Disabled
  git
  #qemu-utils ## found in pkgs.nix
  #ranger ## Found in pkgs.nix
  inotify-tools
  btop
  #kmscon ## Disabled
  #zellij ## Disabled
  ];
#  ## // KSCON ##
#  services.kmscon = {
#  enable = true;
#  hwRender = true; # Enables GPU acceleration for smooth emoji/font rendering
#  fonts = [
#    {
#      name = "JetBrainsMono Nerd Font";
#      package = pkgs.nerd-fonts.jetbrains-mono;
#    }
#  ];
#  # Ensure your user has the rights to use the terminal
#  extraConfig = ''
#    font-size=14
#    xkb-layout=us
#  '';
#  };
#  ## KSCON // ##
  
  system.stateVersion = "24.11";
}
