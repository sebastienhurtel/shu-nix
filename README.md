# shu's dotfiles

NixOS configuration for multiple hosts, built around a modular options-based pattern.
No external frameworks — plain Nix all the way down.

## Design

All configuration is expressed as NixOS modules exposing options under the `shu.*` namespace.
A host module is a pure declaration: it only sets `shu.*` options, never raw NixOS config.
The flake wires everything together by importing `./modules` (all option definitions) and
`./hosts/<hostname>` (the host's declaration) into each `nixosSystem` call.

Home-manager runs as a NixOS module. Modules that need both a system-level and user-level
configuration (e.g. Hyprland, Stylix) are co-located in a single file under `modules/`.

### Adding a new host

1. Create `hosts/<name>/default.nix` declaring `shu.*` options
2. Create `hosts/<name>/hardware.nix` with hardware-specific config
3. Add `nixosConfigurations.<name>` in `flake.nix`

### Adding a new module

1. Create `modules/<category>/<name>.nix` with `options.shu.<category>.<name>.enable`
2. Import it from the relevant `modules/<category>/default.nix`

## Structure

```
.
├── flake.nix                   # Composition root
├── overlays/
│   ├── default.nix             # Entry point: inputs: final: prev: ...
│   └── unstable.nix            # Exposes pkgs.unstable
├── derivations/                # Custom packages (called via callPackage)
│   └── default.nix
├── hosts/
│   ├── squarepusher/           # Thinkpad Z13 Gen2, Hyprland
│   │   ├── default.nix         # Host declaration (shu.* options only)
│   │   ├── hardware.nix        # Hardware, filesystems, boot
│   │   └── system.nix          # Host-specific system config
│   ├── aphex/
│   └── deftones/
├── modules/
│   ├── default.nix             # Imports all categories
│   ├── system/                 # Base system config (timezone, nix settings...)
│   ├── users/                  # Per-user account definitions
│   ├── wm/                     # Window manager (Hyprland, Gnome, Stylix)
│   ├── services/               # System services (Plex, Syncthing, NFS...)
│   └── home/                   # Home-manager modules (shell, git, editor...)
├── secrets/                    # agenix encrypted secrets
└── wallpaper.png
```

## Hosts

| Hostname | Hardware | WM | Users |
|---|---|---|---|
| squarepusher | Lenovo ThinkPad Z13 Gen2 | Hyprland | sebastien |
| aphex | — | — | — |
| deftones | — | — | — |

---

*Architected in discussion with [Claude](https://claude.ai) (Anthropic), who contributed ideas, spotted bugs, and provided code snippets that may or may not have been copy-pasted. The music taste remains entirely shu's.*
