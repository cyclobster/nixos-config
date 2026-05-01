{
 description = "Roger's NixOS config";

 inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
 };

 outputs = { self, nixpkgs, ...}: {
  nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
   system = "x86_64-linux";
   modules = [
    ./configuration.nix
    ./hardware-configuration.nix
   ];
  };
 };
}
