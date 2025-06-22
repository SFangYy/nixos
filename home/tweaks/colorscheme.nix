{
  colorSchemes = [
    {
      name = "gruvbox-material-dark-soft";
      isDefault = true;
    }
    "everforest"
    "petrichor-downpour"
    {
      name = "celestia-lunar-dark";
      fromImage = {
        enable = true;
        image = "celestia-lunar.jpg";
        method = "matugen";
        passthru.scheme = "scheme-expressive";
      };
    }
  ];
}
