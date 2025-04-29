let () = 
        print_endline "Hello, World!";
        let env = Dotenv.parse() in
        List.iter (fun (name, value) -> 
                print_endline (Printf.sprintf "%s=%s" name value)
        ) env
