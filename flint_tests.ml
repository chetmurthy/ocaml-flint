(* Copyright 2016 Chetan Murthy *)

open OUnit2

let all = "all_tests" >:::
  [
    "partition" >::
      (fun ctxt ->
	assert_equal "24061467864032622473692149727991" (Ocaml_flint.flintstubs_partition 1000L))
  ; "string->fmpzxx->string" >::
      (fun ctxt ->
        assert_equal "1" Ocaml_flint.("1" |> fmpzxx_of_string |> fmpzxx_to_string)
       ; let s = "24061467864032622473692149727991" in
         assert_equal s Ocaml_flint.(s |> fmpzxx_of_string |> fmpzxx_to_string)
      )
  ; "number_of_partitions" >::
      (fun ctxt ->
	assert_equal "24061467864032622473692149727991"
          Ocaml_flint.(1000L |> fmpzxx_number_of_partitions |> fmpzxx_to_string))

  ]
  
(* Run the tests in test suite *)
let _ = 
  run_test_tt_main all
;;
