open Cmdliner
open Cmdliner.Term.Syntax
open Lwt.Infix

let view ~symbol = 
        let _ = Dotenv.export () in
        match Sys.getenv_opt "ALPHA_KEY" with
        | Some api_key ->
                        let main = 
                                Alpha_api.fetch_price ~api_key ~symbol >|= fun
                                        price ->
                                print_endline ("price of " ^
                                symbol ^ " is " ^ price)
                        in
                        Lwt_main.run main
        | None ->
                print_string "fatal: no api key; check your .env\n"

let symbol =
        let doc = "Which stock to take a look at" in
        let docv = "SYMBOL" in
        Arg.(required & pos ~rev:true 0 (some string) None & info [] ~docv ~doc)

let view_cmd =
        let doc = "look up a stock" in
        let man = [
                `S Manpage.s_bugs;
                `P "Email bug reports to <dev@null.org>." ]
        in
                Cmd.v (Cmd.info "mechant" ~version:"%%VERSION%%" ~doc ~man) @@
        let+ symbol in
                view ~symbol 

let main () = Cmd.eval view_cmd
let () = if !Sys.interactive then () else exit (main ())
