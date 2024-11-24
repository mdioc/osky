module Json = struct
  open Yojson.Basic.Util

  type auth = { accessJwt : string } (*; refreshJwt : string }*)

  let decode_auth json_string =
    let json = json_string |> Yojson.Basic.from_string in
    { accessJwt =
        json |> member "accessJwt" |> to_string
        (*refreshJwt = json |> member "refreshJwt" |> to_string;*)
    }
  ;;

  let decode_prefs json_string =
    json_string
    |> Yojson.Basic.from_string
    |> member "preferences"
    |> to_list
    |> filter_member "items"
    |> flatten
    |> filter_member "value"
    |> filter_string
  ;;
end
