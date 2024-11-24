module Get = struct
  open Piaf

  type request =
    { headers : (string * string) list
    ; url : string
    }

  let create_request url = { headers = [ "Content-Type", "application/json" ]; url }

  let add_header header request =
    { headers = header :: request.headers; url = request.url }
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
