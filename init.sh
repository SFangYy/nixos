mkfs.fat -F 32 -n EFI /dev/nvme0n1p1
mkfs.xfs -L NIXOS /dev/nvme0n1p2

mount /dev/disk/by-label/NIXOS /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/EFI /mnt/boot

nixos-generate-config --dir /mnt/etc/nixos/hosts/aesthetic --force

rm -rf /mnt/etc/nixos/hosts/aesthetic/configuration.nix

export NIX_CONFIG="experimental-features = nix-command flakes pipe-operators"

nixos-rebuild switch --flake .#inspiron
cd mnt/etc/nixos/