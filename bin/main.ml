open Core
open Osky.Post
open Osky.Get
open Osky.Json
open Osky.Config

let () =
  Eio_main.run (fun env ->
    Eio.Switch.run (fun sw ->
      let config = Config.load_config () in
      let auth_post =
        Post.create_request
          config
          "https://bsky.social/xrpc/com.atproto.server.createSession"
      in
      let jwt =
        match Post.send env ~sw auth_post with
        | Ok body -> (body |> Json.decode_auth).accessJwt
        | Error _ -> "request failed"
      in
      let get_request =
        Get.create_request "https://bsky.social/xrpc/app.bsky.actor.getPreferences"
        |> Get.add_header ("authorization", String.concat ~sep:"" [ "Bearer "; jwt ])
      in
      match Get.send env ~sw get_request with
      | Ok prefs -> List.iter ~f:print_endline (Json.decode_prefs prefs)
      | Error e -> prerr_endline (Piaf.Error.to_string e)))
;;
