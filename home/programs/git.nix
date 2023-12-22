{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "Will Lucas";
    userEmail = "mevatron@gmail.com";
  };
}