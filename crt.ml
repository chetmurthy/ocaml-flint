open Ocaml_flint

let main () =
  if Array.length Sys.argv < 2 then
    failwith "Syntax: crt <integer>\n" ;
  let x = ref (fmpzxx_of_string Sys.argv.(1)) in
  let bit_bound = fmpzxx_bits !x in
  let y = ref (fmpzxx_of_uint 0) in
  let prod = ref (fmpzxx_of_uint 1) in
  let prime = ref 0L in
  let rec looprec i = 
    if fmpzxx_bits !prod < bit_bound then begin
        prime := flint_n_nextprime !prime false ;
        let res = fmpzxx_to_uint64 (fmpzxx_modulo !x (fmpzxx_of_uint64 !prime)) in
        y := fmpzxx_crt !y !prod res !prime true;
        Printf.printf "residue mod %Ld = %Ld" !prime res;
        Printf.printf "; reconstruction = %s\n%!" (fmpzxx_to_string !y) ;
        prod := fmpzxx_mul_uint64 !prod !prime;
        looprec (i+1)
      end
  in looprec 0
;;

if not !Sys.interactive then
main() ;;
