{
 description = "Roger's NixOS config";

 inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager = {
   url = "github:nix-community/home-manager/master";
   inputs.nixpkgs.follows = "nixpkgs";
  };
  hyprland = {
   url = "github:hyprwm/Hyprland";
  };
  nixvim = {
   url = "github:nix-community/nixvim";
   inputs.nixpkgs.follows = "nixpkgs";
  };
  nur = {
   url = "github:nix-community/NUR";
   inputs.nixpkgs.follows = "nixpkgs";
  };
 };

 outputs = {
  self,
  nixpkgs,
  home-manager,
  hyprland,
  nixvim,
  nur,
  ...
 }@inputs: {
  nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
   system = "x86_64-linux";
   specialArgs = { inherit inputs; };
   modules = [
    { nixpkgs.overlays = [ nur.overlays.default ]; }
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    { 
     home-manager.useGlobalPkgs = true;
     home-manager.useUserPackages = true;
     home-manager.users.roger = import ./home.nix;
     home-manager.extraSpecialArgs = {
      inherit inputs;
     };
     home-manager.sharedModules = [
      nixvim.homeModules.nixvim
     ];
    }
   ];
  };
 };
}
