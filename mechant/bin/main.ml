open Lwt.Infix

let () = 
        Dotenv.export ~debug: true () |> ignore;
        match Sys.getenv_opt "ALPHA_KEY" with
                | Some api_key ->
                        let symbol = "AAPL" in
                        let main = 
                                Alpha_api.fetch_price ~api_key ~symbol >|= fun
                                        price ->
                                print_endline ("price of " ^ symbol ^ " is " ^
                                price)
                        in
                        Lwt_main.run main
                | None ->
                        print_string "no api key\n"
