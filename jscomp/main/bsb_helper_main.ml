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
#if BS_NATIVE then

let main_module = ref None

let set_main_module modulename =
  main_module := Some modulename

let includes :  _ list ref = ref []

let add_include =
  let normalize cwd s =
    Ext_path.normalize_absolute_path (Ext_path.combine cwd s) in
  fun dir ->
    includes := (normalize (Sys.getcwd ()) dir) :: !includes
#end
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
