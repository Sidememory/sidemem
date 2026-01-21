{ pkgs, ... }:

{
  environment.variables = {
    LIBGUESTFS_BACKEND = "direct";
  };
}
