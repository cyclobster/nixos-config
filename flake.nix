{
 description = "Roger's NixOS config";

 inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager/master";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  hyprland.url = "github:hyprwm/Hyprland";
  hyprland.inputs.nixpkgs.follows = "nixpkgs";
 };

 outputs = {
  self,
  nixpkgs,
  home-manager,
  hyprland,
  ...
 }@inputs: {
  nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
   system = "x86_64-linux";
   modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    { 
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.roger = import ./home.nix;
    }
   ];
  };
 };
}
