open Core
open Osky.Config
open Osky.Feeds
open Osky.Auth

let () =
  Eio_main.run (fun env ->
    Eio.Switch.run (fun sw ->
      let config = Config.load_config () in
      let jwt = Auth.start env sw config in
      let feeds = Feeds.get_feeds env sw jwt in
      match feeds with
      | Some posts ->
        List.iter
          ~f:(fun post ->
            print_endline "---------------------------------";
            Printf.printf
              "Post: %s\n\nAuthor: %s\n\nCreated At: %s\n"
              post.text
              post.author
              post.created_at)
          posts
      | None -> print_endline "none"))
;;
