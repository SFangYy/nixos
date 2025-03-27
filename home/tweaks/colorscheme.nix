{
  colorSchemes = [
    {
      name = "gruvbox-material-dark-soft";
      isDefault = true;
    }
    "everforest"
    {
      name = "frieren-butterflies-dark";
      fromImage = {
        enable = true;
        image = "frieren-butterflies.jpg";
        method = "hellwal";
      };
    }
    "petrichor-downpour"
    {
      name = "zzzzoka-gbc-dark";
      fromImage = {
        enable = true;
        image = "zzzzoka-gbc.jpg";
        method = "matugen";
        passthru.scheme = "scheme-expressive";
      };
    }
  ];
}
