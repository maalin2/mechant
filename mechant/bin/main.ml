let () = 
        let env = Dotenv.parse ~debug: true () in
        List.iter (fun (name, value) -> 
                print_endline (Printf.sprintf "%s=%s" name value)
        ) env;
