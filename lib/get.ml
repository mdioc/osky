module Get = struct
  open Core
  open Piaf

  type request =
    { headers : (string * string) list
    ; url : string
    }

  let create_request url = { headers = [ "Content-Type", "application/json" ]; url }

  let add_header header request =
    { headers = header :: request.headers; url = request.url }
  ;;

  let add_auth bearer request =
    request |> add_header ("authorization", String.concat ~sep:" " [ "Bearer"; bearer ])
  ;;

  let add_query_param param request =
    if String.contains request.url '?'
    then
      { headers = request.headers; url = String.concat ~sep:"&" [ request.url; param ] }
    else
      { headers = request.headers
      ; url = String.append (String.append request.url "?") param
      }
  ;;

  let send env ~sw get_request =
    match
      Client.Oneshot.get
        ~sw
        env
        ~headers:get_request.headers
        (Uri.of_string get_request.url)
    with
    | Ok response ->
      if Status.is_successful response.status
      then Body.to_string response.body
      else Error (`Msg (Status.to_string response.status))
    | Error e -> failwith (Error.to_string e)
  ;;
end
