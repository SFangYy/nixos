{
  age.identityPaths = [ "/home/sfangyy/.ssh/id_rsa" ];

  age.secrets = {
    github_token.file = ./github-token.age;
  };
}
