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

    isWsl = mkOption {
      type = types.bool;
      default = false;
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
    };

  };

}
