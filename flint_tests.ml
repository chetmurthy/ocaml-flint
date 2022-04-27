(* Copyright 2016 Chetan Murthy *)

open OUnit2

let all = "all_tests" >:::
  [
    "string->fmpzxx->string" >::
      (fun ctxt ->
        assert_equal "1" Ocaml_flint.("1" |> fmpzxx_of_string |> fmpzxx_to_string)
       ; let s = "24061467864032622473692149727991" in
         assert_equal s Ocaml_flint.(s |> fmpzxx_of_string |> fmpzxx_to_string)
      )
  ; "int->fmpzxx->int" >::
      (fun ctxt ->
        assert_equal "1" Ocaml_flint.(1 |> fmpzxx_of_uint |> fmpzxx_to_string)
       ; assert_equal "0" Ocaml_flint.(0 |> fmpzxx_of_uint |> fmpzxx_to_string)
      )
  ; "number_of_partitions" >::
      (fun ctxt ->
	assert_equal "24061467864032622473692149727991"
          Ocaml_flint.(1000L |> fmpzxx_number_of_partitions |> fmpzxx_to_string))
  ; "bits" >::
      (fun ctxt ->
	assert_equal 3 Ocaml_flint.(5 |> fmpzxx_of_uint |> fmpzxx_bits))
  ; "n_nextprime" >::
      (fun ctxt ->
        assert_equal 13L Ocaml_flint.(flint_n_nextprime 11L false)
      )
  ; "fmpzxx_modulo" >::
      (fun ctxt ->
        assert_equal 3L Ocaml_flint.(fmpzxx_to_uint64 (fmpzxx_modulo (fmpzxx_of_uint 7) (fmpzxx_of_uint 4)))
      )
  ]
  
(* Run the tests in test suite *)
let _ = 
  run_test_tt_main all
;;
