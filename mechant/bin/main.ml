let () = 
        Dotenv.export ~debug: true () |> ignore;
        let symbol = "AAPL" in
        match Sys.getenv_opt "ALPHA_KEY" with
        | Some api_key ->
                let url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" ^ symbol ^ "&apikey=" ^ api_key in
                print_endline ("url below\n" ^ url)
        | None ->
                print_string "no api key\n"
