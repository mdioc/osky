module Auth = struct
  open Post
  open Json

  let start env sw config =
    let req =
      Post.create_request
        config
        "https://bsky.social/xrpc/com.atproto.server.createSession"
    in
    match Post.send env ~sw req with
    | Ok body -> (body |> Json.decode_auth).accessJwt
    | Error _ -> "Auth request failed"
  ;;
end
