open Alcotest
open Lwt.Infix

let mock_fetch_price ~symbol = 
        Lwt.return (if symbol = "AAPL" then "145.09" else "dont know")
        
let test_bad_symbol () = 
        let symbol = "" in
        let expected_price = "dont know" in

        let result = mock_fetch_price ~symbol >>= fun price ->
                check string "should say dont know right" expected_price price;
                Lwt.return ()
        in
        Lwt_main.run result

let test_happy_path () = 
        let symbol = "AAPL" in
        let expected_price = "145.09" in

        let result = mock_fetch_price ~symbol >>= fun price ->
                check string "should be 145.09 right" expected_price price;
                Lwt.return ()
        in
        Lwt_main.run result

let () = 
        let open Alcotest in
        run "alpha api" [
                "fetch price", [
                        test_case "Test fetching aapl on happy path" `Quick
                        test_happy_path;
                ];
                "fetch bad symbol", [
                        test_case "Test fetching bad symbol" `Quick
                        test_bad_symbol;
                ];
        ]
