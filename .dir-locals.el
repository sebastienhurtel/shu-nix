((nix-mode
  . ((eglot-workspace-configuration
      . (:nixpkgs
         (:expr "import (builtins.getFlake \"/home/sebastien/.dotfiles/\").inputs.nixpkgs { }")
         :options
         (:nixos
          (:expr "(builtins.getFlake \"/home/sebastien/.dotfiles\").nixosConfigurations.squarepusher.options")
          :home-manager
          (:expr "(builtins.getFlake \"/home/sebastien/.dotfiles\").nixosConfigurations.squarepusher.options.home-manager.users.type.getSubOptions [ ]")
          :flake-parts
          (:expr "(builtins.getFlake \"/home/sebastien/.dotfiles\").currentSystem.options")))))))
