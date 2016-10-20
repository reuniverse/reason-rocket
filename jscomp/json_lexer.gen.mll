{
type error =
  | Illegal_character of char
  | Unterminated_string
  | Illegal_escape of string
  | Unexpected_token 
  | Expect_comma_or_rbracket
  | Expect_comma_or_rbrace
  | Expect_colon
  | Expect_string_or_rbrace 
  | Expect_eof 
exception Error of error * Lexing.position * Lexing.position;;

type path = string list 



type token = 
  | Comma
  | Eof
  | False
  | Lbrace
  | Lbracket
  | Null
  | Colon
  | Number of string
  | Rbrace
  | Rbracket
  | String of string
  | True   
  

let error  (lexbuf : Lexing.lexbuf) e = 
  raise (Error (e, lexbuf.lex_start_p, lexbuf.lex_curr_p))

let lexeme_len (x : Lexing.lexbuf) =
  x.lex_curr_pos - x.lex_start_pos

let update_loc ({ lex_curr_p; _ } as lexbuf : Lexing.lexbuf) diff =
  lexbuf.lex_curr_p <-
    {
      lex_curr_p with
      pos_lnum = lex_curr_p.pos_lnum + 1;
      pos_bol = lex_curr_p.pos_cnum - diff;
    }

let char_for_backslash = function
  | 'n' -> '\010'
  | 'r' -> '\013'
  | 'b' -> '\008'
  | 't' -> '\009'
  | c -> c

let dec_code c1 c2 c3 =
  100 * (Char.code c1 - 48) + 10 * (Char.code c2 - 48) + (Char.code c3 - 48)

let hex_code c1 c2 =
  let d1 = Char.code c1 in
  let val1 =
    if d1 >= 97 then d1 - 87
    else if d1 >= 65 then d1 - 55
    else d1 - 48 in
  let d2 = Char.code c2 in
  let val2 =
    if d2 >= 97 then d2 - 87
    else if d2 >= 65 then d2 - 55
    else d2 - 48 in
  val1 * 16 + val2

let lf = '\010'
}

let lf = '\010'
let lf_cr = ['\010' '\013']
let dos_newline = "\013\010"
let blank = [' ' '\009' '\012']

let digit = ['0'-'9']
let nonzero = ['1'-'9']
let digits = digit +
let frac = '.' digits
let e = ['e' 'E']['+' '-']?
let exp = e digits
let positive_int = (digit | nonzero digits)
let number = '-'? positive_int (frac | exp | frac exp) ?
let hexdigit = digit | ['a'-'f' 'A'-'F']    
rule lex_json buf  = parse
| blank + { lex_json buf lexbuf}
| lf | dos_newline { 
    update_loc lexbuf 0;
    lex_json buf  lexbuf
  }

