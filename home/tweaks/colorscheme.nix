{
  colorSchemes = [
    {
      name = "gruvbox-material-dark-soft";
      isDefault = true;
    }
    "everforest"
    "petrichor-downpour"
    {
      name = "frieren-butterflies-dark";
      fromImage = {
        enable = true;
        image = "frieren-butterflies.jpg";
        method = "matugen";
        passthru.scheme = "scheme-expressive";
      };
    }
  ];
}
