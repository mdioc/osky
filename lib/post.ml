module Post = struct
  open Piaf

  type request =
    { headers : (string * string) list
    ; body : string
    ; url : string
    }

  let create_request body url =
    { headers = [ "Content-Type", "application/json" ]; body; url }
  ;;

  let add_header header request =
    { headers = header :: request.headers; body = request.body; url = request.url }
  ;;

  let send env ~sw post_request =
    match
      Client.Oneshot.post
        ~headers:post_request.headers
        ~body:(Body.of_string post_request.body)
        ~sw
        env
        (Uri.of_string post_request.url)
    with
    | Ok response ->
      if Status.is_successful response.status
      then Body.to_string response.body
      else Error (`Msg (Status.to_string response.status))
    | Error e -> failwith (Error.to_string e)
  ;;
end
