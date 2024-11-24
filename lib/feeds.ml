module Feeds = struct
  open Core
  open Get
  open Json

  type feed = { location : string }
  type t = feed list

  let get_feeds env sw jwt =
    let get_request =
      Get.create_request "https://bsky.social/xrpc/app.bsky.actor.getPreferences"
      |> Get.add_header ("authorization", String.concat ~sep:" " [ "Bearer"; jwt ])
    in
    match Get.send env ~sw get_request with
    | Ok prefs -> List.iter ~f:print_endline (Json.decode_prefs prefs)
    | Error e -> prerr_endline (Piaf.Error.to_string e)
  ;;
end
