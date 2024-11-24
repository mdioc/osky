module Config = struct
  open Core

  let load_config () = In_channel.read_all "config.json"
end
