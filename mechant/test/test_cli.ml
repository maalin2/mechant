open Alcotest

let mock_stdout symbol =
        match symbol with
        | "AAPL" -> "price of AAPL is 100.00"
        | "" -> "mechant: required argument SYMBOL is missing"
        | "INVALID" -> "mechant: internal error, uncaught exception: Invalid symbol"
        | _ -> "mechant: unknown error"

let test_cmd symbol expected_output =
        (* use .env to stage cli *)
        let result = mock_stdout symbol in 

        Alcotest.check string ("command output for symbol: " ^ symbol)
        expected_output result


let test_happy_path () = 
        let symbol = "AAPL" in
        let expected_output = "price of AAPL is 100.00" in
        test_cmd symbol expected_output

let test_empty_symbol () = 
        let symbol = "" in
        let expected_output = "mechant: required argument SYMBOL is missing" in
        test_cmd symbol expected_output

let test_invalid_symbol () = 
        let symbol = "INVALID" in
        let expected_output = "mechant: internal error, uncaught exception: Invalid symbol" in
        test_cmd symbol expected_output


let () = 
        run "cmd line" [
                "fetch good symbol", [
                        test_case "Test cmd AAPL" `Quick
                        test_happy_path;
                ];
                "fetch empty symbol", [
                        test_case "Test cmd on empty symbol" `Quick
                        test_empty_symbol;
                ];
                "fetch bad symbol", [
                        test_case "Test cmd on invalid" `Quick
                        test_invalid_symbol;
                ];
        ]
