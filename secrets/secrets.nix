let
  eden = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXeMZ+CkyITSuDSbt4T9uglVJvt+c75X4QPiX8iCFbx";
  eden-inspiron = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKqbqHz5O4f6nBoki57c6hekVqUiO4hvSb9k771i61YS";
in
{
  "siliconflow_token.age".publicKeys = [
    eden
    eden-inspiron
  ];
  "gemini_token.age".publicKeys = [
    eden
    eden-inspiron
  ];
  "deepseek_token.age".publicKeys = [
    eden
    eden-inspiron
  ];
  "zjuchat_token.age".publicKeys = [
    eden
    eden-inspiron
  ];
  "tavily_token.age".publicKeys = [
    eden
    eden-inspiron
  ];
  "zjuconnect_password.age".publicKeys = [
    eden
    eden-inspiron
  ];
}
