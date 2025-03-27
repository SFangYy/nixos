{
  colorSchemes = [
    {
      name = "gruvbox-material-dark-soft";
      isDefault = true;
    }
    "everforest"
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
