{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Oh My Bash is not packaged by the pinned Nixpkgs release, so keep its
    # source pinned as a flake input and let Home Manager source it directly.
    oh-my-bash.url = "github:ohmybash/oh-my-bash";
    oh-my-bash.flake = false;
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs, oh-my-bash }:
    let
      # The one username line to change if this isn't your machine.
      # Change this if the machine uses a different username.
      user = "gnikesh";
    in
    {
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };

      homeConfigurations.linux-x86_64 = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit user;
          ohMyBash = oh-my-bash;
        };
        modules = [ ./home.nix ];
      };

      homeConfigurations.linux-aarch64 = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit user;
          ohMyBash = oh-my-bash;
        };
        modules = [ ./home.nix ];
      };
    };
}
