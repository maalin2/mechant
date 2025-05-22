open Alcotest
open Lwt.Infix

let mock_fetch_price ~symbol = 
        let json = 
                if symbol = "AAPL" then
                        {|{"Global Quote": {"01. symbol": "AAPL", "05. price":
                                "145.09"}}|}
                else
                        {|{"Global Quote": {}}|}
        in
        Lwt.return json

let parse_price ~json_str =
        try
                let json = Yojson.Safe.from_string json_str in 
                let open Yojson.Safe.Util in 
                let price = json
                        |> member "Global Quote"
                        |> member "05. price"
                        |> to_string_option
        in
        match price with
                | Some p -> Ok p
                | None -> Error "price field missing"
        with _ -> Error "invalid JSON"

        
let test_bad_symbol () = 
        let symbol = "AAAPL" in
        let expected_error = "price field missing" in

        let result = 
                mock_fetch_price ~symbol >>= fun json ->
                match parse_price ~json_str:json with
                | Ok price -> 
                                Alcotest.fail ("expected error, but got price:  "
                                ^ price) 
                | Error msg ->
                        Alcotest.check string "should fail with bad symbol"
                        expected_error msg;
                        Lwt.return ()
        in
        Lwt_main.run result

let test_empty_symbol () = 
        let symbol = "" in
        let expected_error = "price field missing" in

        let result = 
                mock_fetch_price ~symbol >>= fun json ->
                match parse_price ~json_str:json with
                | Ok price -> 
                                Alcotest.fail ("expected error, but got price:  "
                                ^ price) 
                | Error msg ->
                        Alcotest.check string "should fail with bad symbol"
                        expected_error msg;
                        Lwt.return ()
        in
        Lwt_main.run result

let test_happy_path () = 
        let symbol = "AAPL" in
        let expected_price = "145.09" in

        let result = 
                mock_fetch_price ~symbol >>= fun json ->
                match parse_price ~json_str:json with
                | Ok price -> 
                        Alcotest.check string "should be 145.09
                        right" expected_price price;
                        Lwt.return ()
                | Error msg ->
                        Alcotest.fail ("unexpected err" ^ msg)
        in
        Lwt_main.run result

let () = 
        let open Alcotest in
        run "alpha api" [
                "fetch price", [
                        test_case "Test fetching aapl on happy path" `Quick
                        test_happy_path;
                ];
                "fetch empty symbol", [
                        test_case "Test fetching empty symbol" `Quick
                        test_empty_symbol;
                ];
                "fetch bad symbol", [
                        test_case "Test fetching invalid symbol" `Quick
                        test_bad_symbol;
                ];
        ]
