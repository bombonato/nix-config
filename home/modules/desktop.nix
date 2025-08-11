# { pkgs, config, ... }: {
{ pkgs, ... }:
{

  home.packages = with pkgs; [
    nerd-fonts.fira-code

    ghostty # terminal
  ];

  xdg = {
    enable = true;

    # Definitions of standard locations for 
    # common folders in Windows environments
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "$HOME/desktop";
      documents = "$HOME/docs";
      download = "$HOME/downloads";
      music = "$HOME/audio";
      pictures = "$HOME/images";
      publicShare = "$HOME/public";
      templates = "$HOME/templates";
      videos = "$HOME/videos";
    };
    # mimeApps = {
    #     enable = true;
    #     defaultApplications = {
    #         "image/gif" = "imv-dir.desktop";
    #         "image/jpeg" = "imv-dir.desktop";
    #         "image/png" = "imv-dir.desktop";
    #         "image/webp" = "imv-dir.desktop";
    #         "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
    #         "text/html" = "librewolf.desktop";
    #         "text/xml" = "librewolf.desktop";
    #         "application/rdf+xml" = "librewolf.desktop";
    #         "application/rss+xml" = "librewolf.desktop";
    #         "application/xhtml+xml" = "librewolf.desktop";
    #         "application/xhtml_xml" = "librewolf.desktop";
    #         "application/xml" = "librewolf.desktop";
    #         "x-scheme-handler/http" = "librewolf.desktop";
    #         "x-scheme-handler/https" = "librewolf.desktop";
    #         "x-scheme-handler/ipfs" = "librewolf.desktop";
    #         "x-scheme-handler/ipns" = "librewolf.desktop";
    #         "x-scheme-handler/about" = "librewolf.desktop";
    #         "x-scheme-handler/unknown" = "librewolf.desktop";
    #         "x-scheme-handler/vscodium" = [
    #             "codium-url-handler.desktop"
    #             "codium.desktop"
    #         ];
    #         "x-scheme-handler/mailto" = "thunderbird.desktop";
    #         "message/rfc822" = "thunderbird.desktop";
    #         "x-scheme-handler/mid" = "thunderbird.desktop";
    #         "font/otf" = "org.gnome.font-viewer.desktop";
    #         "video/mkv" = "mpv.desktop";
    #     };
    # };
  };

}
