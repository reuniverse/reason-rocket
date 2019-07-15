module Bsb_dir_index : sig 
#1 "bsb_dir_index.mli"
(* Copyright (C) 2017 Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

(** Used to index [.bsbuildcache] may not be needed if we flatten dev 
  into  a single group
*)
type t = private int

val lib_dir_index : t 

val is_lib_dir : t -> bool 

val get_dev_index : unit -> t 

val of_int : int -> t 

val get_current_number_of_dev_groups : unit -> int 


val string_of_bsb_dev_include : t -> string 

(** TODO: Need reset
   when generating each ninja file to provide stronger guarantee. 
   Here we get a weak guarantee because only dev group is 
  inside the toplevel project
   *)
val reset : unit -> unit
end = struct
#1 "bsb_dir_index.ml"
(* Copyright (C) 2017 Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

type t = int 

(** 
   0 : lib 
   1 : dev 1 
   2 : dev 2 
*)  
external of_int : int -> t = "%identity"
let lib_dir_index = 0

let is_lib_dir x = x = lib_dir_index

let dir_index = ref 0 

let get_dev_index ( ) = 
  incr dir_index ; !dir_index

let get_current_number_of_dev_groups =
   (fun () -> !dir_index )


(** bsb generate pre-defined variables [bsc_group_i_includes]
  for each rule, there is variable [bsc_extra_excludes]
  [g_dev_incls] are for app test etc
  it will be like
  {[
    g_dev_incls = ${bsc_group_1_includes}
  ]}
  where [bsc_group_1_includes] will be pre-calcuated
*)
let bsc_group_1_includes = "bsc_group_1_includes"
let bsc_group_2_includes = "bsc_group_2_includes"
let bsc_group_3_includes = "bsc_group_3_includes"
let bsc_group_4_includes = "bsc_group_4_includes"
let string_of_bsb_dev_include i = 
  match i with 
  | 1 -> bsc_group_1_includes 
  | 2 -> bsc_group_2_includes
  | 3 -> bsc_group_3_includes
  | 4 -> bsc_group_4_includes
  | _ -> 
    "bsc_group_" ^ string_of_int i ^ "_includes"


let reset () = dir_index := 0
end
module Ext_array : sig 
#1 "ext_array.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)






(** Some utilities for {!Array} operations *)
val reverse_range : 'a array -> int -> int -> unit
val reverse_in_place : 'a array -> unit
val reverse : 'a array -> 'a array 
val reverse_of_list : 'a list -> 'a array

val filter : ('a -> bool) -> 'a array -> 'a array

val filter_map : ('a -> 'b option) -> 'a array -> 'b array

val range : int -> int -> int array

val map2i : (int -> 'a -> 'b -> 'c ) -> 'a array -> 'b array -> 'c array

val to_list_f : ('a -> 'b) -> 'a array -> 'b list 
val to_list_map : ('a -> 'b option) -> 'a array -> 'b list 

val to_list_map_acc : 
  'a array -> 
  'b list -> 
  ('a -> 'b option) -> 
  'b list 

val of_list_map : 
  'a list -> 
  ('a -> 'b) -> 
  'b array 

val rfind_with_index : 'a array -> ('a -> 'b -> bool) -> 'b -> int


type 'a split = [ `No_split | `Split of 'a array * 'a array ]

val rfind_and_split : 
  'a array ->
  ('a -> 'b -> bool) ->
  'b -> 'a split

val find_and_split : 
  'a array ->
  ('a -> 'b -> bool) ->
  'b -> 'a split

val exists : ('a -> bool) -> 'a array -> bool 

val is_empty : 'a array -> bool 

val for_all2_no_exn : 
  'a array ->
  'b array -> 
  ('a -> 'b -> bool) -> 
  bool

val map :   
  'a array -> 
  ('a -> 'b) -> 
  'b array

val iter :
  'a array -> 
  ('a -> unit) -> 
  unit

val fold_left :   
  'b array -> 
  'a -> 
  ('a -> 'b -> 'a) ->   
  'a
end = struct
#1 "ext_array.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)





let reverse_range a i len =
  if len = 0 then ()
  else
    for k = 0 to (len-1)/2 do
      let t = Array.unsafe_get a (i+k) in
      Array.unsafe_set a (i+k) ( Array.unsafe_get a (i+len-1-k));
      Array.unsafe_set a (i+len-1-k) t;
    done


let reverse_in_place a =
  reverse_range a 0 (Array.length a)

let reverse a =
  let b_len = Array.length a in
  if b_len = 0 then [||] else  
    let b = Array.copy a in  
    for i = 0 to  b_len - 1 do
      Array.unsafe_set b i (Array.unsafe_get a (b_len - 1 -i )) 
    done;
    b  

let reverse_of_list =  function
  | [] -> [||]
  | hd::tl as l ->
    let len = List.length l in
    let a = Array.make len hd in
    let rec fill i = function
      | [] -> a
      | hd::tl -> Array.unsafe_set a (len - i - 2) hd; fill (i+1) tl in
    fill 0 tl

let filter f a =
  let arr_len = Array.length a in
  let rec aux acc i =
    if i = arr_len 
    then reverse_of_list acc 
    else
      let v = Array.unsafe_get a i in
      if f  v then 
        aux (v::acc) (i+1)
      else aux acc (i + 1) 
  in aux [] 0


let filter_map (f : _ -> _ option) a =
  let arr_len = Array.length a in
  let rec aux acc i =
    if i = arr_len 
    then reverse_of_list acc 
    else
      let v = Array.unsafe_get a i in
      match f  v with 
      | Some v -> 
        aux (v::acc) (i+1)
      | None -> 
        aux acc (i + 1) 
  in aux [] 0

let range from to_ =
  if from > to_ then invalid_arg "Ext_array.range"  
  else Array.init (to_ - from + 1) (fun i -> i + from)

let map2i f a b = 
  let len = Array.length a in 
  if len <> Array.length b then 
    invalid_arg "Ext_array.map2i"  
  else
    Array.mapi (fun i a -> f i  a ( Array.unsafe_get b i )) a 

let rec tolist_f_aux a f  i res =
  if i < 0 then res else
    let v = Array.unsafe_get a i in
    tolist_f_aux a f  (i - 1)
      (f v :: res)
       
let to_list_f f a = tolist_f_aux a f (Array.length a  - 1) []

let rec tolist_aux a f  i res =
  if i < 0 then res else
    let v = Array.unsafe_get a i in
    tolist_aux a f  (i - 1)
      (match f v with
       | Some v -> v :: res
       | None -> res) 

let to_list_map f a = 
  tolist_aux a f (Array.length a - 1) []

let to_list_map_acc a acc f = 
  tolist_aux a f (Array.length a - 1) acc


let of_list_map a f = 
  match a with 
  | [] -> [||]
  | [a0] -> 
    let b0 = f a0 in
    [|b0|]
  | [a0;a1] -> 
    let b0 = f a0 in  
    let b1 = f a1 in 
    [|b0;b1|]
  | [a0;a1;a2] -> 
    let b0 = f a0 in  
    let b1 = f a1 in 
    let b2 = f a2 in  
    [|b0;b1;b2|]
  | [a0;a1;a2;a3] -> 
    let b0 = f a0 in  
    let b1 = f a1 in 
    let b2 = f a2 in  
    let b3 = f a3 in 
    [|b0;b1;b2;b3|]
  | [a0;a1;a2;a3;a4] -> 
    let b0 = f a0 in  
    let b1 = f a1 in 
    let b2 = f a2 in  
    let b3 = f a3 in 
    let b4 = f a4 in 
    [|b0;b1;b2;b3;b4|]

  | a0::a1::a2::a3::a4::tl -> 
    let b0 = f a0 in  
    let b1 = f a1 in 
    let b2 = f a2 in  
    let b3 = f a3 in 
    let b4 = f a4 in 
    let len = List.length tl + 5 in 
    let arr = Array.make len b0  in
    Array.unsafe_set arr 1 b1 ;  
    Array.unsafe_set arr 2 b2 ;
    Array.unsafe_set arr 3 b3 ; 
    Array.unsafe_set arr 4 b4 ; 
    let rec fill i = function
      | [] -> arr 
      | hd :: tl -> 
        Array.unsafe_set arr i (f hd); 
        fill (i + 1) tl in 
    fill 5 tl

(**
   {[
     # rfind_with_index [|1;2;3|] (=) 2;;
     - : int = 1
               # rfind_with_index [|1;2;3|] (=) 1;;
     - : int = 0
               # rfind_with_index [|1;2;3|] (=) 3;;
     - : int = 2
               # rfind_with_index [|1;2;3|] (=) 4;;
     - : int = -1
   ]}
*)
let rfind_with_index arr cmp v = 
  let len = Array.length arr in 
  let rec aux i = 
    if i < 0 then i
    else if  cmp (Array.unsafe_get arr i) v then i
    else aux (i - 1) in 
  aux (len - 1)

type 'a split = [ `No_split | `Split of 'a array * 'a array ]
let rfind_and_split arr cmp v : _ split = 
  let i = rfind_with_index arr cmp v in 
  if  i < 0 then 
    `No_split 
  else 
    `Split (Array.sub arr 0 i , Array.sub arr  (i + 1 ) (Array.length arr - i - 1 ))


let find_with_index arr cmp v = 
  let len  = Array.length arr in 
  let rec aux i len = 
    if i >= len then -1 
    else if cmp (Array.unsafe_get arr i ) v then i 
    else aux (i + 1) len in 
  aux 0 len

let find_and_split arr cmp v : _ split = 
  let i = find_with_index arr cmp v in 
  if i < 0 then 
    `No_split
  else
    `Split (Array.sub arr 0 i, Array.sub arr (i + 1 ) (Array.length arr - i - 1))        

(** TODO: available since 4.03, use {!Array.exists} *)

let exists p a =
  let n = Array.length a in
  let rec loop i =
    if i = n then false
    else if p (Array.unsafe_get a i) then true
    else loop (succ i) in
  loop 0


let is_empty arr =
  Array.length arr = 0


let rec unsafe_loop index len p xs ys  = 
  if index >= len then true
  else 
    p 
      (Array.unsafe_get xs index)
      (Array.unsafe_get ys index) &&
    unsafe_loop (succ index) len p xs ys 

let for_all2_no_exn xs ys p = 
  let len_xs = Array.length xs in 
  let len_ys = Array.length ys in 
  len_xs = len_ys &&    
  unsafe_loop 0 len_xs p xs ys


let map a f =
  let open Array in 
  let l = length a in
  if l = 0 then [||] else begin
    let r = make l (f(unsafe_get a 0)) in
    for i = 1 to l - 1 do
      unsafe_set r i (f(unsafe_get a i))
    done;
    r
  end

let iter a f =
  let open Array in 
  for i = 0 to length a - 1 do f(unsafe_get a i) done


  let fold_left a x f =
    let open Array in 
    let r = ref x in    
    for i = 0 to length a - 1 do
      r := f !r (unsafe_get a i)
    done;
    !r
  
end
module Ext_bytes : sig 
#1 "ext_bytes.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)







(** Port the {!Bytes.escaped} from trunk to make it not locale sensitive *)

val escaped : bytes -> bytes

end = struct
#1 "ext_bytes.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)








external char_code: char -> int = "%identity"
external char_chr: int -> char = "%identity"

let escaped s =
  let n = Pervasives.ref 0 in
  for i = 0 to Bytes.length s - 1 do
    n := !n +
      (match Bytes.unsafe_get s i with
       | '"' | '\\' | '\n' | '\t' | '\r' | '\b' -> 2
       | ' ' .. '~' -> 1
       | _ -> 4)
  done;
  if !n = Bytes.length s then Bytes.copy s else begin
    let s' = Bytes.create !n in
    n := 0;
    for i = 0 to Bytes.length s - 1 do
      begin match Bytes.unsafe_get s i with
      | ('"' | '\\') as c ->
          Bytes.unsafe_set s' !n '\\'; incr n; Bytes.unsafe_set s' !n c
      | '\n' ->
          Bytes.unsafe_set s' !n '\\'; incr n; Bytes.unsafe_set s' !n 'n'
      | '\t' ->
          Bytes.unsafe_set s' !n '\\'; incr n; Bytes.unsafe_set s' !n 't'
      | '\r' ->
          Bytes.unsafe_set s' !n '\\'; incr n; Bytes.unsafe_set s' !n 'r'
      | '\b' ->
          Bytes.unsafe_set s' !n '\\'; incr n; Bytes.unsafe_set s' !n 'b'
      | (' ' .. '~') as c -> Bytes.unsafe_set s' !n c
      | c ->
          let a = char_code c in
          Bytes.unsafe_set s' !n '\\';
          incr n;
          Bytes.unsafe_set s' !n (char_chr (48 + a / 100));
          incr n;
          Bytes.unsafe_set s' !n (char_chr (48 + (a / 10) mod 10));
          incr n;
          Bytes.unsafe_set s' !n (char_chr (48 + a mod 10));
      end;
      incr n
    done;
    s'
  end

end
module Ext_char : sig 
#1 "ext_char.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)






(** Extension to Standard char module, avoid locale sensitivity *)

val escaped : char -> string


val valid_hex : char -> bool

val is_lower_case : char -> bool

val uppercase_ascii : char -> char

val lowercase_ascii : char -> char
end = struct
#1 "ext_char.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)





(** {!Char.escaped} is locale sensitive in 4.02.3, fixed in the trunk,
    backport it here
 *)

module Unsafe = struct 
    external bytes_unsafe_set : string -> int -> char -> unit
                           = "%string_unsafe_set"
    external string_create: int -> string = "caml_create_string"
    external unsafe_chr: int -> char = "%identity"
end 
let escaped ch = 
  let open Unsafe in 
  match ch with 
  | '\'' -> "\\'"
  | '\\' -> "\\\\"
  | '\n' -> "\\n"
  | '\t' -> "\\t"
  | '\r' -> "\\r"
  | '\b' -> "\\b"
  | ' ' .. '~' as c ->
      let s = string_create 1 in
      bytes_unsafe_set s 0 c;
      s
  | c ->
      let n = Char.code c in
      let s = string_create 4 in
      bytes_unsafe_set s 0 '\\';
      bytes_unsafe_set s 1 (unsafe_chr (48 + n / 100));
      bytes_unsafe_set s 2 (unsafe_chr (48 + (n / 10) mod 10));
      bytes_unsafe_set s 3 (unsafe_chr (48 + n mod 10));
      s


let valid_hex x = 
    match x with 
    | '0' .. '9'
    | 'a' .. 'f'
    | 'A' .. 'F' -> true
    | _ -> false 



let is_lower_case c =
  (c >= 'a' && c <= 'z')
  || (c >= '\224' && c <= '\246')
  || (c >= '\248' && c <= '\254')    
let uppercase_ascii =

    Char.uppercase
      

let lowercase_ascii = 

    Char.lowercase
      

end
module Ext_pervasives : sig 
#1 "ext_pervasives.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)








(** Extension to standard library [Pervavives] module, safe to open 
  *)

external reraise: exn -> 'a = "%reraise"

val finally : 'a -> ('a -> 'c) -> ('a -> 'b) -> 'b

val try_it : (unit -> 'a) ->  unit 

val with_file_as_chan : string -> (out_channel -> 'a) -> 'a

val with_file_as_pp : string -> (Format.formatter -> 'a) -> 'a

val is_pos_pow : Int32.t -> int

val failwithf : loc:string -> ('a, unit, string, 'b) format4 -> 'a

val invalid_argf : ('a, unit, string, 'b) format4 -> 'a

val bad_argf : ('a, unit, string, 'b) format4 -> 'a




external id : 'a -> 'a = "%identity"

(** Copied from {!Btype.hash_variant}:
    need sync up and add test case
 *)
val hash_variant : string -> int

val todo : string -> 'a


end = struct
#1 "ext_pervasives.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)






external reraise: exn -> 'a = "%reraise"

let finally v action f   = 
  match f v with
  | exception e -> 
      action v ;
      reraise e 
  | e ->  action v ; e 

let try_it f  =   
  try ignore (f ()) with _ -> ()

let with_file_as_chan filename f = 
  finally (open_out_bin filename) close_out f 

let with_file_as_pp filename f = 
  finally (open_out_bin filename) close_out
    (fun chan -> 
      let fmt = Format.formatter_of_out_channel chan in
      let v = f  fmt in
      Format.pp_print_flush fmt ();
      v
    ) 


let  is_pos_pow n = 
  let module M = struct exception E end in 
  let rec aux c (n : Int32.t) = 
    if n <= 0l then -2 
    else if n = 1l then c 
    else if Int32.logand n 1l =  0l then   
      aux (c + 1) (Int32.shift_right n 1 )
    else raise M.E in 
  try aux 0 n  with M.E -> -1

let failwithf ~loc fmt = Format.ksprintf (fun s -> failwith (loc ^ s))
    fmt
    
let invalid_argf fmt = Format.ksprintf invalid_arg fmt

let bad_argf fmt = Format.ksprintf (fun x -> raise (Arg.Bad x ) ) fmt

external id : 'a -> 'a = "%identity"


let hash_variant s =
  let accu = ref 0 in
  for i = 0 to String.length s - 1 do
    accu := 223 * !accu + Char.code s.[i]
  done;
  (* reduce to 31 bits *)
  accu := !accu land (1 lsl 31 - 1);
  (* make it signed for 64 bits architectures *)
  if !accu > 0x3FFFFFFF then !accu - (1 lsl 31) else !accu

let todo loc = 
  failwith (loc ^ " Not supported yet")


end
module Ext_string : sig 
#1 "ext_string.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)








(** Extension to the standard library [String] module, fixed some bugs like
    avoiding locale sensitivity *) 

(** default is false *)    
val split_by : ?keep_empty:bool -> (char -> bool) -> string -> string list


(** remove whitespace letters ('\t', '\n', ' ') on both side*)
val trim : string -> string 


(** default is false *)
val split : ?keep_empty:bool -> string -> char -> string list

(** split by space chars for quick scripting *)
val quick_split_by_ws : string -> string list 



val starts_with : string -> string -> bool

(**
   return [-1] when not found, the returned index is useful 
   see [ends_with_then_chop]
*)
val ends_with_index : string -> string -> int

val ends_with : string -> string -> bool

(**
  [ends_with_then_chop name ext]
  @example:
   {[
     ends_with_then_chop "a.cmj" ".cmj"
     "a"
   ]}
   This is useful in controlled or file case sensitve system
*)
val ends_with_then_chop : string -> string -> string option


val escaped : string -> string

(**
  [for_all_from  s start p]
  if [start] is negative, it raises,
  if [start] is too large, it returns true
*)
val for_all_from:
  string -> 
  int -> 
  (char -> bool) -> 
  bool 

val for_all : 
  string -> 
  (char -> bool) -> 
  bool

val is_empty : string -> bool

val repeat : int -> string -> string 

val equal : string -> string -> bool

(**
  [extract_until s cursor sep]
   When [sep] not found, the cursor is updated to -1,
   otherwise cursor is increased to 1 + [sep_position]
   User can not determine whether it is found or not by
   telling the return string is empty since 
   "\n\n" would result in an empty string too.
*)
val extract_until:
  string -> 
  int ref -> (* cursor to be updated *)
  char -> 
  string

val index_count:  
  string -> 
  int ->
  char -> 
  int -> 
  int 

(**
  [find ~start ~sub s]
  returns [-1] if not found
*)
val find : ?start:int -> sub:string -> string -> int

val contain_substring : string -> string -> bool 

val non_overlap_count : sub:string -> string -> int 

val rfind : sub:string -> string -> int

(** [tail_from s 1]
  return a substring from offset 1 (inclusive)
*)
val tail_from : string -> int -> string


(** returns negative number if not found *)
val rindex_neg : string -> char -> int 

val rindex_opt : string -> char -> int option

type check_result = 
    | Good | Invalid_module_name | Suffix_mismatch

val is_valid_source_name :
   string -> check_result





val no_char : string -> char -> int -> int -> bool 


val no_slash : string -> bool 

(** return negative means no slash, otherwise [i] means the place for first slash *)
val no_slash_idx : string -> int 

val no_slash_idx_from : string -> int -> int 

(** if no conversion happens, reference equality holds *)
val replace_slash_backward : string -> string 

(** if no conversion happens, reference equality holds *)
val replace_backward_slash : string -> string 

val empty : string 


external compare : string -> string -> int = "caml_string_length_based_compare" "noalloc";;
  
val single_space : string

val concat3 : string -> string -> string -> string 
val concat4 : string -> string -> string -> string -> string 
val concat5 : string -> string -> string -> string -> string -> string  
val inter2 : string -> string -> string
val inter3 : string -> string -> string -> string 
val inter4 : string -> string -> string -> string -> string
val concat_array : string -> string array -> string 

val single_colon : string 

val parent_dir_lit : string
val current_dir_lit : string

val capitalize_ascii : string -> string

val capitalize_sub:
  string -> 
  int -> 
  string
  
val uncapitalize_ascii : string -> string

val lowercase_ascii : string -> string 
end = struct
#1 "ext_string.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)







(*
   {[ split " test_unsafe_obj_ffi_ppx.cmi" ~keep_empty:false ' ']}
*)
let split_by ?(keep_empty=false) is_delim str =
  let len = String.length str in
  let rec loop acc last_pos pos =
    if pos = -1 then
      if last_pos = 0 && not keep_empty then

        acc
      else 
        String.sub str 0 last_pos :: acc
    else
    if is_delim str.[pos] then
      let new_len = (last_pos - pos - 1) in
      if new_len <> 0 || keep_empty then 
        let v = String.sub str (pos + 1) new_len in
        loop ( v :: acc)
          pos (pos - 1)
      else loop acc pos (pos - 1)
    else loop acc last_pos (pos - 1)
  in
  loop [] len (len - 1)

let trim s = 
  let i = ref 0  in
  let j = String.length s in 
  while !i < j &&  
        let u = String.unsafe_get s !i in 
        u = '\t' || u = '\n' || u = ' ' 
  do 
    incr i;
  done;
  let k = ref (j - 1)  in 
  while !k >= !i && 
        let u = String.unsafe_get s !k in 
        u = '\t' || u = '\n' || u = ' ' do 
    decr k ;
  done;
  String.sub s !i (!k - !i + 1)

let split ?keep_empty  str on = 
  if str = "" then [] else 
    split_by ?keep_empty (fun x -> (x : char) = on) str  ;;

let quick_split_by_ws str : string list = 
  split_by ~keep_empty:false (fun x -> x = '\t' || x = '\n' || x = ' ') str

let starts_with s beg = 
  let beg_len = String.length beg in
  let s_len = String.length s in
  beg_len <=  s_len &&
  (let i = ref 0 in
   while !i <  beg_len 
         && String.unsafe_get s !i =
            String.unsafe_get beg !i do 
     incr i 
   done;
   !i = beg_len
  )

let rec ends_aux s end_ j k = 
  if k < 0 then (j + 1)
  else if String.unsafe_get s j = String.unsafe_get end_ k then 
    ends_aux s end_ (j - 1) (k - 1)
  else  -1   

(** return an index which is minus when [s] does not 
    end with [beg]
*)
let ends_with_index s end_ : int = 
  let s_finish = String.length s - 1 in
  let s_beg = String.length end_ - 1 in
  if s_beg > s_finish then -1
  else
    ends_aux s end_ s_finish s_beg

let ends_with s end_ = ends_with_index s end_ >= 0 

let ends_with_then_chop s beg = 
  let i =  ends_with_index s beg in 
  if i >= 0 then Some (String.sub s 0 i) 
  else None

let check_suffix_case = ends_with 
let check_suffix_case_then_chop = ends_with_then_chop

let check_any_suffix_case s suffixes = 
  List.exists (fun x -> check_suffix_case s x) suffixes

let check_any_suffix_case_then_chop s suffixes = 
  let rec aux suffixes = 
    match suffixes with 
    | [] -> None 
    | x::xs -> 
      let id = ends_with_index s x in 
      if id >= 0 then Some (String.sub s 0 id)
      else aux xs in 
  aux suffixes    



(**  In OCaml 4.02.3, {!String.escaped} is locale senstive, 
     this version try to make it not locale senstive, this bug is fixed
     in the compiler trunk     
*)
let escaped s =
  let rec needs_escape i =
    if i >= String.length s then false else
      match String.unsafe_get s i with
      | '"' | '\\' | '\n' | '\t' | '\r' | '\b' -> true
      | ' ' .. '~' -> needs_escape (i+1)
      | _ -> true
  in
  if needs_escape 0 then
    Bytes.unsafe_to_string (Ext_bytes.escaped (Bytes.unsafe_of_string s))
  else
    s

(* it is unsafe to expose such API as unsafe since 
   user can provide bad input range 

*)
let rec unsafe_for_all_range s ~start ~finish p =     
  start > finish ||
  p (String.unsafe_get s start) && 
  unsafe_for_all_range s ~start:(start + 1) ~finish p

let for_all_from s start  p = 
  let len = String.length s in 
  if start < 0  then invalid_arg "Ext_string.for_all_from"
  else unsafe_for_all_range s ~start ~finish:(len - 1) p 


let for_all s (p : char -> bool)  =   
  unsafe_for_all_range s ~start:0  ~finish:(String.length s - 1) p 

let is_empty s = String.length s = 0


let repeat n s  =
  let len = String.length s in
  let res = Bytes.create(n * len) in
  for i = 0 to pred n do
    String.blit s 0 res (i * len) len
  done;
  Bytes.to_string res

let equal (x : string) y  = x = y



let unsafe_is_sub ~sub i s j ~len =
  let rec check k =
    if k = len
    then true
    else 
      String.unsafe_get sub (i+k) = 
      String.unsafe_get s (j+k) && check (k+1)
  in
  j+len <= String.length s && check 0


exception Local_exit 
let find ?(start=0) ~sub s =
  let n = String.length sub in
  let s_len = String.length s in 
  let i = ref start in  
  try
    while !i + n <= s_len do
      if unsafe_is_sub ~sub 0 s !i ~len:n then
        raise_notrace Local_exit;
      incr i
    done;
    -1
  with Local_exit ->
    !i

let contain_substring s sub = 
  find s ~sub >= 0 

(** TODO: optimize 
    avoid nonterminating when string is empty 
*)
let non_overlap_count ~sub s = 
  let sub_len = String.length sub in 
  let rec aux  acc off = 
    let i = find ~start:off ~sub s  in 
    if i < 0 then acc 
    else aux (acc + 1) (i + sub_len) in
  if String.length sub = 0 then invalid_arg "Ext_string.non_overlap_count"
  else aux 0 0  


let rfind ~sub s =
  let n = String.length sub in
  let i = ref (String.length s - n) in
  let module M = struct exception Exit end in 
  try
    while !i >= 0 do
      if unsafe_is_sub ~sub 0 s !i ~len:n then 
        raise_notrace Local_exit;
      decr i
    done;
    -1
  with Local_exit ->
    !i

let tail_from s x = 
  let len = String.length s  in 
  if  x > len then invalid_arg ("Ext_string.tail_from " ^s ^ " : "^ string_of_int x )
  else String.sub s x (len - x)

let equal (x : string) y  = x = y

let rec index_rec s lim i c =
  if i >= lim then -1 else
  if String.unsafe_get s i = c then i 
  else index_rec s lim (i + 1) c

let rec index_rec_count s lim i c count =
  if i >= lim then -1 else
  if String.unsafe_get s i = c then 
    if count = 1 then i 
    else index_rec_count s lim (i + 1) c (count - 1)
  else index_rec_count s lim (i + 1) c count

let index_count s i c count =     
  let lim = String.length s in 
  if i < 0 || i >= lim || count < 1 then 
    Ext_pervasives.invalid_argf "index_count: (%d,%d)"  i count;

  index_rec_count s lim i c count 
let extract_until s cursor c =       
  let len = String.length s in   
  let start = !cursor in 
  if start < 0 || start >= len then (
    cursor := -1;
    ""
    )
  else 
    let i = index_rec s len start c in   
    let finish = 
      if i < 0 then (      
        cursor := -1 ;
        len 
      )
      else (
        cursor := i + 1;
        i 
      ) in 
    String.sub s start (finish - start)
  
let rec rindex_rec s i c =
  if i < 0 then i else
  if String.unsafe_get s i = c then i else rindex_rec s (i - 1) c;;

let rec rindex_rec_opt s i c =
  if i < 0 then None else
  if String.unsafe_get s i = c then Some i else rindex_rec_opt s (i - 1) c;;

let rindex_neg s c = 
  rindex_rec s (String.length s - 1) c;;

let rindex_opt s c = 
  rindex_rec_opt s (String.length s - 1) c;;

let is_valid_module_file (s : string) = 
  let len = String.length s in 
  len > 0 &&
  match String.unsafe_get s 0 with 
  | 'A' .. 'Z'
  | 'a' .. 'z' -> 
    unsafe_for_all_range s ~start:1 ~finish:(len - 1)
      (fun x -> 
         match x with 
         | 'A'..'Z' | 'a'..'z' | '0'..'9' | '_' | '\'' -> true
         | _ -> false )
  | _ -> false 




type check_result = 
  | Good 
  | Invalid_module_name 
  | Suffix_mismatch
  (** 
     TODO: move to another module 
     Make {!Ext_filename} not stateful
  *)
let is_valid_source_name name : check_result =
  match check_any_suffix_case_then_chop name [
      ".ml"; 
      ".re";
      ".mli"; 
      ".rei"
    ] with 
  | None -> Suffix_mismatch
  | Some x -> 
    if is_valid_module_file  x then
      Good
    else Invalid_module_name  

(** TODO: can be improved to return a positive integer instead *)
let rec unsafe_no_char x ch i  last_idx = 
  i > last_idx  || 
  (String.unsafe_get x i <> ch && unsafe_no_char x ch (i + 1)  last_idx)

let rec unsafe_no_char_idx x ch i last_idx = 
  if i > last_idx  then -1 
  else 
  if String.unsafe_get x i <> ch then 
    unsafe_no_char_idx x ch (i + 1)  last_idx
  else i

let no_char x ch i len  : bool =
  let str_len = String.length x in 
  if i < 0 || i >= str_len || len >= str_len then invalid_arg "Ext_string.no_char"   
  else unsafe_no_char x ch i len 


let no_slash x = 
  unsafe_no_char x '/' 0 (String.length x - 1)

let no_slash_idx x = 
  unsafe_no_char_idx x '/' 0 (String.length x - 1)

let no_slash_idx_from x from = 
  let last_idx = String.length x - 1  in 
  assert (from >= 0); 
  unsafe_no_char_idx x '/' from last_idx

let replace_slash_backward (x : string ) = 
  let len = String.length x in 
  if unsafe_no_char x '/' 0  (len - 1) then x 
  else 
    String.map (function 
        | '/' -> '\\'
        | x -> x ) x 

let replace_backward_slash (x : string)=
  let len = String.length x in
  if unsafe_no_char x '\\' 0  (len -1) then x 
  else  
    String.map (function 
        |'\\'-> '/'
        | x -> x) x

let empty = ""

    
external compare : string -> string -> int = "caml_string_length_based_compare" "noalloc";;

let single_space = " "
let single_colon = ":"

let concat_array sep (s : string array) =   
  let s_len = Array.length s in 
  match s_len with 
  | 0 -> empty 
  | 1 -> Array.unsafe_get s 0
  | _ ->     
    let sep_len = String.length sep in 
    let len = ref 0 in 
    for i = 0 to  s_len - 1 do 
      len := !len + String.length (Array.unsafe_get s i)
    done;
    let target = 
      Bytes.create 
        (!len + (s_len - 1) * sep_len ) in    
    let hd = (Array.unsafe_get s 0) in     
    let hd_len = String.length hd in 
    String.unsafe_blit hd  0  target 0 hd_len;   
    let current_offset = ref hd_len in     
    for i = 1 to s_len - 1 do 
      String.unsafe_blit sep 0 target  !current_offset sep_len;
      let cur = Array.unsafe_get s i in 
      let cur_len = String.length cur in     
      let new_off_set = (!current_offset + sep_len ) in
      String.unsafe_blit cur 0 target new_off_set cur_len; 
      current_offset := 
        new_off_set + cur_len ; 
    done;
    Bytes.unsafe_to_string target   

let concat3 a b c = 
  let a_len = String.length a in 
  let b_len = String.length b in 
  let c_len = String.length c in 
  let len = a_len + b_len + c_len in 
  let target = Bytes.create len in 
  String.unsafe_blit a 0 target 0 a_len ; 
  String.unsafe_blit b 0 target a_len b_len;
  String.unsafe_blit c 0 target (a_len + b_len) c_len;
  Bytes.unsafe_to_string target

let concat4 a b c d =
  let a_len = String.length a in 
  let b_len = String.length b in 
  let c_len = String.length c in 
  let d_len = String.length d in 
  let len = a_len + b_len + c_len + d_len in 

  let target = Bytes.create len in 
  String.unsafe_blit a 0 target 0 a_len ; 
  String.unsafe_blit b 0 target a_len b_len;
  String.unsafe_blit c 0 target (a_len + b_len) c_len;
  String.unsafe_blit d 0 target (a_len + b_len + c_len) d_len;
  Bytes.unsafe_to_string target


let concat5 a b c d e =
  let a_len = String.length a in 
  let b_len = String.length b in 
  let c_len = String.length c in 
  let d_len = String.length d in 
  let e_len = String.length e in 
  let len = a_len + b_len + c_len + d_len + e_len in 

  let target = Bytes.create len in 
  String.unsafe_blit a 0 target 0 a_len ; 
  String.unsafe_blit b 0 target a_len b_len;
  String.unsafe_blit c 0 target (a_len + b_len) c_len;
  String.unsafe_blit d 0 target (a_len + b_len + c_len) d_len;
  String.unsafe_blit e 0 target (a_len + b_len + c_len + d_len) e_len;
  Bytes.unsafe_to_string target



let inter2 a b = 
  concat3 a single_space b 


let inter3 a b c = 
  concat5 a  single_space  b  single_space  c 





let inter4 a b c d =
  concat_array single_space [| a; b ; c; d|]


let parent_dir_lit = ".."    
let current_dir_lit = "."


(* reference {!Bytes.unppercase} *)
let capitalize_ascii (s : string) : string = 
  if String.length s = 0 then s 
  else 
    begin
      let c = String.unsafe_get s 0 in 
      if (c >= 'a' && c <= 'z')
      || (c >= '\224' && c <= '\246')
      || (c >= '\248' && c <= '\254') then 
        let uc = Char.unsafe_chr (Char.code c - 32) in 
        let bytes = Bytes.of_string s in
        Bytes.unsafe_set bytes 0 uc;
        Bytes.unsafe_to_string bytes 
      else s 
    end

let capitalize_sub (s : string) len : string = 
  let slen = String.length s in 
  if  len < 0 || len > slen then invalid_arg "Ext_string.capitalize_sub"
  else 
  if len = 0 then ""
  else 
    let bytes = Bytes.create len in 
    let uc = 
      let c = String.unsafe_get s 0 in 
      if (c >= 'a' && c <= 'z')
      || (c >= '\224' && c <= '\246')
      || (c >= '\248' && c <= '\254') then 
        Char.unsafe_chr (Char.code c - 32) else c in 
    Bytes.unsafe_set bytes 0 uc;
    for i = 1 to len - 1 do 
      Bytes.unsafe_set bytes i (String.unsafe_get s i)
    done ;
    Bytes.unsafe_to_string bytes 

    

let uncapitalize_ascii =

    String.uncapitalize
      





let lowercase_ascii (s : string) = 
    Bytes.unsafe_to_string 
      (Bytes.map Ext_char.lowercase_ascii (Bytes.unsafe_of_string s))





end
module Ext_list : sig 
#1 "ext_list.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


val map : 
  'a list -> 
  ('a -> 'b) -> 
  'b list 

val has_string :   
  string list ->
  string -> 
  bool
val map_split_opt :  
  'a list ->
  ('a -> 'b option * 'c option) ->
  'b list * 'c list 

val mapi :
  'a list -> 
  (int -> 'a -> 'b) -> 
  'b list 
  
val map_snd : ('a * 'b) list -> ('b -> 'c) -> ('a * 'c) list 

(** [map_last f xs ]
    will pass [true] to [f] for the last element, 
    [false] otherwise. 
    For empty list, it returns empty
*)
val map_last : 
    'a list -> 
    (bool -> 'a -> 'b) -> 'b list

(** [last l]
    return the last element
    raise if the list is empty
*)
val last : 'a list -> 'a

val append : 
  'a list -> 
  'a list -> 
  'a list 

val append_one :  
  'a list -> 
  'a -> 
  'a list

val map_append :  
  'b list -> 
  'a list -> 
  ('b -> 'a) -> 
  'a list

val fold_right : 
  'a list -> 
  'b -> 
  ('a -> 'b -> 'b) -> 
  'b

val fold_right2 : 
  'a list -> 
  'b list -> 
  'c -> 
  ('a -> 'b -> 'c -> 'c) ->  'c

val map2 : 
  'a list ->
  'b list ->
  ('a -> 'b -> 'c) ->
  'c list

val fold_left_with_offset : 
  'a list -> 
  'acc -> 
  int -> 
  ('a -> 'acc ->  int ->  'acc) ->   
  'acc 


(** @unused *)
val filter_map : 
  'a list -> 
  ('a -> 'b option) -> 
  'b list  

(** [exclude p l] is the opposite of [filter p l] *)
val exclude : 
  'a list -> 
  ('a -> bool) -> 
  'a list 

(** [excludes p l]
    return a tuple [excluded,newl]
    where [exluded] is true indicates that at least one  
    element is removed,[newl] is the new list where all [p x] for [x] is false

*)
val exclude_with_val : 
  'a list -> 
  ('a -> bool) -> 
  'a list option


val same_length : 'a list -> 'b list -> bool

val init : int -> (int -> 'a) -> 'a list

(** [split_at n l]
    will split [l] into two lists [a,b], [a] will be of length [n], 
    otherwise, it will raise
*)
val split_at : 
  'a list -> 
  int -> 
  'a list * 'a list


(** [split_at_last l]
    It is equivalent to [split_at (List.length l - 1) l ]
*)
val split_at_last : 'a list -> 'a list * 'a

val filter_mapi : 
  'a list -> 
  ('a -> int ->  'b option) -> 
  'b list

val filter_map2 : 
  'a list -> 
  'b list -> 
  ('a -> 'b -> 'c option) -> 
  'c list


val length_compare : 'a list -> int -> [`Gt | `Eq | `Lt ]

val length_ge : 'a list -> int -> bool

(**

   {[length xs = length ys + n ]}
   input n should be positive 
   TODO: input checking
*)

val length_larger_than_n : 
  'a list -> 
  'a list -> 
   int -> 
   bool


(**
   [rev_map_append f l1 l2]
   [map f l1] and reverse it to append [l2]
   This weird semantics is due to it is the most efficient operation
   we can do
*)
val rev_map_append : 
  'a list -> 
  'b list -> 
  ('a -> 'b) -> 
  'b list


val flat_map : 
  'a list -> 
  ('a -> 'b list) -> 
  'b list

val flat_map_append : 
  'a list -> 
  'b list  ->
  ('a -> 'b list) -> 
  'b list


(**
    [stable_group eq lst]
    Example:
    Input:
   {[
     stable_group (=) [1;2;3;4;3]
   ]}
    Output:
   {[
     [[1];[2];[4];[3;3]]
   ]}
    TODO: this is O(n^2) behavior 
    which could be improved later
*)
val stable_group : 
  'a list -> 
  ('a -> 'a -> bool) -> 
  'a list list 

(** [drop n list]
    raise when [n] is negative
    raise when list's length is less than [n]
*)
val drop : 
  'a list -> 
  int -> 
  'a list 

val find_first :   
    'a list ->
    ('a -> bool) ->
    'a option 
    
(** [find_first_not p lst ]
    if all elements in [lst] pass, return [None] 
    otherwise return the first element [e] as [Some e] which
    fails the predicate
*)
val find_first_not : 
  'a list -> 
  ('a -> bool) -> 
  'a option 

(** [find_opt f l] returns [None] if all return [None],  
    otherwise returns the first one. 
*)

val find_opt : 
  'a list -> 
  ('a -> 'b option) -> 
  'b option 


val rev_iter : 
  'a list -> 
  ('a -> unit) -> 
  unit 

val iter:   
   'a list ->  
   ('a -> unit) -> 
   unit
   
val for_all:  
    'a list -> 
    ('a -> bool) -> 
    bool
val for_all_snd:    
    ('a * 'b) list -> 
    ('b -> bool) -> 
    bool

(** [for_all2_no_exn p xs ys]
    return [true] if all satisfied,
    [false] otherwise or length not equal
*)
val for_all2_no_exn : 
  'a list -> 
  'b list -> 
  ('a -> 'b -> bool) -> 
  bool



(** [f] is applied follow the list order *)
val split_map : 
  'a list -> 
  ('a -> 'b * 'c) -> 
  'b list * 'c list       

(** [fn] is applied from left to right *)
val reduce_from_left : 
  'a list -> 
  ('a -> 'a -> 'a) ->
  'a

val sort_via_array :
  'a list -> 
  ('a -> 'a -> int) -> 
  'a list  




(** [assoc_by_string default key lst]
    if  [key] is found in the list  return that val,
    other unbox the [default], 
    otherwise [assert false ]
*)
val assoc_by_string : 
  (string * 'a) list -> 
  string -> 
  'a  option ->   
  'a  

val assoc_by_int : 
  (int * 'a) list -> 
  int -> 
  'a  option ->   
  'a   


val nth_opt : 'a list -> int -> 'a option  

val iter_snd : ('a * 'b) list -> ('b -> unit) -> unit 

val iter_fst : ('a * 'b) list -> ('a -> unit) -> unit 

val exists : 'a list -> ('a -> bool) -> bool 

val exists_fst : 
  ('a * 'b) list ->
  ('a -> bool) ->
  bool

val exists_snd : 
  ('a * 'b) list -> 
  ('b -> bool) -> 
  bool

val concat_append:
    'a list list -> 
    'a list -> 
    'a list

val fold_left2:
    'a list -> 
    'b list -> 
    'c -> 
    ('a -> 'b -> 'c -> 'c)
    -> 'c 

val fold_left:    
    'a list -> 
    'b -> 
    ('b -> 'a -> 'b) -> 
    'b

val singleton_exn:     
    'a list -> 'a

val mem_string :     
    string list -> 
    string -> 
    bool
end = struct
#1 "ext_list.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)




let rec map l f =
  match l with
  | [] ->
    []
  | [x1] ->
    let y1 = f x1 in
    [y1]
  | [x1; x2] ->
    let y1 = f x1 in
    let y2 = f x2 in
    [y1; y2]
  | [x1; x2; x3] ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    [y1; y2; y3]
  | [x1; x2; x3; x4] ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    let y4 = f x4 in
    [y1; y2; y3; y4]
  | x1::x2::x3::x4::x5::tail ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    let y4 = f x4 in
    let y5 = f x5 in
    y1::y2::y3::y4::y5::(map tail f)

let rec has_string l f =
  match l with
  | [] ->
    false
  | [x1] ->
    x1 = f
  | [x1; x2] ->
    x1 = f || x2 = f
  | [x1; x2; x3] ->
    x1 = f || x2 = f || x3 = f
  | x1 :: x2 :: x3 :: x4 ->
    x1 = f || x2 = f || x3 = f || has_string x4 f 
  

let rec map_split_opt 
  (xs : 'a list)  (f : 'a -> 'b option * 'c option) 
  : 'b list * 'c list = 
  match xs with 
  | [] -> [], []
  | x::xs ->
    let c,d = f x in 
    let cs,ds = map_split_opt xs f in 
    (match c with Some c -> c::cs | None -> cs),
    (match d with Some d -> d::ds | None -> ds)

let rec map_snd l f =
  match l with
  | [] ->
    []
  | [ v1,x1 ] ->
    let y1 = f x1 in
    [v1,y1]
  | [v1, x1; v2, x2] ->
    let y1 = f x1 in
    let y2 = f x2 in
    [v1, y1; v2, y2]
  | [ v1, x1; v2, x2; v3, x3] ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    [v1, y1; v2, y2; v3, y3]
  | [ v1, x1; v2, x2; v3, x3; v4, x4] ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    let y4 = f x4 in
    [v1, y1; v2, y2; v3, y3; v4, y4]
  | (v1, x1) ::(v2, x2) :: (v3, x3)::(v4, x4) :: (v5, x5) ::tail ->
    let y1 = f x1 in
    let y2 = f x2 in
    let y3 = f x3 in
    let y4 = f x4 in
    let y5 = f x5 in
    (v1, y1)::(v2, y2) :: (v3, y3) :: (v4, y4) :: (v5, y5) :: (map_snd tail f)


let rec map_last l f=
  match l with
  | [] ->
    []
  | [x1] ->
    let y1 = f true x1 in
    [y1]
  | [x1; x2] ->
    let y1 = f false x1 in
    let y2 = f true x2 in
    [y1; y2]
  | [x1; x2; x3] ->
    let y1 = f false x1 in
    let y2 = f false x2 in
    let y3 = f true x3 in
    [y1; y2; y3]
  | [x1; x2; x3; x4] ->
    let y1 = f false x1 in
    let y2 = f false x2 in
    let y3 = f false x3 in
    let y4 = f true x4 in
    [y1; y2; y3; y4]
  | x1::x2::x3::x4::tail ->
    (* make sure that tail is not empty *)    
    let y1 = f false x1 in
    let y2 = f false x2 in
    let y3 = f false x3 in
    let y4 = f false x4 in
    y1::y2::y3::y4::(map_last tail f)

let rec mapi_aux lst i f = 
  match lst with
    [] -> []
  | a::l -> 
    let r = f i a in r :: mapi_aux l (i + 1) f 

let mapi lst f = mapi_aux lst 0 f

let rec last xs =
  match xs with 
  | [x] -> x 
  | _ :: tl -> last tl 
  | [] -> invalid_arg "Ext_list.last"    



let rec append_aux l1 l2 = 
  match l1 with
  | [] -> l2
  | [a0] -> a0::l2
  | [a0;a1] -> a0::a1::l2
  | [a0;a1;a2] -> a0::a1::a2::l2
  | [a0;a1;a2;a3] -> a0::a1::a2::a3::l2
  | [a0;a1;a2;a3;a4] -> a0::a1::a2::a3::a4::l2
  | a0::a1::a2::a3::a4::rest -> a0::a1::a2::a3::a4::append_aux rest l2

let append l1 l2 =   
  match l2 with 
  | [] -> l1 
  | _ -> append_aux l1 l2  

let append_one l1 x = append_aux l1 [x]  

let rec map_append l1 l2 f =   
  match l1 with
  | [] -> l2
  | [a0] -> f a0::l2
  | [a0;a1] -> 
    let b0 = f a0 in 
    let b1 = f a1 in 
    b0::b1::l2
  | [a0;a1;a2] -> 
    let b0 = f a0 in 
    let b1 = f a1 in  
    let b2 = f a2 in 
    b0::b1::b2::l2
  | [a0;a1;a2;a3] -> 
    let b0 = f a0 in 
    let b1 = f a1 in 
    let b2 = f a2 in 
    let b3 = f a3 in 
    b0::b1::b2::b3::l2
  | [a0;a1;a2;a3;a4] -> 
    let b0 = f a0 in 
    let b1 = f a1 in 
    let b2 = f a2 in 
    let b3 = f a3 in 
    let b4 = f a4 in 
    b0::b1::b2::b3::b4::l2

  | a0::a1::a2::a3::a4::rest ->
    let b0 = f a0 in 
    let b1 = f a1 in 
    let b2 = f a2 in 
    let b3 = f a3 in 
    let b4 = f a4 in 
    b0::b1::b2::b3::b4::map_append rest l2 f



let rec fold_right l acc f  = 
  match l with  
  | [] -> acc 
  | [a0] -> f a0 acc 
  | [a0;a1] -> f a0 (f a1 acc)
  | [a0;a1;a2] -> f a0 (f a1 (f a2 acc))
  | [a0;a1;a2;a3] -> f a0 (f a1 (f a2 (f a3 acc))) 
  | [a0;a1;a2;a3;a4] -> 
    f a0 (f a1 (f a2 (f a3 (f a4 acc))))
  | a0::a1::a2::a3::a4::rest -> 
    f a0 (f a1 (f a2 (f a3 (f a4 (fold_right rest acc f )))))  

let rec fold_right2 l r acc f = 
  match l,r  with  
  | [],[] -> acc 
  | [a0],[b0] -> f a0 b0 acc 
  | [a0;a1],[b0;b1] -> f a0 b0 (f a1 b1 acc)
  | [a0;a1;a2],[b0;b1;b2] -> f a0 b0 (f a1 b1 (f a2 b2 acc))
  | [a0;a1;a2;a3],[b0;b1;b2;b3] ->
    f a0 b0 (f a1 b1 (f a2 b2 (f a3 b3 acc))) 
  | [a0;a1;a2;a3;a4], [b0;b1;b2;b3;b4] -> 
    f a0 b0 (f a1 b1 (f a2 b2 (f a3 b3 (f a4 b4 acc))))
  | a0::a1::a2::a3::a4::arest, b0::b1::b2::b3::b4::brest -> 
    f a0 b0 (f a1 b1 (f a2 b2 (f a3 b3 (f a4 b4 (fold_right2 arest brest acc f )))))  
  | _, _ -> invalid_arg "Ext_list.fold_right2"

let rec map2  l r f = 
  match l,r  with  
  | [],[] -> []
  | [a0],[b0] -> [f a0 b0]
  | [a0;a1],[b0;b1] -> 
    let c0 = f a0 b0 in 
    let c1 = f a1 b1 in 
    [c0; c1]
  | [a0;a1;a2],[b0;b1;b2] -> 
    let c0 = f a0 b0 in 
    let c1 = f a1 b1 in 
    let c2 = f a2 b2 in 
    [c0;c1;c2]
  | [a0;a1;a2;a3],[b0;b1;b2;b3] ->
    let c0 = f a0 b0 in 
    let c1 = f a1 b1 in 
    let c2 = f a2 b2 in 
    let c3 = f a3 b3 in 
    [c0;c1;c2;c3]
  | [a0;a1;a2;a3;a4], [b0;b1;b2;b3;b4] -> 
    let c0 = f a0 b0 in 
    let c1 = f a1 b1 in 
    let c2 = f a2 b2 in 
    let c3 = f a3 b3 in 
    let c4 = f a4 b4 in 
    [c0;c1;c2;c3;c4]
  | a0::a1::a2::a3::a4::arest, b0::b1::b2::b3::b4::brest -> 
    let c0 = f a0 b0 in 
    let c1 = f a1 b1 in 
    let c2 = f a2 b2 in 
    let c3 = f a3 b3 in 
    let c4 = f a4 b4 in 
    c0::c1::c2::c3::c4::map2 arest brest f
  | _, _ -> invalid_arg "Ext_list.map2"

let rec fold_left_with_offset l accu i f =
  match l with
  | [] -> accu
  | a::l -> 
    fold_left_with_offset 
    l     
    (f  a accu  i)  
    (i + 1)
    f  


let rec filter_map xs (f: 'a -> 'b option)= 
  match xs with 
  | [] -> []
  | y :: ys -> 
    begin match f y with 
      | None -> filter_map ys f 
      | Some z -> z :: filter_map ys f 
    end

let rec exclude (xs : 'a list) (p : 'a -> bool) : 'a list =   
  match xs with 
  | [] ->  []
  | x::xs -> 
    if p x then exclude xs p
    else x:: exclude xs p

let rec exclude_with_val l p =
  match l with 
  | [] ->  None
  | a0::xs -> 
    if p a0 then Some (exclude xs p)
    else 
      match xs with 
      | [] -> None
      | a1::rest -> 
        if p a1 then 
          Some (a0:: exclude rest p)
        else 
          match exclude_with_val rest p with 
          | None -> None 
          | Some  rest -> Some (a0::a1::rest)



let rec same_length xs ys = 
  match xs, ys with 
  | [], [] -> true
  | _::xs, _::ys -> same_length xs ys 
  | _, _ -> false 


let init n f = 
  match n with 
  | 0 -> []
  | 1 -> 
    let a0 = f 0 in  
    [a0]
  | 2 -> 
    let a0 = f 0 in 
    let a1 = f 1 in 
    [a0; a1]
  | 3 -> 
    let a0 = f 0 in 
    let a1 = f 1 in 
    let a2 = f 2 in 
    [a0; a1; a2]
  | 4 -> 
    let a0 = f 0 in 
    let a1 = f 1 in 
    let a2 = f 2 in 
    let a3 = f 3 in 
    [a0; a1; a2; a3]
  | 5 -> 
    let a0 = f 0 in 
    let a1 = f 1 in 
    let a2 = f 2 in 
    let a3 = f 3 in 
    let a4 = f 4 in  
    [a0; a1; a2; a3; a4]
  | _ ->
    Array.to_list (Array.init n f)

let rec small_split_at n acc l = 
  if n <= 0 then List.rev acc , l 
  else 
    match l with 
    | x::xs -> small_split_at (n - 1) (x ::acc) xs 
    | _ -> invalid_arg "Ext_list.split_at"

let split_at l n = 
  small_split_at n [] l 

let rec split_at_last_aux acc x = 
  match x with 
  | [] -> invalid_arg "Ext_list.split_at_last"
  | [ x] -> List.rev acc, x
  | y0::ys -> split_at_last_aux (y0::acc) ys   

let split_at_last (x : 'a list) = 
  match x with 
  | [] -> invalid_arg "Ext_list.split_at_last"
  | [a0] -> 
    [], a0
  | [a0;a1] -> 
    [a0], a1  
  | [a0;a1;a2] -> 
    [a0;a1], a2 
  | [a0;a1;a2;a3] -> 
    [a0;a1;a2], a3 
  | [a0;a1;a2;a3;a4] ->
    [a0;a1;a2;a3], a4 
  | a0::a1::a2::a3::a4::rest  ->  
    let rev, last = split_at_last_aux [] rest
    in 
    a0::a1::a2::a3::a4::  rev , last

(**
   can not do loop unroll due to state combination
*)  
let  filter_mapi xs f  = 
  let rec aux i xs = 
    match xs with 
    | [] -> []
    | y :: ys -> 
      begin match f y i with 
        | None -> aux (i + 1) ys
        | Some z -> z :: aux (i + 1) ys
      end in
  aux 0 xs 

let rec filter_map2  xs ys (f: 'a -> 'b -> 'c option) = 
  match xs,ys with 
  | [],[] -> []
  | u::us, v :: vs -> 
    begin match f u v with 
      | None -> filter_map2 us vs f (* idea: rec f us vs instead? *)
      | Some z -> z :: filter_map2  us vs f
    end
  | _ -> invalid_arg "Ext_list.filter_map2"


let rec rev_map_append l1 l2 f =
  match l1 with
  | [] -> l2
  | a :: l -> rev_map_append l (f a :: l2) f


let rec rev_append l1 l2 =
  match l1 with
    [] -> l2
  | a :: l -> rev_append l   (a :: l2)

(** It is not worth loop unrolling, 
    it is already tail-call, and we need to be careful 
    about evaluation order when unroll
*)
let rec flat_map_aux f acc append lx =
  match lx with
  | [] -> rev_append acc  append
  | a0::rest -> flat_map_aux f (rev_append (f a0)  acc ) append rest 

let flat_map lx f  =
  flat_map_aux f [] [] lx

let flat_map_append lx append f =
  flat_map_aux f [] append lx  


let rec length_compare l n = 
  if n < 0 then `Gt 
  else 
    begin match l with 
      | _ ::xs -> length_compare xs (n - 1)
      | [] ->  
        if n = 0 then `Eq 
        else `Lt 
    end

let rec length_ge l n =   
  if n > 0 then
    match l with 
    | _ :: tl -> length_ge tl (n - 1)
    | [] -> false
  else true
(**

   {[length xs = length ys + n ]}
*)
let rec length_larger_than_n xs ys n =
  match xs, ys with 
  | _, [] -> length_compare xs n = `Eq   
  | _::xs, _::ys -> 
    length_larger_than_n xs ys n
  | [], _ -> false 




let rec group (eq : 'a -> 'a -> bool) lst =
  match lst with 
  | [] -> []
  | x::xs -> 
    aux eq x (group eq xs )

and aux eq (x : 'a)  (xss : 'a list list) : 'a list list = 
  match xss with 
  | [] -> [[x]]
  | (y0::_ as y)::ys -> (* cannot be empty *) 
    if eq x y0 then
      (x::y) :: ys 
    else
      y :: aux eq x ys                                 
  | _ :: _ -> assert false    

let stable_group lst eq =  group eq lst |> List.rev  

let rec drop h n = 
  if n < 0 then invalid_arg "Ext_list.drop"
  else
  if n = 0 then h 
  else 
    match h with 
    | [] ->
      invalid_arg "Ext_list.drop"
    | _ :: tl ->   
      drop tl (n - 1)

let rec find_first x p = 
  match x with 
  | [] -> None
  | x :: l -> 
    if p x then Some x 
    else find_first l p

let rec find_first_not  xs p = 
  match xs with 
  | [] -> None
  | a::l -> 
    if p a 
    then find_first_not l p 
    else Some a 


let rec rev_iter l f = 
  match l with
  | [] -> ()    
  | [x1] ->
    f x1 
  | [x1; x2] ->
    f x2 ; f x1 
  | [x1; x2; x3] ->
    f x3 ; f x2 ; f x1 
  | [x1; x2; x3; x4] ->
    f x4; f x3; f x2; f x1 
  | x1::x2::x3::x4::x5::tail ->
    rev_iter tail f;
    f x5; f x4 ; f x3; f x2 ; f x1

let rec iter l f = 
  match l with
  | [] -> ()    
  | [x1] ->
    f x1 
  | [x1; x2] ->
    f x1 ; f x2
  | [x1; x2; x3] ->
    f x1 ; f x2 ; f x3
  | [x1; x2; x3; x4] ->
    f x1; f x2; f x3; f x4
  | x1::x2::x3::x4::x5::tail ->
    f x1; f x2 ; f x3; f x4 ; f x5;
    iter tail f 


let rec for_all lst p = 
  match lst with 
    [] -> true
  | a::l -> p a && for_all l p

let rec for_all_snd lst p = 
  match lst with 
    [] -> true
  | (_,a)::l -> p a && for_all_snd l p


let rec for_all2_no_exn  l1 l2 p = 
  match (l1, l2) with
  | ([], []) -> true
  | (a1::l1, a2::l2) -> p a1 a2 && for_all2_no_exn l1 l2 p
  | (_, _) -> false


let rec find_opt xs p = 
  match xs with 
  | [] -> None
  | x :: l -> 
    match  p x with 
    | Some _ as v  ->  v
    | None -> find_opt l p



let rec split_map l f = 
  match l with
  | [] ->
    [],[]
  | [x1] ->
    let a0,b0 = f x1 in
    [a0],[b0]
  | [x1; x2] ->
    let a1,b1 = f x1 in
    let a2,b2 = f x2 in
    [a1;a2],[b1;b2]
  | [x1; x2; x3] ->
    let a1,b1 = f x1 in
    let a2,b2 = f x2 in
    let a3,b3 = f x3 in
    [a1;a2;a3], [b1;b2;b3]
  | [x1; x2; x3; x4] ->
    let a1,b1 = f x1 in
    let a2,b2 = f x2 in
    let a3,b3 = f x3 in
    let a4,b4 = f x4 in
    [a1;a2;a3;a4], [b1;b2;b3;b4] 
  | x1::x2::x3::x4::x5::tail ->
    let a1,b1 = f x1 in
    let a2,b2 = f x2 in
    let a3,b3 = f x3 in
    let a4,b4 = f x4 in
    let a5,b5 = f x5 in
    let ass,bss = split_map tail f in 
    a1::a2::a3::a4::a5::ass,
    b1::b2::b3::b4::b5::bss




let sort_via_array lst cmp =
  let arr = Array.of_list lst  in
  Array.sort cmp arr;
  Array.to_list arr




let rec assoc_by_string lst (k : string) def  = 
  match lst with 
  | [] -> 
    begin match def with 
      | None -> assert false 
      | Some x -> x end
  | (k1,v1)::rest -> 
    if Ext_string.equal k1 k then v1 else 
      assoc_by_string  rest k def 

let rec assoc_by_int lst (k : int) def = 
  match lst with 
  | [] -> 
    begin match def with
      | None -> assert false 
      | Some x -> x end
  | (k1,v1)::rest -> 
    if k1 = k then v1 else 
      assoc_by_int rest k def 


let rec nth_aux l n =
  match l with
  | [] -> None
  | a::l -> if n = 0 then Some a else nth_aux l (n-1)

let nth_opt l n =
  if n < 0 then None 
  else
    nth_aux l n

let rec iter_snd lst f =     
  match lst with
  | [] -> ()
  | (_,x)::xs -> 
    f x ; 
    iter_snd xs f 
    
let rec iter_fst lst f =     
  match lst with
  | [] -> ()
  | (x,_)::xs -> 
    f x ; 
    iter_fst xs f 

let rec exists l p =     
  match l with 
    [] -> false  
  | x :: xs -> p x || exists xs p

let rec exists_fst l p = 
  match l with 
    [] -> false
  | (a,_)::l -> p a || exists_fst l p 

let rec exists_snd l p = 
  match l with 
    [] -> false
  | (_, a)::l -> p a || exists_snd l p 

let rec concat_append 
  (xss : 'a list list)  
  (xs : 'a list) : 'a list = 
  match xss with 
  | [] -> xs 
  | l::r -> append l (concat_append r xs)

let rec fold_left l accu f =
  match l with
    [] -> accu
  | a::l -> fold_left l (f accu a) f 
  
let reduce_from_left lst fn = 
  match lst with 
  | first :: rest ->  fold_left rest first fn 
  | _ -> invalid_arg "Ext_list.reduce_from_left"

let rec fold_left2 l1 l2 accu f =
  match (l1, l2) with
    ([], []) -> accu
  | (a1::l1, a2::l2) -> fold_left2  l1 l2 (f a1 a2 accu) f 
  | (_, _) -> invalid_arg "List.fold_left2"

let singleton_exn xs = match xs with [x] -> x | _ -> assert false

let rec mem_string (xs : string list) (x : string) = 
  match xs with 
    [] -> false
  | a::l ->  a = x  || mem_string l x

end
module Map_gen
= struct
#1 "map_gen.ml"
(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../LICENSE.     *)
(*                                                                     *)
(***********************************************************************)
(** adapted from stdlib *)

type ('key,'a) t =
  | Empty
  | Node of ('key,'a) t * 'key * 'a * ('key,'a) t * int

type ('key,'a) enumeration =
  | End
  | More of 'key * 'a * ('key,'a) t * ('key, 'a) enumeration

let rec cardinal_aux acc  = function
  | Empty -> acc 
  | Node (l,_,_,r, _) -> 
    cardinal_aux  (cardinal_aux (acc + 1)  r ) l 

let cardinal s = cardinal_aux 0 s 

let rec bindings_aux accu = function
  | Empty -> accu
  | Node(l, v, d, r, _) -> bindings_aux ((v, d) :: bindings_aux accu r) l

let bindings s =
  bindings_aux [] s

  
let rec fill_array_aux (s : _ t) i arr : int =    
  match s with 
  | Empty -> i 
  | Node (l,k,v,r,_) -> 
    let inext = fill_array_aux l i arr in 
    Array.unsafe_set arr inext (k,v);
    fill_array_aux r (inext + 1) arr 

let to_sorted_array (s : ('key,'a) t)  : ('key * 'a ) array =    
  match s with 
  | Empty -> [||]
  | Node(l,k,v,r,_) -> 
    let len = 
      cardinal_aux (cardinal_aux 1 r) l in 
    let arr =
      Array.make len (k,v) in  
    ignore (fill_array_aux s 0 arr : int);
    arr 
let rec keys_aux accu = function
    Empty -> accu
  | Node(l, v, _, r, _) -> keys_aux (v :: keys_aux accu r) l

let keys s = keys_aux [] s



let rec cons_enum m e =
  match m with
    Empty -> e
  | Node(l, v, d, r, _) -> cons_enum l (More(v, d, r, e))


let height = function
  | Empty -> 0
  | Node(_,_,_,_,h) -> h

let create l x d r =
  let hl = height l and hr = height r in
  Node(l, x, d, r, (if hl >= hr then hl + 1 else hr + 1))

let singleton x d = Node(Empty, x, d, Empty, 1)

let bal l x d r =
  let hl = match l with Empty -> 0 | Node(_,_,_,_,h) -> h in
  let hr = match r with Empty -> 0 | Node(_,_,_,_,h) -> h in
  if hl > hr + 2 then begin
    match l with
      Empty -> invalid_arg "Map.bal"
    | Node(ll, lv, ld, lr, _) ->
      if height ll >= height lr then
        create ll lv ld (create lr x d r)
      else begin
        match lr with
          Empty -> invalid_arg "Map.bal"
        | Node(lrl, lrv, lrd, lrr, _)->
          create (create ll lv ld lrl) lrv lrd (create lrr x d r)
      end
  end else if hr > hl + 2 then begin
    match r with
      Empty -> invalid_arg "Map.bal"
    | Node(rl, rv, rd, rr, _) ->
      if height rr >= height rl then
        create (create l x d rl) rv rd rr
      else begin
        match rl with
          Empty -> invalid_arg "Map.bal"
        | Node(rll, rlv, rld, rlr, _) ->
          create (create l x d rll) rlv rld (create rlr rv rd rr)
      end
  end else
    Node(l, x, d, r, (if hl >= hr then hl + 1 else hr + 1))

let empty = Empty

let is_empty = function Empty -> true | _ -> false

let rec min_binding_exn = function
    Empty -> raise Not_found
  | Node(Empty, x, d, r, _) -> (x, d)
  | Node(l, x, d, r, _) -> min_binding_exn l

let choose = min_binding_exn

let rec max_binding_exn = function
    Empty -> raise Not_found
  | Node(l, x, d, Empty, _) -> (x, d)
  | Node(l, x, d, r, _) -> max_binding_exn r

let rec remove_min_binding = function
    Empty -> invalid_arg "Map.remove_min_elt"
  | Node(Empty, x, d, r, _) -> r
  | Node(l, x, d, r, _) -> bal (remove_min_binding l) x d r

let merge t1 t2 =
  match (t1, t2) with
    (Empty, t) -> t
  | (t, Empty) -> t
  | (_, _) ->
    let (x, d) = min_binding_exn t2 in
    bal t1 x d (remove_min_binding t2)


let rec iter x f = match x with 
    Empty -> ()
  | Node(l, v, d, r, _) ->
    iter l f; f v d; iter r f

let rec map x f = match x with
    Empty ->
    Empty
  | Node(l, v, d, r, h) ->
    let l' = map l f in
    let d' = f d in
    let r' = map r f in
    Node(l', v, d', r', h)

let rec mapi x f = match x with
    Empty ->
    Empty
  | Node(l, v, d, r, h) ->
    let l' = mapi l f in
    let d' = f v d in
    let r' = mapi r f in
    Node(l', v, d', r', h)

let rec fold m accu f =
  match m with
    Empty -> accu
  | Node(l, v, d, r, _) ->
    fold r (f v d (fold l accu f)) f 

let rec for_all x p = match x with 
    Empty -> true
  | Node(l, v, d, r, _) -> p v d && for_all l p && for_all r p

let rec exists x p = match x with
    Empty -> false
  | Node(l, v, d, r, _) -> p v d || exists l p || exists r p

(* Beware: those two functions assume that the added k is *strictly*
   smaller (or bigger) than all the present keys in the tree; it
   does not test for equality with the current min (or max) key.

   Indeed, they are only used during the "join" operation which
   respects this precondition.
*)

let rec add_min_binding k v = function
  | Empty -> singleton k v
  | Node (l, x, d, r, h) ->
    bal (add_min_binding k v l) x d r

let rec add_max_binding k v = function
  | Empty -> singleton k v
  | Node (l, x, d, r, h) ->
    bal l x d (add_max_binding k v r)

(* Same as create and bal, but no assumptions are made on the
   relative heights of l and r. *)

let rec join l v d r =
  match (l, r) with
    (Empty, _) -> add_min_binding v d r
  | (_, Empty) -> add_max_binding v d l
  | (Node(ll, lv, ld, lr, lh), Node(rl, rv, rd, rr, rh)) ->
    if lh > rh + 2 then bal ll lv ld (join lr v d r) else
    if rh > lh + 2 then bal (join l v d rl) rv rd rr else
      create l v d r

(* Merge two trees l and r into one.
   All elements of l must precede the elements of r.
   No assumption on the heights of l and r. *)

let concat t1 t2 =
  match (t1, t2) with
    (Empty, t) -> t
  | (t, Empty) -> t
  | (_, _) ->
    let (x, d) = min_binding_exn t2 in
    join t1 x d (remove_min_binding t2)

let concat_or_join t1 v d t2 =
  match d with
  | Some d -> join t1 v d t2
  | None -> concat t1 t2

let rec filter x p = match x with
    Empty -> Empty
  | Node(l, v, d, r, _) ->
    (* call [p] in the expected left-to-right order *)
    let l' = filter l p in
    let pvd = p v d in
    let r' = filter r p in
    if pvd then join l' v d r' else concat l' r'

let rec partition x p = match x with
    Empty -> (Empty, Empty)
  | Node(l, v, d, r, _) ->
    (* call [p] in the expected left-to-right order *)
    let (lt, lf) = partition l p in
    let pvd = p v d in
    let (rt, rf) = partition r p in
    if pvd
    then (join lt v d rt, concat lf rf)
    else (concat lt rt, join lf v d rf)

let compare compare_key cmp_val m1 m2 =
  let rec compare_aux e1  e2 =
    match (e1, e2) with
      (End, End) -> 0
    | (End, _)  -> -1
    | (_, End) -> 1
    | (More(v1, d1, r1, e1), More(v2, d2, r2, e2)) ->
      let c = compare_key v1 v2 in
      if c <> 0 then c else
        let c = cmp_val d1 d2 in
        if c <> 0 then c else
          compare_aux (cons_enum r1 e1) (cons_enum r2 e2)
  in compare_aux (cons_enum m1 End) (cons_enum m2 End)

let equal compare_key cmp m1 m2 =
  let rec equal_aux e1 e2 =
    match (e1, e2) with
      (End, End) -> true
    | (End, _)  -> false
    | (_, End) -> false
    | (More(v1, d1, r1, e1), More(v2, d2, r2, e2)) ->
      compare_key v1 v2 = 0 && cmp d1 d2 &&
      equal_aux (cons_enum r1 e1) (cons_enum r2 e2)
  in equal_aux (cons_enum m1 End) (cons_enum m2 End)



    
module type S =
  sig
    type key
    type +'a t
    val empty: 'a t
    val compare_key: key -> key -> int 
    val is_empty: 'a t -> bool
    val mem: 'a t -> key -> bool
    val to_sorted_array : 
      'a t -> (key * 'a ) array
    val add: 'a t -> key -> 'a -> 'a t
    (** [add x y m] 
        If [x] was already bound in [m], its previous binding disappears. *)
    val adjust: 'a t -> key -> ('a option->  'a) ->  'a t 
    (** [adjust acc k replace ] if not exist [add (replace None ], otherwise 
        [add k v (replace (Some old))]
    *)
    val singleton: key -> 'a -> 'a t

    val remove: 'a t -> key -> 'a t
    (** [remove x m] returns a map containing the same bindings as
       [m], except for [x] which is unbound in the returned map. *)

    val merge:
         'a t -> 'b t ->
         (key -> 'a option -> 'b option -> 'c option) ->  'c t
    (** [merge f m1 m2] computes a map whose keys is a subset of keys of [m1]
        and of [m2]. The presence of each such binding, and the corresponding
        value, is determined with the function [f].
        @since 3.12.0
     *)

    val disjoint_merge : 'a t -> 'a t -> 'a t
     (* merge two maps, will raise if they have the same key *)
    val compare: 'a t -> 'a t -> ('a -> 'a -> int) -> int
    (** Total ordering between maps.  The first argument is a total ordering
        used to compare data associated with equal keys in the two maps. *)

    val equal: 'a t -> 'a t -> ('a -> 'a -> bool) ->  bool

    val iter: 'a t -> (key -> 'a -> unit) ->  unit
    (** [iter f m] applies [f] to all bindings in map [m].
        The bindings are passed to [f] in increasing order. *)

    val fold: 'a t -> 'b -> (key -> 'a -> 'b -> 'b) -> 'b
    (** [fold f m a] computes [(f kN dN ... (f k1 d1 a)...)],
       where [k1 ... kN] are the keys of all bindings in [m]
       (in increasing order) *)

    val for_all: 'a t -> (key -> 'a -> bool) -> bool
    (** [for_all p m] checks if all the bindings of the map.
        order unspecified
     *)

    val exists: 'a t -> (key -> 'a -> bool) -> bool
    (** [exists p m] checks if at least one binding of the map
        satisfy the predicate [p]. 
        order unspecified
     *)

    val filter: 'a t -> (key -> 'a -> bool) -> 'a t
    (** [filter p m] returns the map with all the bindings in [m]
        that satisfy predicate [p].
        order unspecified
     *)

    val partition: 'a t -> (key -> 'a -> bool) ->  'a t * 'a t
    (** [partition p m] returns a pair of maps [(m1, m2)], where
        [m1] contains all the bindings of [s] that satisfy the
        predicate [p], and [m2] is the map with all the bindings of
        [s] that do not satisfy [p].
     *)

    val cardinal: 'a t -> int
    (** Return the number of bindings of a map. *)

    val bindings: 'a t -> (key * 'a) list
    (** Return the list of all bindings of the given map.
       The returned list is sorted in increasing order with respect
       to the ordering *)
    val keys : 'a t -> key list 
    (* Increasing order *)

    val min_binding_exn: 'a t -> (key * 'a)
    (** raise [Not_found] if the map is empty. *)

    val max_binding_exn: 'a t -> (key * 'a)
    (** Same as {!Map.S.min_binding} *)

    val choose: 'a t -> (key * 'a)
    (** Return one binding of the given map, or raise [Not_found] if
       the map is empty. Which binding is chosen is unspecified,
       but equal bindings will be chosen for equal maps.
     *)

    val split: 'a t -> key -> 'a t * 'a option * 'a t
    (** [split x m] returns a triple [(l, data, r)], where
          [l] is the map with all the bindings of [m] whose key
        is strictly less than [x];
          [r] is the map with all the bindings of [m] whose key
        is strictly greater than [x];
          [data] is [None] if [m] contains no binding for [x],
          or [Some v] if [m] binds [v] to [x].
        @since 3.12.0
     *)

    val find_exn: 'a t -> key ->  'a
    (** [find x m] returns the current binding of [x] in [m],
       or raises [Not_found] if no such binding exists. *)
    val find_opt:  'a t ->  key ->'a option
    val find_default: 'a t -> key  ->  'a  -> 'a 
    val map: 'a t -> ('a -> 'b) -> 'b t
    (** [map f m] returns a map with same domain as [m], where the
       associated value [a] of all bindings of [m] has been
       replaced by the result of the application of [f] to [a].
       The bindings are passed to [f] in increasing order
       with respect to the ordering over the type of the keys. *)

    val mapi: 'a t ->  (key -> 'a -> 'b) -> 'b t
    (** Same as {!Map.S.map}, but the function receives as arguments both the
       key and the associated value for each binding of the map. *)

    val of_list : (key * 'a) list -> 'a t 
    val of_array : (key * 'a ) array -> 'a t 
    val add_list : (key * 'b) list -> 'b t -> 'b t

  end

end
module String_map : sig 
#1 "string_map.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


include Map_gen.S with type key = string

end = struct
#1 "string_map.ml"

# 2 "ext/map.cppo.ml"
(* we don't create [map_poly], since some operations require raise an exception which carries [key] *)


  
# 10 "ext/map.cppo.ml"
  type key = string 
  let compare_key = Ext_string.compare

# 22 "ext/map.cppo.ml"
type 'a t = (key,'a) Map_gen.t
exception Duplicate_key of key 

let empty = Map_gen.empty 
let is_empty = Map_gen.is_empty
let iter = Map_gen.iter
let fold = Map_gen.fold
let for_all = Map_gen.for_all 
let exists = Map_gen.exists 
let singleton = Map_gen.singleton 
let cardinal = Map_gen.cardinal
let bindings = Map_gen.bindings
let to_sorted_array = Map_gen.to_sorted_array
let keys = Map_gen.keys
let choose = Map_gen.choose 
let partition = Map_gen.partition 
let filter = Map_gen.filter 
let map = Map_gen.map 
let mapi = Map_gen.mapi
let bal = Map_gen.bal 
let height = Map_gen.height 
let max_binding_exn = Map_gen.max_binding_exn
let min_binding_exn = Map_gen.min_binding_exn


let rec add (tree : _ Map_gen.t as 'a) x data  : 'a = match tree with 
  | Empty ->
    Node(Empty, x, data, Empty, 1)
  | Node(l, v, d, r, h) ->
    let c = compare_key x v in
    if c = 0 then
      Node(l, x, data, r, h)
    else if c < 0 then
      bal (add l x data ) v d r
    else
      bal l v d (add r x data )


let rec adjust (tree : _ Map_gen.t as 'a) x replace  : 'a = 
  match tree with 
  | Empty ->
    Node(Empty, x, replace None, Empty, 1)
  | Node(l, v, d, r, h) ->
    let c = compare_key x v in
    if c = 0 then
      Node(l, x, replace  (Some d) , r, h)
    else if c < 0 then
      bal (adjust l x  replace ) v d r
    else
      bal l v d (adjust r x  replace )


let rec find_exn (tree : _ Map_gen.t ) x = match tree with 
  | Empty ->
    raise Not_found
  | Node(l, v, d, r, _) ->
    let c = compare_key x v in
    if c = 0 then d
    else find_exn (if c < 0 then l else r) x

let rec find_opt (tree : _ Map_gen.t ) x = match tree with 
  | Empty -> None 
  | Node(l, v, d, r, _) ->
    let c = compare_key x v in
    if c = 0 then Some d
    else find_opt (if c < 0 then l else r) x

let rec find_default (tree : _ Map_gen.t ) x  default     = match tree with 
  | Empty -> default  
  | Node(l, v, d, r, _) ->
    let c = compare_key x v in
    if c = 0 then  d
    else find_default (if c < 0 then l else r) x default

let rec mem (tree : _ Map_gen.t )  x= match tree with 
  | Empty ->
    false
  | Node(l, v, d, r, _) ->
    let c = compare_key x v in
    c = 0 || mem (if c < 0 then l else r) x 

let rec remove (tree : _ Map_gen.t as 'a) x : 'a = match tree with 
  | Empty ->
    Empty
  | Node(l, v, d, r, h) ->
    let c = compare_key x v in
    if c = 0 then
      Map_gen.merge l r
    else if c < 0 then
      bal (remove l x) v d r
    else
      bal l v d (remove r x )


let rec split (tree : _ Map_gen.t as 'a) x : 'a * _ option * 'a  = match tree with 
  | Empty ->
    (Empty, None, Empty)
  | Node(l, v, d, r, _) ->
    let c = compare_key x v in
    if c = 0 then (l, Some d, r)
    else if c < 0 then
      let (ll, pres, rl) = split l x in (ll, pres, Map_gen.join rl v d r)
    else
      let (lr, pres, rr) = split r x in (Map_gen.join l v d lr, pres, rr)

let rec merge (s1 : _ Map_gen.t) (s2  : _ Map_gen.t) f  : _ Map_gen.t =
  match (s1, s2) with
  | (Empty, Empty) -> Empty
  | (Node (l1, v1, d1, r1, h1), _) when h1 >= height s2 ->
    let (l2, d2, r2) = split s2 v1 in
    Map_gen.concat_or_join (merge l1 l2 f) v1 (f v1 (Some d1) d2) (merge r1 r2 f)
  | (_, Node (l2, v2, d2, r2, h2)) ->
    let (l1, d1, r1) = split s1 v2 in
    Map_gen.concat_or_join (merge l1 l2 f) v2 (f v2 d1 (Some d2)) (merge r1 r2 f)
  | _ ->
    assert false

let rec disjoint_merge  (s1 : _ Map_gen.t) (s2  : _ Map_gen.t) : _ Map_gen.t =
  match (s1, s2) with
  | (Empty, Empty) -> Empty
  | (Node (l1, v1, d1, r1, h1), _) when h1 >= height s2 ->
    begin match split s2 v1 with 
    | l2, None, r2 -> 
      Map_gen.join (disjoint_merge  l1 l2) v1 d1 (disjoint_merge r1 r2)
    | _, Some _, _ ->
      raise (Duplicate_key  v1)
    end        
  | (_, Node (l2, v2, d2, r2, h2)) ->
    begin match  split s1 v2 with 
    | (l1, None, r1) -> 
      Map_gen.join (disjoint_merge  l1 l2) v2 d2 (disjoint_merge  r1 r2)
    | (_, Some _, _) -> 
      raise (Duplicate_key v2)
    end
  | _ ->
    assert false



let compare m1 m2 cmp = Map_gen.compare compare_key cmp m1 m2

let equal m1 m2 cmp = Map_gen.equal compare_key cmp m1 m2 

let add_list (xs : _ list ) init = 
  Ext_list.fold_left xs init (fun  acc (k,v) -> add acc k v )

let of_list xs = add_list xs empty

let of_array xs = 
  Ext_array.fold_left xs empty (fun acc (k,v) -> add acc k v ) 

end
module Bsb_db : sig 
#1 "bsb_db.mli"

(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

(** Store a file called [.bsbuild] that can be communicated 
    between [bsb.exe] and [bsb_helper.exe]. 
    [bsb.exe] stores such data which would be retrieved by 
    [bsb_helper.exe]. It is currently used to combine with 
    ocamldep to figure out which module->file it depends on
*) 

type case = bool 


type ml_info =
  | Ml_source of  bool  * bool
     (* No extension stored
      Ml_source(name,is_re)
      [is_re] default to false
      *)
  
  | Ml_empty
type mli_info = 
  | Mli_source of  bool * bool
  | Mli_empty

type module_info = 
  {
    mli_info : mli_info ; 
    ml_info : ml_info ; 
    name_sans_extension : string
  }

type t = module_info String_map.t 

type ts = t array 

(** store  the meta data indexed by {!Bsb_dir_index}
  {[
    0 --> lib group
    1 --> dev 1 group
    .
    
  ]}
*)

val filename_sans_suffix_of_module_info : module_info -> string 



(**
  return [boolean] to indicate whether reason file exists or not
  will raise if it fails sanity check
*)
val has_reason_files : t -> bool




end = struct
#1 "bsb_db.ml"

(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

type case = bool
(** true means upper case*)

type ml_info =
  | Ml_source of  bool  * case (*  Ml_source(is_re, case) default to false  *)
  | Ml_empty
type mli_info = 
  | Mli_source of  bool  * case  
  | Mli_empty

type module_info = 
  {
    mli_info : mli_info ; 
    ml_info : ml_info ; 
    name_sans_extension : string  ;
  }


type t = module_info String_map.t 

type ts = t array 
(** indexed by the group *)





let filename_sans_suffix_of_module_info (x : module_info) =
  x.name_sans_extension




let has_reason_files (map  : t ) = 
  String_map.exists map (fun _ module_info ->
      match module_info with 
      |  { ml_info = Ml_source(is_re,_); 
           mli_info = Mli_source(is_rei,_) } ->
        is_re || is_rei
      | {ml_info = Ml_source(is_re,_); mli_info = Mli_empty}    
      | {mli_info = Mli_source(is_re,_); ml_info = Ml_empty}
        ->  is_re
      | {ml_info = Ml_empty ; mli_info = Mli_empty } -> false
    )  




end
<<<<<<< HEAD
=======
module Bs_version : sig 
#1 "bs_version.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

val version : string

val header : string 

val package_name : string
end = struct
#1 "bs_version.ml"

(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)    
let version = "5.1.0"
let header = 
   "// Generated by BUCKLESCRIPT VERSION 5.1.0, PLEASE EDIT WITH CARE"  
let package_name = "bs-platform"   
    
end
>>>>>>> More work
module Literals : sig 
#1 "literals.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)






val js_array_ctor : string 
val js_type_number : string
val js_type_string : string
val js_type_object : string
val js_type_boolean : string
val js_undefined : string
val js_prop_length : string

val param : string
val partial_arg : string
val prim : string

(**temporary varaible used in {!Js_ast_util} *)
val tmp : string 

val create : string 
val runtime : string
val stdlib : string
val imul : string

val setter_suffix : string
val setter_suffix_len : int


val debugger : string
val raw_expr : string
val raw_stmt : string
val raw_function : string
val unsafe_downgrade : string
val fn_run : string
val method_run : string
val fn_method : string
val fn_mk : string

(** callback actually, not exposed to user yet *)
(* val js_fn_runmethod : string *)

val bs_deriving : string
val bs_deriving_dot : string
val bs_type : string

(** nodejs *)

val node_modules : string
val node_modules_length : int
val package_json : string
val bsconfig_json : string
val build_ninja : string

(* Name of the library file created for each external dependency. *)
val library_file : string

val suffix_a : string
val suffix_cmj : string
val suffix_cmo : string
val suffix_cma : string
val suffix_cmi : string
val suffix_cmx : string
val suffix_cmxa : string
val suffix_ml : string
val suffix_mlast : string 
val suffix_mlast_simple : string
val suffix_mliast : string
val suffix_mliast_simple : string
val suffix_mlmap : string
val suffix_mll : string
val suffix_re : string
val suffix_rei : string 

val suffix_d : string
val suffix_js : string
val suffix_bs_js : string 
(* val suffix_re_js : string *)
val suffix_gen_js : string 
val suffix_gen_tsx: string

val suffix_tsx : string

val suffix_mli : string 
val suffix_cmt : string 
val suffix_cmti : string 

val commonjs : string 

val es6 : string 
val es6_global : string

val unused_attribute : string 
val dash_nostdlib : string

val reactjs_jsx_ppx_2_exe : string 
val reactjs_jsx_ppx_3_exe : string 

val native : string
val bytecode : string
val js : string

val node_sep : string 
val node_parent : string 
val node_current : string 
val gentype_import : string

val bsbuild_cache : string
end = struct
#1 "literals.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)







let js_array_ctor = "Array"
let js_type_number = "number"
let js_type_string = "string"
let js_type_object = "object" 
let js_type_boolean = "boolean"
let js_undefined = "undefined"
let js_prop_length = "length"

let prim = "prim"
let param = "param"
let partial_arg = "partial_arg"
let tmp = "tmp"

let create = "create" (* {!Caml_exceptions.create}*)

let runtime = "runtime" (* runtime directory *)

let stdlib = "stdlib"

let imul = "imul" (* signed int32 mul *)

let setter_suffix = "#="
let setter_suffix_len = String.length setter_suffix

let debugger = "debugger"
let raw_expr = "raw_expr"
let raw_stmt = "raw_stmt"
let raw_function = "raw_function"
let unsafe_downgrade = "unsafe_downgrade"
let fn_run = "fn_run"
let method_run = "method_run"

let fn_method = "fn_method"
let fn_mk = "fn_mk"
(*let js_fn_runmethod = "js_fn_runmethod"*)

let bs_deriving = "bs.deriving"
let bs_deriving_dot = "bs.deriving."
let bs_type = "bs.type"


(** nodejs *)
let node_modules = "node_modules"
let node_modules_length = String.length "node_modules"
let package_json = "package.json"
let bsconfig_json = "bsconfig.json"
let build_ninja = "build.ninja"

(* Name of the library file created for each external dependency. *)
let library_file = "lib"

let suffix_a = ".a"
let suffix_cmj = ".cmj"
let suffix_cmo = ".cmo"
let suffix_cma = ".cma"
let suffix_cmi = ".cmi"
let suffix_cmx = ".cmx"
let suffix_cmxa = ".cmxa"
let suffix_mll = ".mll"
let suffix_ml = ".ml"
let suffix_mli = ".mli"
let suffix_re = ".re"
let suffix_rei = ".rei"
let suffix_mlmap = ".mlmap"

let suffix_cmt = ".cmt" 
let suffix_cmti = ".cmti" 
let suffix_mlast = ".mlast"
let suffix_mlast_simple = ".mlast_simple"
let suffix_mliast = ".mliast"
let suffix_mliast_simple = ".mliast_simple"
let suffix_d = ".d"
let suffix_js = ".js"
let suffix_bs_js = ".bs.js"
(* let suffix_re_js = ".re.js" *)
let suffix_gen_js = ".gen.js"
let suffix_gen_tsx = ".gen.tsx"
let suffix_tsx = ".tsx"

let commonjs = "commonjs" 

let es6 = "es6"
let es6_global = "es6-global"

let unused_attribute = "Unused attribute " 
let dash_nostdlib = "-nostdlib"

let reactjs_jsx_ppx_2_exe = "reactjs_jsx_ppx_2.exe"
let reactjs_jsx_ppx_3_exe  = "reactjs_jsx_ppx_3.exe"

let native = "native"
let bytecode = "bytecode"
let js = "js"



(** Used when produce node compatible paths *)
let node_sep = "/"
let node_parent = ".."
let node_current = "."

let gentype_import = "genType.import"

let bsbuild_cache = ".bsbuild"    

end
module Bsb_db_decode : sig 
#1 "bsb_db_decode.mli"
(* Copyright (C) 2019 - Present Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


 
  
type t

type group = {
   modules : string array ; 
   meta_info_offset : int 
 }

(* exposed only for testing *)
val decode_internal : 
  string -> 
  int ref ->
  group array 



val read_build_cache : 
  dir:string -> t



type module_info = {
  case : Bsb_db.case;
  dir_name : string
} 

val find_opt :
  t -> (* contains global info *)
  int -> (* more likely to be zero *)
  string -> (* module name *)
  module_info option 
end = struct
#1 "bsb_db_decode.ml"
(* Copyright (C) 2019 - Present Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

 let bsbuild_cache = Literals.bsbuild_cache


 type group = {
   modules : string array ; 
   meta_info_offset : int 
 }

type t = group array * string (* string is whole content*)



let bool buf b =   
  Buffer.add_char buf (if b then '1' else '0')

type cursor = int ref 

let extract_line (x : string) (cur : cursor) : string =
  Ext_string.extract_until x cur '\n'

let next_mdoule_info (s : string) (cur : int) ~count  =  
  if count = 0 then cur 
  else 
    Ext_string.index_count s cur '\n' count  + 1

let rec decode_internal (x : string) (offset : cursor) =   
  let len = int_of_string (extract_line x offset) in  
  Array.init len (fun _ ->  decode_single x offset)
and decode_single x (offset : cursor) : group = 
  let cardinal = int_of_string (extract_line x offset) in 
  let modules = decode_modules x offset cardinal in 
  let meta_info_offset = !offset in 
  offset := next_mdoule_info x meta_info_offset ~count:cardinal;
  { modules ; meta_info_offset }
and decode_modules x (offset : cursor) cardinal =   
  let result = Array.make cardinal "" in 
  for i = 0 to cardinal - 1 do 
    Array.unsafe_set result i (extract_line x offset)
  done ;
  result
  





let read_build_cache ~dir  : t = 
  let ic = open_in_bin (Filename.concat dir bsbuild_cache) in 
  let len = in_channel_length ic in 
  let all_content = really_input_string ic len in 
  let offset = ref 0 in 
  let _cur_module_info_magic_number = extract_line all_content offset in 
  (* assert (cur_module_info_magic_number = Bs_version.version);  *)
  decode_internal all_content offset, all_content

let cmp (a : string) b = String_map.compare_key a b   

let rec binarySearchAux (arr : string array) (lo : int) (hi : int) (key : string)  : _ option = 
  let mid = (lo + hi)/2 in 
  let midVal = Array.unsafe_get arr mid in 
  let c = cmp key midVal in 
  if c = 0 then Some (mid)
  else if c < 0 then  (*  a[lo] =< key < a[mid] <= a[hi] *)
    if hi = mid then  
      let loVal = (Array.unsafe_get arr lo) in 
      if  loVal = key then Some lo
      else None
    else binarySearchAux arr lo mid key 
  else  (*  a[lo] =< a[mid] < key <= a[hi] *)
  if lo = mid then 
    let hiVal = (Array.unsafe_get arr hi) in 
    if  hiVal = key then Some hi
    else None
  else binarySearchAux arr mid hi key 

let find_opt_aux sorted key  : _ option =  
  let len = Array.length sorted in 
  if len = 0 then None
  else 
    let lo = Array.unsafe_get sorted 0 in 
    let c = cmp key lo in 
    if c < 0 then None
    else
      let hi = Array.unsafe_get sorted (len - 1) in 
      let c2 = cmp key hi in 
      if c2 > 0 then None
      else binarySearchAux sorted 0 (len - 1) key



type module_info =  {
  (* mli_info : mli_info;
  ml_info : ml_info; *)
  case : Bsb_db.case; 
  (* module and interface at least 
    should have consistent case
  *)
  dir_name : string
} 


let find_opt 
  ((sorteds,whole) : t )  i (key : string) 
    : module_info option = 
  let group = sorteds.(i) in 
  let i = find_opt_aux group.modules key in 
  match i with 
  | None -> None 
  | Some count ->     
    let cursor = 
      ref (next_mdoule_info whole group.meta_info_offset ~count)
    in 
    let case = whole.[!cursor] = '1' in 
    incr cursor; 
    let dir_name = 
        extract_line whole cursor  in 
    Some 
          {
            dir_name;
            case 
          }
        
      
end
module Ext_buffer : sig 
#1 "ext_buffer.mli"
(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*  Pierre Weis and Xavier Leroy, projet Cristal, INRIA Rocquencourt   *)
(*                                                                     *)
(*  Copyright 1999 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../LICENSE.     *)
(*                                                                     *)
(***********************************************************************)

(** Extensible buffers.

   This module implements buffers that automatically expand
   as necessary.  It provides accumulative concatenation of strings
   in quasi-linear time (instead of quadratic time when strings are
   concatenated pairwise).
*)

(* BuckleScript customization: customized for efficient digest *)

type t
(** The abstract type of buffers. *)

val create : int -> t
(** [create n] returns a fresh buffer, initially empty.
   The [n] parameter is the initial size of the internal byte sequence
   that holds the buffer contents. That byte sequence is automatically
   reallocated when more than [n] characters are stored in the buffer,
   but shrinks back to [n] characters when [reset] is called.
   For best performance, [n] should be of the same order of magnitude
   as the number of characters that are expected to be stored in
   the buffer (for instance, 80 for a buffer that holds one output
   line).  Nothing bad will happen if the buffer grows beyond that
   limit, however. In doubt, take [n = 16] for instance.
   If [n] is not between 1 and {!Sys.max_string_length}, it will
   be clipped to that interval. *)

val contents : t -> string
(** Return a copy of the current contents of the buffer.
    The buffer itself is unchanged. *)

val length : t -> int
(** Return the number of characters currently contained in the buffer. *)

val is_empty : t -> bool

val clear : t -> unit
(** Empty the buffer. *)


val add_char : t -> char -> unit
(** [add_char b c] appends the character [c] at the end of the buffer [b]. *)

val add_string : t -> string -> unit
(** [add_string b s] appends the string [s] at the end of the buffer [b]. *)

val add_bytes : t -> bytes -> unit
(** [add_string b s] appends the string [s] at the end of the buffer [b].
    @since 4.02 *)

val add_substring : t -> string -> int -> int -> unit
(** [add_substring b s ofs len] takes [len] characters from offset
   [ofs] in string [s] and appends them at the end of the buffer [b]. *)

val add_subbytes : t -> bytes -> int -> int -> unit
(** [add_substring b s ofs len] takes [len] characters from offset
    [ofs] in byte sequence [s] and appends them at the end of the buffer [b].
    @since 4.02 *)

val add_buffer : t -> t -> unit
(** [add_buffer b1 b2] appends the current contents of buffer [b2]
   at the end of buffer [b1].  [b2] is not modified. *)    

val add_channel : t -> in_channel -> int -> unit
(** [add_channel b ic n] reads exactly [n] character from the
   input channel [ic] and stores them at the end of buffer [b].
   Raise [End_of_file] if the channel contains fewer than [n]
   characters. *)

val output_buffer : out_channel -> t -> unit
(** [output_buffer oc b] writes the current contents of buffer [b]
   on the output channel [oc]. *)   

val digest : t -> Digest.t   

val not_equal : 
  t -> 
  string -> 
  bool 
end = struct
#1 "ext_buffer.ml"
(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*    Pierre Weis and Xavier Leroy, projet Cristal, INRIA Rocquencourt    *)
(*                                                                        *)
(*   Copyright 1999 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(* Extensible buffers *)

type t =
 {mutable buffer : bytes;
  mutable position : int;
  mutable length : int;
  initial_buffer : bytes}

let create n =
 let n = if n < 1 then 1 else n in
 
 let n = if n > Sys.max_string_length then Sys.max_string_length else n in
 
 let s = Bytes.create n in
 {buffer = s; position = 0; length = n; initial_buffer = s}

let contents b = Bytes.sub_string b.buffer 0 b.position
let to_bytes b = Bytes.sub b.buffer 0 b.position 

let sub b ofs len =
  if ofs < 0 || len < 0 || ofs > b.position - len
  then invalid_arg "Buffer.sub"
  else Bytes.sub_string b.buffer ofs len


let blit src srcoff dst dstoff len =
  if len < 0 || srcoff < 0 || srcoff > src.position - len
             || dstoff < 0 || dstoff > (Bytes.length dst) - len
  then invalid_arg "Buffer.blit"
  else
    Bytes.unsafe_blit src.buffer srcoff dst dstoff len

let length b = b.position
let is_empty b = b.position = 0
let clear b = b.position <- 0

let reset b =
  b.position <- 0; b.buffer <- b.initial_buffer;
  b.length <- Bytes.length b.buffer

let resize b more =
  let len = b.length in
  let new_len = ref len in
  while b.position + more > !new_len do new_len := 2 * !new_len done;
   
  if !new_len > Sys.max_string_length then begin
    if b.position + more <= Sys.max_string_length
    then new_len := Sys.max_string_length
    else failwith "Buffer.add: cannot grow buffer"
  end;
  
  let new_buffer = Bytes.create !new_len in
  (* PR#6148: let's keep using [blit] rather than [unsafe_blit] in
     this tricky function that is slow anyway. *)
  Bytes.blit b.buffer 0 new_buffer 0 b.position;
  b.buffer <- new_buffer;
  b.length <- !new_len  

let add_char b c =
  let pos = b.position in
  if pos >= b.length then resize b 1;
  Bytes.unsafe_set b.buffer pos c;
  b.position <- pos + 1  

let add_substring b s offset len =
  if offset < 0 || len < 0 || offset > String.length s - len
  then invalid_arg "Buffer.add_substring/add_subbytes";
  let new_position = b.position + len in
  if new_position > b.length then resize b len;
  Bytes.blit_string s offset b.buffer b.position len;
  b.position <- new_position  


let add_subbytes b s offset len =
  add_substring b (Bytes.unsafe_to_string s) offset len

let add_string b s =
  let len = String.length s in
  let new_position = b.position + len in
  if new_position > b.length then resize b len;
  Bytes.blit_string s 0 b.buffer b.position len;
  b.position <- new_position  

let add_bytes b s = add_string b (Bytes.unsafe_to_string s)

let add_buffer b bs =
  add_subbytes b bs.buffer 0 bs.position

let add_channel b ic len =
  if len < 0 

    || len > Sys.max_string_length 

    then   (* PR#5004 *)
    invalid_arg "Buffer.add_channel";
  if b.position + len > b.length then resize b len;
  really_input ic b.buffer b.position len;
  b.position <- b.position + len

let output_buffer oc b =
  output oc b.buffer 0 b.position  

external unsafe_string: bytes -> int -> int -> Digest.t = "caml_md5_string"

let digest b = 
  unsafe_string 
  b.buffer 0 b.position    

let rec not_equal_aux (b : bytes) (s : string) i len = 
    if i >= len then false
    else 
      (Bytes.unsafe_get b i 
      <>
      String.unsafe_get s i )
      || not_equal_aux b s (i + 1) len 

(** avoid a large copy *)
let not_equal  (b : t) (s : string) = 
  let b_len = b.position in 
  let s_len = String.length s in 
  b_len <> s_len 
  || not_equal_aux b.buffer s 0 s_len


end
module Ext_filename : sig 
#1 "ext_filename.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)





(* TODO:
   Change the module name, this code is not really an extension of the standard 
    library but rather specific to JS Module name convention. 
*)





(** An extension module to calculate relative path follow node/npm style. 
    TODO : this short name will have to change upon renaming the file.
*)


val maybe_quote:
  string -> 
  string

val chop_extension_maybe:
  string -> 
  string

val new_extension:  
  string -> 
  string -> 
  string

val chop_all_extensions_maybe:
  string -> 
  string  

(* OCaml specific abstraction*)
val module_name:  
  string ->
  string

(** return [true] if upper case *)
val module_name_with_case:  
  string -> 
  string * bool
  
end = struct
#1 "ext_filename.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)




let is_dir_sep_unix c = c = '/'
let is_dir_sep_win_cygwin c = 
  c = '/' || c = '\\' || c = ':'

let is_dir_sep = 
  if Sys.unix then is_dir_sep_unix else is_dir_sep_win_cygwin

(* reference ninja.cc IsKnownShellSafeCharacter *)
let maybe_quote ( s : string) = 
  let noneed_quote = 
    Ext_string.for_all s (function
        | '0' .. '9' 
        | 'a' .. 'z' 
        | 'A' .. 'Z'
        | '_' | '+' 
        | '-' | '.'
        | '/' -> true
        | _ -> false
      )  in 
  if noneed_quote then
    s
  else Filename.quote s 


let chop_extension_maybe name =
  let rec search_dot i =
    if i < 0 || is_dir_sep (String.unsafe_get name i) then name
    else if String.unsafe_get name i = '.' then String.sub name 0 i
    else search_dot (i - 1) in
  search_dot (String.length name - 1)

let chop_all_extensions_maybe name =
  let rec search_dot i last =
    if i < 0 || is_dir_sep (String.unsafe_get name i) then 
      (match last with 
      | None -> name
      | Some i -> String.sub name 0 i)  
    else if String.unsafe_get name i = '.' then 
      search_dot (i - 1) (Some i)
    else search_dot (i - 1) last in
  search_dot (String.length name - 1) None


let new_extension name (ext : string) = 
  let rec search_dot name i ext =
    if i < 0 || is_dir_sep (String.unsafe_get name i) then 
      name ^ ext 
    else if String.unsafe_get name i = '.' then 
      let ext_len = String.length ext in
      let buf = Bytes.create (i + ext_len) in 
      Bytes.blit_string name 0 buf 0 i;
      Bytes.blit_string ext 0 buf i ext_len;
      Bytes.unsafe_to_string buf
    else search_dot name (i - 1) ext  in
  search_dot name (String.length name - 1) ext



(** TODO: improve efficiency
   given a path, calcuate its module name 
   Note that `ocamlc.opt -c aa.xx.mli` gives `aa.xx.cmi`
   we can not strip all extensions, otherwise
   we can not tell the difference between "x.cpp.ml" 
   and "x.ml"
*)
let module_name name = 
  let rec search_dot i  name =
    if i < 0  then 
      Ext_string.capitalize_ascii name
    else 
    if String.unsafe_get name i = '.' then 
      Ext_string.capitalize_sub name i 
    else 
      search_dot (i - 1) name in  
  let name = Filename.basename  name in 
  let name_len = String.length name in 
  search_dot (name_len - 1)  name 


let module_name_with_case name =  
  let rec search_dot i  name =
    if i < 0  then 
      Ext_string.capitalize_ascii name
    else 
    if String.unsafe_get name i = '.' then 
      Ext_string.capitalize_sub name i 
    else 
      search_dot (i - 1) name in  
  let name = Filename.basename  name in 
  let name_len = String.length name in 
  search_dot (name_len - 1)  name, 
  (name_len > 0 &&
    let first_char = String.unsafe_get name 0 in
    (first_char >= 'A' && first_char <= 'Z'))

end
module Ext_namespace : sig 
#1 "ext_namespace.mli"
(* Copyright (C) 2017- Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

(** [make ~ns:"Ns" "a" ]
    A typical example would return "a-Ns"
    Note the namespace comes from the output of [namespace_of_package_name]
*)
val make : ns:string -> string -> string 

val try_split_module_name :
  string -> (string * string ) option



(* Note  we have to output uncapitalized file Name, 
   or at least be consistent, since by reading cmi file on Case insensitive OS, we don't really know it is `list.cmi` or `List.cmi`, so that `require (./list.js)` or `require(./List.js)`
   relevant issues: #1609, #913  

   #1933 when removing ns suffix, don't pass the bound
   of basename
*)
val js_name_of_basename :  
  bool ->
  string -> string 

type file_kind = 
  | Upper_js
  | Upper_bs
  | Little_js 
  | Little_bs 
  (** [js_name_of_modulename ~little A-Ns]
  *)
val js_name_of_modulename : file_kind -> string -> string

(* TODO handle cases like 
   '@angular/core'
   its directory structure is like 
   {[
     @angular
     |-------- core
   ]}
*)
val is_valid_npm_package_name : string -> bool 

val namespace_of_package_name : string -> string

end = struct
#1 "ext_namespace.ml"

(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


(* Note the build system should check the validity of filenames
   espeically, it should not contain '-'
*)
let ns_sep_char = '-'
let ns_sep = "-"

let make ~ns cunit  = 
  cunit ^ ns_sep ^ ns

let path_char = Filename.dir_sep.[0]

let rec rindex_rec s i  =
  if i < 0 then i else
    let char = String.unsafe_get s i in
    if char = path_char then -1 
    else if char = ns_sep_char then i 
    else
      rindex_rec s (i - 1) 

let remove_ns_suffix name =
  let i = rindex_rec name (String.length name - 1)  in 
  if i < 0 then name 
  else String.sub name 0 i 

let try_split_module_name name = 
  let len = String.length name in 
  let i = rindex_rec name (len - 1)  in 
  if i < 0 then None 
  else 
    Some (String.sub name (i+1) (len - i - 1),
          String.sub name 0 i )
type file_kind = 
  | Upper_js
  | Upper_bs
  | Little_js 
  | Little_bs

let suffix_js = ".js"  
let bs_suffix_js = ".bs.js"

(* let ends_with_bs_suffix_then_chop s = 
  Ext_string.ends_with_then_chop s bs_suffix_js *)
  
let js_name_of_basename bs_suffix s =   
  remove_ns_suffix  s ^ 
  (if bs_suffix then bs_suffix_js else  suffix_js )

let js_name_of_modulename little s = 
  match little with 
  | Little_js -> 
    remove_ns_suffix (Ext_string.uncapitalize_ascii s) ^ suffix_js
  | Little_bs -> 
    remove_ns_suffix (Ext_string.uncapitalize_ascii s) ^ bs_suffix_js
  | Upper_js ->
    remove_ns_suffix s ^ suffix_js
  | Upper_bs -> 
    remove_ns_suffix s ^ bs_suffix_js

(* https://docs.npmjs.com/files/package.json 
   Some rules:
   The name must be less than or equal to 214 characters. This includes the scope for scoped packages.
   The name can't start with a dot or an underscore.
   New packages must not have uppercase letters in the name.
   The name ends up being part of a URL, an argument on the command line, and a folder name. Therefore, the name can't contain any non-URL-safe characters.
*)
let is_valid_npm_package_name (s : string) = 
  let len = String.length s in 
  len <= 214 && (* magic number forced by npm *)
  len > 0 &&
  match String.unsafe_get s 0 with 
  | 'a' .. 'z' | '@' -> 
    Ext_string.for_all_from s 1 
      (fun x -> 
         match x with 
         |  'a'..'z' | '0'..'9' | '_' | '-' -> true
         | _ -> false )
  | _ -> false 


let namespace_of_package_name (s : string) : string = 
  let len = String.length s in 
  let buf = Buffer.create len in 
  let add capital ch = 
    Buffer.add_char buf 
      (if capital then 
         (Ext_char.uppercase_ascii ch)
       else ch) in    
  let rec aux capital off len =     
    if off >= len then ()
    else 
      let ch = String.unsafe_get s off in
      match ch with 
      | 'a' .. 'z' 
      | 'A' .. 'Z' 
      | '0' .. '9'
        ->
        add capital ch ; 
        aux false (off + 1) len 
      | '/'
      | '-' -> 
        aux true (off + 1) len 
      | _ -> aux capital (off+1) len
  in 
  aux true 0 len ;
  Buffer.contents buf 

end
module Ext_option : sig 
#1 "ext_option.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)








(** Utilities for [option] type *)

val map : 'a option -> ('a -> 'b) -> 'b option

val iter : 'a option -> ('a -> unit) -> unit

val exists : 'a option -> ('a -> bool) -> bool
end = struct
#1 "ext_option.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)








let map v f = 
  match v with 
  | None -> None
  | Some x -> Some (f x )

let iter v f =   
  match v with 
  | None -> ()
  | Some x -> f x 

let exists v f =    
  match v with 
  | None -> false
  | Some x -> f x 
end
module Bsb_helper_depfile_gen : sig 
#1 "bsb_helper_depfile_gen.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

type kind = Js | Bytecode | Native

(** [deps_of_channel ic]
    given an input_channel dumps all modules it depend on, only used for debugging 
*)
val deps_of_channel : in_channel -> string list



val emit_d:  
  Bsb_dir_index.t ->  
  string  option ->
  string ->
  string -> (* empty string means no mliast *)
  unit
end = struct
#1 "bsb_helper_depfile_gen.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)



let dep_lit = " : "
let write_buf name buf  =     
  let oc = open_out_bin name in 
  Ext_buffer.output_buffer oc buf ;
  close_out oc 

(* should be good for small file *)
let load_file name (buf : Ext_buffer.t): unit  = 
  let len = Ext_buffer.length buf in 
  let ic = open_in_bin name in 
  let n = in_channel_length ic in   
  if n <> len then begin close_in ic ; write_buf name buf  end 
  else
    let holder = really_input_string ic  n in 
    close_in ic ; 
    if Ext_buffer.not_equal buf holder then 
      write_buf name buf 
;;
let write_file name  (buf : Ext_buffer.t) = 
  if Sys.file_exists name then 
    load_file name buf 
  else 
    write_buf name buf 
    
(* return an non-decoded string *)
let extract_dep_raw_string (fn : string) : string =   
  let ic = open_in_bin fn in 
  let size = input_binary_int ic in 
  let s = really_input_string ic size in
  close_in ic;
  s

(* Make sure it is the same as {!Binary_ast.magic_sep_char}*)
let magic_sep_char = '\n'

let deps_of_channel (ic : in_channel) : string list = 
  let size = input_binary_int ic in 
  let s = really_input_string ic size in   
  let rec aux (s : string) acc (offset : int) size : string list = 
    if offset < size then
      let next_tab = String.index_from s offset magic_sep_char in        
      aux s 
        (String.sub s offset (next_tab - offset)::acc) (next_tab + 1) 
        size
    else acc    
  in 
  aux s [] 1 size 

  



(** Please refer to {!Binary_ast} for encoding format, we move it here 
    mostly for cutting the dependency so that [bsb_helper.exe] does
    not depend on compler-libs
*)
let read_deps (fn : string) : string list = 
  let ic = open_in_bin fn in 
  let v = deps_of_channel ic in 
  close_in ic;
  v


type kind = Js | Bytecode | Native

let output_file (buf : Ext_buffer.t) source namespace = 
  Ext_buffer.add_string buf (match namespace with 
      | None ->  source 
      | Some ns ->
        Ext_namespace.make ~ns source)

(** for bucklescript artifacts 
    [lhs_suffix] is [.cmj]
    [rhs_suffix] 
    is [.cmj] if it has [ml] (in this case does not care about mli or not)
    is [.cmi] if it has [mli]
*)
let oc_cmi buf namespace source = 
  Ext_buffer.add_char buf ' ';  
  output_file buf source namespace;
  Ext_buffer.add_string buf Literals.suffix_cmi 


(* For cases with self cycle
    e.g, in b.ml
    {[
      include B
    ]}
    When ns is not turned on, it makes sense that b may come from third party package.
    Hoever, this case is wont supported. 
    It complicates when it has interface file or not.
    - if it has interface file, the current interface will have priority, failed to build?
    - if it does not have interface file, the build will not open this module at all(-bs-read-cmi)

    When ns is turned on, `B` is interprted as `Ns-B` which is a cyclic dependency,
    it can be errored out earlier
*)
let find_module db dependent_module is_not_lib_dir (index : Bsb_dir_index.t) = 
  let opt = Bsb_db_decode.find_opt db 0 dependent_module in 
  match opt with 
  | Some _ -> opt
  | None -> 
    if is_not_lib_dir then 
      Bsb_db_decode.find_opt db (index :> int) dependent_module 
    else None 
let oc_impl 
    (mlast : string)
    (index : Bsb_dir_index.t)
    (db : Bsb_db_decode.t)
    (namespace : string option)
    (buf : Ext_buffer.t)
    (lhs_suffix : string)
    (rhs_suffix : string)
  = 
  (* TODO: move namespace upper, it is better to resolve ealier *)  
  let has_deps = ref false in 
  let cur_module_name = Ext_filename.module_name mlast  in
  let at_most_once : unit lazy_t  = lazy (
    has_deps := true ;
    output_file buf (Ext_filename.chop_extension_maybe mlast) namespace ; 
    Ext_buffer.add_string buf lhs_suffix; 
    Ext_buffer.add_string buf dep_lit ) in  
  Ext_option.iter namespace (fun ns -> 
      Lazy.force at_most_once;
      Ext_buffer.add_string buf ns;
      Ext_buffer.add_string buf Literals.suffix_cmi;
    ) ; (* TODO: moved into static files*)
  let is_not_lib_dir = not (Bsb_dir_index.is_lib_dir index) in 
  let s = extract_dep_raw_string mlast in 
  let offset = ref 1 in 
  let size = String.length s in 
  while !offset < size do 
    let next_tab = String.index_from s !offset magic_sep_char in
    let dependent_module = String.sub s !offset (next_tab - !offset) in 
    (if dependent_module = cur_module_name then 
      begin
        prerr_endline ("FAILED: " ^ cur_module_name ^ " has a self cycle");
        exit 2
      end
    );
    (match  
      find_module db dependent_module is_not_lib_dir index  
    with      
    | None -> ()
    | Some ({dir_name; case }) -> 
      begin 
        Lazy.force at_most_once;
        let source = 
          Filename.concat dir_name
          (if case then 
            dependent_module
          else 
            Ext_string.uncapitalize_ascii dependent_module) in 
        Ext_buffer.add_char buf ' ';  
        output_file buf source namespace;
        Ext_buffer.add_string buf rhs_suffix;
        
        (* #3260 cmj changes does not imply cmi change anymore *)
        oc_cmi buf namespace source

      end);     
    offset := next_tab + 1  
  done ;
  if !has_deps then  
    Ext_buffer.add_char buf '\n'



(** Note since dependent file is [mli], it only depends on 
    [.cmi] file
*)
let oc_intf
    mliast    
    (index : Bsb_dir_index.t)
    (db : Bsb_db_decode.t)
    (namespace : string option)
    (buf : Ext_buffer.t) : unit =     
  
  let has_deps = ref false in  
  let at_most_once : unit lazy_t = lazy (  
    has_deps := true;
    output_file buf (Ext_filename.chop_all_extensions_maybe mliast) namespace ;   
    Ext_buffer.add_string buf Literals.suffix_cmi ; 
    Ext_buffer.add_string buf dep_lit) in 
  Ext_option.iter namespace (fun ns -> 
      Lazy.force at_most_once;  
      Ext_buffer.add_string buf ns;
      Ext_buffer.add_string buf Literals.suffix_cmi;
    ) ; 
  let cur_module_name = Ext_filename.module_name mliast in
  let is_not_lib_dir = not (Bsb_dir_index.is_lib_dir index)  in  
  let s = extract_dep_raw_string mliast in 
  let offset = ref 1 in 
  let size = String.length s in 
  while !offset < size do 
    let next_tab = String.index_from s !offset magic_sep_char in
    let dependent_module = String.sub s !offset (next_tab - !offset) in 
    (if dependent_module = cur_module_name then 
       begin
         prerr_endline ("FAILED: " ^ cur_module_name ^ " has a self cycle");
         exit 2
       end
    );
    (match  find_module db dependent_module is_not_lib_dir index 
     with     
     | None -> ()
     | Some {dir_name; case} -> 
       let source = 
        Filename.concat dir_name 
        (if case then dependent_module else
          Ext_string.uncapitalize_ascii dependent_module
        )
      in 
       Lazy.force at_most_once; 
       oc_cmi buf namespace source             
    );
    offset := next_tab + 1   
  done;  
  if !has_deps then
    Ext_buffer.add_char buf '\n'


let emit_d 
  (index : Bsb_dir_index.t) 
  (namespace : string option) (mlast : string) (mliast : string) = 
  let data  =
    Bsb_db_decode.read_build_cache 
      ~dir:Filename.current_dir_name in   
  let buf = Ext_buffer.create 2048 in 
  let filename = 
      Ext_filename.new_extension mlast Literals.suffix_d in   
  let lhs_suffix = Literals.suffix_cmj in   
  let rhs_suffix = Literals.suffix_cmj in 
  
  oc_impl 
    mlast
    index 
    data
    namespace
    buf 
    lhs_suffix 
    rhs_suffix ;      
  if mliast <> "" then begin
    oc_intf 
      mliast
      index 
      data 
      namespace 
      buf        
  end;          
  write_file filename buf 







end
module Bsb_helper_main : sig 
#1 "bsb_helper_main.mli"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


 (** Used to generate .d file, for example 
  {[
    bsb_helper.exe -g 0 -MD  src/hi/hello.ml
  ]}
  It will read the cache file and generate the corresponding
     [.d] file. This [.d] file will be used as attribute [depfile]
  whether we use namespace or not, the filename of [.mlast], [.d] 
  should be kept the same, we only need change the name of [.cm*]
  and the contents of filename in [.d]
 *)

end = struct
#1 "bsb_helper_main.ml"
(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

let batch_files = ref []
let collect_file name =
  batch_files := name :: !batch_files

(* let output_prefix = ref None *)
let dev_group = ref 0
let namespace = ref None


let anonymous filename =
  collect_file filename
let usage = "Usage: bsb_helper.exe [options] \nOptions are:"
  
let () =
  Arg.parse [
    "-g", Arg.Int (fun i -> dev_group := i ),
    " Set the dev group (default to be 0)"
    ;
    "-bs-ns", Arg.String (fun s -> namespace := Some s),
    " Set namespace";
    
  ] anonymous usage;
  (* arrange with mlast comes first *)
  match !batch_files with
  | [x]
    ->  Bsb_helper_depfile_gen.emit_d
          (Bsb_dir_index.of_int !dev_group )          
          !namespace x ""
  | [y; x] (* reverse order *)
    -> 
    Bsb_helper_depfile_gen.emit_d
      (Bsb_dir_index.of_int !dev_group)
      !namespace x y
  | _ -> 
    ()

end
