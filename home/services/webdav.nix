{ pkgs, config, lib, ... }:
{
  home.packages = [ pkgs.davfs2 ];

  # Ensure the directory exists (home-manager might create parent dirs, but symlink source handles the file)
  # davfs2 also checks for config file.
  
  home.file.".davfs2/davfs2.conf".text = ''
    use_locks 0
  '';
}
