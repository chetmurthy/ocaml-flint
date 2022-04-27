(* Copyright 2016 Chetan Murthy *)

open OUnit2

let all = "all_tests" >:::
  [
    "partition" >::
      (fun ctxt ->
	assert_equal "24061467864032622473692149727991" (Ocaml_flint.flintstubs_partition 1000L))
  ]
  
(* Run the tests in test suite *)
let _ = 
  run_test_tt_main all
;;
