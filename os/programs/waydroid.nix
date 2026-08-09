{ pkgs, ... }:
{
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      substituteInPlace $out/lib/waydroid/data/scripts/waydroid-net.sh \
        --replace-fail 'LXC_USE_NFT="false"' 'LXC_USE_NFT="true"' \
        --replace-fail 'NFT="$(command -v nft)"' 'NFT="${pkgs.nftables}/bin/nft"' \
        --replace 'IPTABLES_BIN="$(command -v iptables-legacy)"' 'IPTABLES_BIN="${pkgs.iptables}/bin/iptables"' \
        --replace 'IP6TABLES_BIN="$(command -v ip6tables-legacy)"' 'IP6TABLES_BIN="${pkgs.iptables}/bin/ip6tables"' \
        --replace 'IP="$(command -v ip)"' 'IP="${pkgs.iproute2}/bin/ip"' \
        --replace 'modprobe' 'true'
    '';
  });

  environment.systemPackages = with pkgs; [
    android-tools
    git
    lzip
    nftables
    python3
    waydroid
  ];
}
