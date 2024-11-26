module Json = struct
  open Yojson.Basic.Util
  open Core

  type auth = { accessJwt : string } (*; refreshJwt : string }*)

  type extern =
    { uri : string
    ; title : string
    ; description : string
    }

  type image = { fullsize : string }
  type video = { playlist : string }

  (*type record = { }*)

  type embed =
    | External of extern
    | Image of image
    | Video of video
  (*| Record of record*)

  type post =
    { author : string
    ; created_at : string
    ; text : string (*; embed : embed*)
    }

  let decode_auth json_string =
    let json = json_string |> Yojson.Basic.from_string in
    { accessJwt =
        json |> member "accessJwt" |> to_string
        (*refreshJwt = json |> member "refreshJwt" |> to_string;*)
    }
  ;;

  let decode_feed_ids json_string =
    json_string
    |> Yojson.Basic.from_string
    |> member "preferences"
    |> to_list
    |> filter_member "items"
    |> flatten
    |> filter_member "value"
    |> filter_string
  ;;

  let decode_feed json_string =
    let posts = json_string |> Yojson.Basic.from_string |> member "feed" |> to_list in
    let get_author post =
      post |> member "post" |> member "author" |> member "handle" |> to_string
    in
    let get_created_at post =
      post |> member "post" |> member "record" |> member "createdAt" |> to_string
    in
    let get_text post =
      post |> member "post" |> member "record" |> member "text" |> to_string
    in
    List.iter ~f:(fun post -> print_endline (get_text post)) posts;
    Some
      (List.map
         ~f:(fun post ->
           { author = get_author post
           ; created_at = get_created_at post
           ; text = get_text post
           })
         posts)
  ;;
end