| "true" { True}
| "false" {False}
| "null" {Null}
| "["  {Lbracket}
| "]"  {Rbracket}
| "{"  {Lbrace}
| "}"  {Rbrace}
| ","  {Comma}
| ':'   {Colon}
| ("//" (_ # lf_cr)*) {lex_json buf lexbuf}

| number { Number (Lexing.lexeme lexbuf)}

| '"' {
  let pos = Lexing.lexeme_start_p lexbuf in
  scan_string buf pos lexbuf;
  let content = (Buffer.contents  buf) in 
  Buffer.clear buf ;
  String content 
}
| eof  {Eof }
| _ as c  { error lexbuf (Illegal_character c )}

(* Note this is wrong for JSON conversion *)
(* We should fix it later *)
and scan_string buf start = parse
| '"' { () }
| '\\' lf [' ' '\t']*
  {
        let len = lexeme_len lexbuf - 2 in
        update_loc lexbuf len;

        scan_string buf start lexbuf
      }
| '\\' dos_newline [' ' '\t']*
      {
        let len = lexeme_len lexbuf - 3 in
        update_loc lexbuf len;
        scan_string buf start lexbuf
      }
| '\\' (['\\' '\'' '"' 'n' 't' 'b' 'r' ' '] as c)
      {
        Buffer.add_char buf (char_for_backslash c);
        scan_string buf start lexbuf
      }
| '\\' (digit as c1) (digit as c2) (digit as c3) as s 
      {
        let v = dec_code c1 c2 c3 in
        if v > 255 then
          error lexbuf (Illegal_escape s) ;
        Buffer.add_char buf (Char.chr v);

        scan_string buf start lexbuf
      }
| '\\' 'x' (hexdigit as c1) (hexdigit as c2)
      {
        let v = hex_code c1 c2 in
        Buffer.add_char buf (Char.chr v);

        scan_string buf start lexbuf
      }
| '\\' (_ as c)
      {
        Buffer.add_char buf '\\';
        Buffer.add_char buf c;

        scan_string buf start lexbuf
      }
| lf
      {
        update_loc lexbuf 0;
        Buffer.add_char buf lf;

        scan_string buf start lexbuf
      }
| ([^ '\\' '"'] # lf)+
      {
        let ofs = lexbuf.lex_start_pos in
        let len = lexbuf.lex_curr_pos - ofs in
        Buffer.add_substring buf lexbuf.lex_buffer ofs len;

        scan_string buf start lexbuf
      }
| eof
      {
        error lexbuf Unterminated_string
      }

{

type js_array =
  { content : t array ; 
    loc_start : Lexing.position ; 
    loc_finish : Lexing.position ; 
  }
and t = 
  [  
    `True
  | `False
  | `Null
  | `Flo of string 
  | `Str of string 
  | `Arr  of js_array
  | `Obj of t String_map.t 
   ]

type status = 
  | No_path
  | Found  of t 
  | Wrong_type of path 



let rec parse_json lexbuf =
  let buf = Buffer.create 64 in 
  let look_ahead = ref None in
  let token () : token = 
    match !look_ahead with 
    | None ->  
      lex_json buf lexbuf 
    | Some x -> 
      look_ahead := None ;
      x 
  in
  let push e = look_ahead := Some e in 
  let rec json (lexbuf : Lexing.lexbuf) = 
    match token () with 
    | True -> `True
    | False -> `False
    | Null -> `Null
    | Number s ->  `Flo s 
    | String s -> `Str s 
    | Lbracket -> parse_array lexbuf.lex_start_p lexbuf.lex_curr_p [] lexbuf
    | Lbrace -> parse_map String_map.empty lexbuf
    |  _ -> error lexbuf Unexpected_token
  and parse_array  loc_start loc_finish acc lexbuf =
    match token () with 
    | Rbracket -> `Arr {loc_start ; content = Ext_array.reverse_of_list acc ; 
                            loc_finish = lexbuf.lex_curr_p }
    | x -> 
      push x ;
      let new_one = json lexbuf in 
      begin match token ()  with 
      | Comma -> 
          parse_array loc_start loc_finish (new_one :: acc) lexbuf 
      | Rbracket 
        -> `Arr {content = (Ext_array.reverse_of_list (new_one::acc));
                     loc_start ; 
                     loc_finish = lexbuf.lex_curr_p }
      | _ -> 
        error lexbuf Expect_comma_or_rbracket
      end
  and parse_map acc lexbuf = 
    match token () with 
    | Rbrace -> `Obj acc 
    | String key -> 
      begin match token () with 
      | Colon ->
        let value = json lexbuf in
        begin match token () with 
        | Rbrace -> `Obj (String_map.add key value acc )
        | Comma -> 
          parse_map (String_map.add key value acc) lexbuf 
        | _ -> error lexbuf Expect_comma_or_rbrace
        end
      | _ -> error lexbuf Expect_colon
      end
    | _ -> error lexbuf Expect_string_or_rbrace
  in 
  let v = json lexbuf in 
  match token () with 
  | Eof -> v 
  | _ -> error lexbuf Expect_eof

let parse_json_from_string s = 
  parse_json (Lexing.from_string s )

let parse_json_from_file s = 
  let in_chan = open_in s in 
  let lexbuf = Lexing.from_channel in_chan in 
  match parse_json lexbuf with 
  | exception e -> close_in in_chan ; raise e
  | v  -> close_in in_chan;  v


type callback = 
  [
    `Str of (string -> unit) 
  | `Flo of (string -> unit )
  | `Bool of (bool -> unit )
  | `Obj of (t String_map.t -> unit)
  | `Arr of (t array -> unit )
  | `Null of (unit -> unit)
  ]

let test   ?(fail=(fun () -> ())) key 
    (cb : callback) m 
     =
     begin match String_map.find key m, cb with 
       | exception Not_found -> fail ()
       | `True, `Bool cb -> cb true
       | `False, `Bool cb  -> cb false 
       | `Flo s , `Flo cb  -> cb s 
       | `Obj b , `Obj cb -> cb b 
       | `Arr {content}, `Arr cb -> cb content 
       | `Null, `Null cb  -> cb ()
       | `Str s, `Str cb  -> cb s 
       | _, _ -> fail () 
     end;
     m
let query path (json : t ) =
  let rec aux acc paths json =
    match path with 
    | [] ->  Found json
    | p :: rest -> 
      begin match json with 
        | `Obj m -> 
          begin match String_map.find p m with 
            | m' -> aux (p::acc) rest m'
            | exception Not_found ->  No_path
          end
        | _ -> Wrong_type acc 
      end
  in aux [] path json
}