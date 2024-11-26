module Feeds = struct
  open Core
  open Get
  open Json

  let filter_following ids =
    List.filter ~f:(fun id -> not (String.equal id "following")) ids
  ;;

  let append_feed_strings ids =
    List.map ~f:(fun id -> String.concat ~sep:"=" [ "feeds"; id ]) ids
  ;;

  let get_feed_ats env sw jwt =
    Get.create_request "https://bsky.social/xrpc/app.bsky.actor.getPreferences"
    |> Get.add_auth jwt
    |> Get.send env ~sw
  ;;

  let get_feed_generators env sw jwt ids =
    ids
    |> filter_following
    |> append_feed_strings
    |> List.fold
         ~init:
           (Get.create_request "https://bsky.social/xrpc/app.bsky.feed.getFeedGenerators")
         ~f:(fun req id -> Get.add_query_param id req)
    |> Get.add_auth jwt
    |> Get.send env ~sw
  ;;

  let get_feed env sw jwt id =
    Get.create_request "https://bsky.social/xrpc/app.bsky.feed.getFeed"
    |> Get.add_auth jwt
    |> Get.add_query_param (String.append "feed=" id)
    |> Get.send env ~sw
  ;;

  let get_feeds env sw jwt =
    match get_feed_ats env sw jwt with
    | Ok prefs ->
      (match get_feed env sw jwt (Json.decode_feed_ids prefs |> List.hd_exn) with
       | Ok feed -> Json.decode_feed feed
       | Error _e -> None)
    | Error _e -> None
  ;;
end
