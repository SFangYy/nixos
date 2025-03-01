{
  nixpkgs.overlays = [
    (_: prev: { qutebrowser = prev.qutebrowser.override { enableWideVine = true; }; })
  ];
}
