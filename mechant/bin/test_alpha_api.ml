open Alcotest
open Lwt.Infix

let mock_fetch_price ~symbol = 
        Lwt.return (if symbol = "AAPL" then "145.09" else "dont know")

let test_fetch_price () = 
        let symbol = "AAPL" in
        let expected_price = "145.09" in

        let result = mock_fetch_price ~symbol >>= fun price ->
                check string "should be 145.09 right" expected_price price;
                Lwt.return ()
        in
        Lwt_main.run result

let () = 
        let open Alcotest in
        run "alpha api calls" [
                "fetch price", [
                        test_case "Test fetching aapl" `Quick test_fetch_price;
                ];
        ]
