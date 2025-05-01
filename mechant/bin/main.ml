open Cohttp_lwt_unix
open Lwt.Infix

let () = 
        Dotenv.export ~debug: true () |> ignore;
        let symbol = "AAPL" in
        match Sys.getenv_opt "ALPHA_KEY" with
                | Some api_key ->
                        begin
                                let url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" ^ symbol ^ "&apikey=" ^ api_key in
                                print_endline ("url below\n" ^ url);

                                let main =
                                        Client.get (Uri.of_string url) >>= fun (_, body) ->
                                        body |> Cohttp_lwt.Body.to_string >|= fun body_str ->
                                        print_endline ("body\n" ^ body_str)
                                in
                                Lwt_main.run main
                        end
                | None ->
                        print_string "no api key\n"
