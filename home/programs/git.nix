{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "Will Lucas";
        email = "mevatron@gmail.com";
      };
    };
  };
}