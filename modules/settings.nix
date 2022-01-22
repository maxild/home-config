{ config, pkgs, lib, ...}:

{
  options.settings = with lib; {

    name = mkOption {
      default = "Morten Maxild";
      type = with types; uniq string;
    };
    username = mkOption {
      default = "maxfire";
      type = with types; uniq string;
    };

    host = {

      isHeadless = mkOption {
        type = types.bool;
        default = false;
        description = "Is this a headless host without a desktop environment?";
      };

      isWsl = mkOption {
        type = types.bool;
        default = false;
        description = "Is this a WSL host?";
      };

      isNixos = mkOption {
        type = types.bool;
        default = false;
        description = "Is this a NixOS host?";
      };
    };


    git = {
      username = mkOption {
        type = types.str;
        default = "maxild";
        example = "John-Doe";
        description = "Git username";
      };
      email = mkOption {
        type = types.str;
        default = "mmaxild@gmail.com";
        example = "john@doe.com";
        description = "Git email";
      };
      github_username = mkOption {
        type = types.str;
        default = "maxild";
        example = "john";
        description = "Github username";
      };
    };

  };

}
