((nil
  . ((eglot-workspace-configuration
      . (:nixd
         (:nixpkgs
          (:expr "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }")
          :options
          (:nixos
           (:expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.squarepusher.options")
           :home-manager
           (:expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.squarepusher.options.home-manager.users.type.getSubOptions [ ]"))))))))
