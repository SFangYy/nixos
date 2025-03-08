let
  mkKeyBinding =
    {
      key,
      command,
      onRelease ? false,
      swallow ? true,
    }:
    let
      onReleasePrefix = if onRelease then "@" else "";
      swallowPrefix = if swallow then "" else "~";
    in
    ''
      ${onReleasePrefix}${swallowPrefix}${key}
              ${command}'';
  mkMode =
    {
      name,
      swallow ? true,
      oneoff ? false,
      keyBindings,
    }:
    let
      swallowStr = if swallow then "swallow" else "";
      oneoffStr = if oneoff then "oneoff" else "";
    in
    ''
      mode ${name} ${swallowStr} ${oneoffStr}
    ''
    + (map mkKeyBinding keyBindings |> builtins.concatStringsSep "\n")
    + ''
      \nendmode
    '';
  mkSwhkdrc =
    {
      keyBindings,
      includes ? [ ],
      ignores ? [ ],
      modes ? [ ],
      extraConfig ? '''',
    }:
    (
      (map (file: "include ${file}") includes)
      ++ (map (key: "ignore ${key}") ignores)
      ++ (map mkKeyBinding keyBindings)
      ++ (map mkMode modes)
      |> builtins.concatStringsSep "\n"
    )
    + extraConfig;
in
{
  config.lib.swhkd = { inherit mkSwhkdrc; };
}
