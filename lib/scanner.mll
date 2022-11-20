{
    open Parser
    open Printf

    (* Auxiliary definitions *)
    
    exception Lexing_error of Location.lexeme_pos * string

    let raise_except lexbuf msg =
        raise Lexing_error (Location.to_lexeme_position lexbuf) msg

    let create_hashtable size init = 
        let tbl = Hashtbl.create size
            in List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
            tbl

    let keyword_table =
    create_hashtable 10 [
        ("if", IF);
        ("else", ELSE);
        ("return", RETURN);
        ("for", FOR);
        ("while", WHILE);
        ("int", INT);
        ("char", CHAR);
        ("void", VOID);
        ("NULL", NULL);
        ("bool", BOOL)
    ]
}


let b10_digit = ['0'-'9']
let b16_digit = ['0'-'9' 'A'-'F']
let int = b10_digit+ | "0x" b16_digit+
let char = ['a'-'z' 'A'-'Z']
let bool = ["true" "false"]
let identifier = ['_' char] ['_' char b10_digit]*

(* Scanner specification *)

rule next_token = parse 
    | int as n { INT (int_of_string n) }
    | '\'' char '\'' as c { CHAR c }
    | bool as b { BOOL b }
    | identifier as word {  try 
                                Hashtbl.find keyword_table word
                            with Not_found ->
                                ID word }
    | "//" { inline_comment lexbuf }
    | "/*" { multiline_comment lexbuf }
    | '+' { ADD }
    | '-' { SUB }
    | '*' { MUL }
    | '/' { DIV }
    | '=' { ASSIGN }
    | "==" { EQ }
    | "!=" { NEQ }
    | '<' { LT }
    | '>' { GT }
    | "<=" { LTE }
    | ">=" { GTE }
    | "&&" { AND }
    | "||" { OR }
    | "!" { NOT }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | '[' { LSQUARE }
    | ']' { RSQUARE }
    | '{' { LCURLY }
    | '}' { RCURLY }
    | ';' { SEMICOLON }
    | eof        { EOF }
    | _ { raise_except lexbuf "Unrecognized character." }

and inline_comment = parse
    | newline { next_token lexbuf }
    | _ { inline_comment lexbuf }
    | eof {EOF}

and multiline_comment = Parser
    | "*/" { next_token lexbuf }
    | _ { multiline_comment lexbuf }
    | eof { raise_except lexbuf "Multi-line comment not closed." }