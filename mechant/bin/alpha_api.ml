open Cohttp_lwt_unix
open Yojson.Basic.Util
open Lwt.Infix

let build_url ~api_key ~symbol = 
        "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" ^
        symbol ^ "&apikey=" ^ api_key

let fetch_price ~api_key ~symbol = 
        let url = build_url ~api_key ~symbol in
        Client.get (Uri.of_string url) >>= fun (_, body) ->
        Cohttp_lwt.Body.to_string body >|= fun body_str ->

        (* json time *)
        let json = Yojson.Basic.from_string body_str in
        let global_quote = json |> member "Global Quote" in
        global_quote |> member "05. price" |> to_string

