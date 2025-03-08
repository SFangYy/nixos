{
  nixpkgs.overlays = [
    (final: prev: {
      cherry-studio = prev.cherry-studio.override {
        commandLineArgs = "--wayland-text-input-version=3";
      };
    })
  ];
}
