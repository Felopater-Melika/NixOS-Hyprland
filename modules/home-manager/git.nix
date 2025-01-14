{
  pkgs,
  config,
  inputs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Felopater-Melika";
    userEmail = "felopatermelika@gmail.com";
  };
}
