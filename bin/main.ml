open Osky.Config
open Osky.Feeds
open Osky.Auth

let () =
  Eio_main.run (fun env ->
    Eio.Switch.run (fun sw ->
      let config = Config.load_config () in
      let jwt = Auth.start env sw config in
      let feeds = Feeds.get_feeds env sw jwt in
      feeds))
;;
