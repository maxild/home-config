{ ... }:

# TODO: Add ~/.nix-profile to XDG_DATA_DIRS:
#     export XDG_DATA_DIRS=$USER/.nix-profile:$XDG_DATA_DIRS (TODO: handle empty case)
# You need to create a directory called applications, put your .desktop files in there,
# and then add the path of the parent directory of applications (not including the
# applications directory itself!) to the XDG_DATA_DIRS environment variable.
# Once you do that, your files will be picked up.
# IMPORTANT!!!
# It is important to note that the path needs to be added to this variable before
# your desktop manager is started. How this is accomplished will vary by distro and/or login manager.

# Alternatively, you can place your .desktop file at /usr/share/applications/ or
# at ~/.local/share/applications/.

# /usr/share/ubuntu:
# /usr/local/share/:      <----- /usr/local/share/applications (directory does not exist)
# /usr/share/:            <------/usr/share/applications (MANY .desktop files here)
# /var/lib/snapd/desktop

# TODO: 'open -n /Applications/Alacritty.app'
# key_bindings:
#   - { key: N,        mods: Command, command: { program: "open", args: ["-n", "/Applications/Alacritty.app"] } }
# Now, pressing Command + N will open a new window. It works how you'd expect,
# except that Command + Q will only kill one window (since each window is run as a
# separate desktop application).

# just a FYI, 'open -nb io.alacritty' doesn't need a hardcoded path to Alacritty.app
# (I'm using this now with an Alfred workflow)
# - { key: N,        mods: Command, command: { program: "open", args: ["-nb", "io.alacritty"] } }

# you can configure your alacritty to have a shortcut to spawn a new instance of
# alacritty. For example, in my alacritty.yml I have this
# key_bindings:
#   - { key: E,        mods: Control|Shift,    action: SpawnNewInstance    }
{
  programs.alacritty =
  {
    enable = true;
    # settings are written to ~/.config/alacritty/alacritty.yml as json?!?
    settings = {
      keybindings = [
        { key = "Equals";     mods = "Control";     action = "IncreaseFontSize"; }
        { key = "Add";        mods = "Control";     action = "IncreaseFontSize"; }
        { key = "Subtract";   mods = "Control";     action = "DecreaseFontSize"; }
        { key = "Minus";      mods = "Control";     action = "DecreaseFontSize"; }
      ];

      colors = {
        primary = {
          background =  "0x002b36";
          foreground =  "0xEBEBEB";
        };

        normal = {
          black =    "0x0d0d0d";
          red =      "0xFF301B";
          green =    "0xA0E521";
          yellow =   "0xFFC620";
          blue =     "0x1BA6FA";
          magenta =  "0x8763B8";
          cyan =     "0x21DEEF";
          white =    "0xEBEBEB";
        };

        bright = {
          black =    "0x6D7070";
          red =      "0xFF4352";
          green =    "0xB8E466";
          yellow =   "0xFFD750";
          blue =     "0x1BA6FA";
          magenta =  "0xA578EA";
          cyan =     "0x73FBF1";
          white =    "0xFEFEF8";
        };
      };
    };
  };
}
