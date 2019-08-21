
let suites : Mt.pair_suites ref =  ref []

let test_id = ref 0

let eq loc x y : unit = Mt.eq_suites ~test_id loc  ~suites x y

let () = Mt.from_pair_suites __MODULE__ !suites