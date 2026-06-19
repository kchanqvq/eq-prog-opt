use crate::*;

peg::parser! {
    grammar sexp_parser() for str {
        rule ws_char()
            = [' ' | '\t' | '\n' | '\r']

        rule comment()
            = ";" [^'\n']* ("\n" / ![_])

        rule ws()
            = (ws_char() / comment())*

        rule atom_text() -> String
            = s:$((!(['(' | ')' | ';'] / ws_char()) [_])+) { s.to_string() }

        rule int_lit() -> i64
            = n:$("-"? ['0'..='9']+) {? n.parse().map_err(|_| "invalid integer") }

        rule string_lit() -> String
            = "\"" s:$([^'\"']*) "\"" { s.to_string() }

        rule term_atom() -> Term
            = n:int_lit() { Term::Num(n) }
            / s:string_lit() { Term::Call(s, vec![]) }
            / v:atom_text() { Term::Var(v) }

        rule term_list() -> Term
            = "(" ws() f:atom_text() args:(ws() t:term() { t })* ws() ")" {
                Term::Call(f, args)
            }

        rule term() -> Term
            = ws() t:(term_list() / term_atom()) ws() { t }

        rule sort_decl() -> Decl
            = "(" ws() "sort" ws() name:atom_text() ws() ")" {
                Decl::Sort(Sort { name })
            }

        rule function_decl() -> Decl
            = "(" ws() "function" ws() name:atom_text() ws()
              "(" args:(ws() a:atom_text() { a })* ws() ")" ws()
              ret:atom_text() ws() ")" {
                Decl::Function(Function { name, args, ret })
            }

        rule rewrite_decl() -> Decl
            = "(" ws() "rewrite" ws() name:atom_text() ws() lhs:term() ws() rhs:term() ws() ")" {
                Decl::Rewrite(Rewrite { name, lhs, rhs })
            }
            / "(" ws() "rewrite" ws() lhs:term() ws() rhs:term() ws() ")" {
                Decl::Rewrite(Rewrite { name: String::new(), lhs, rhs })
            }

        rule optimize_decl() -> Decl
            = "(" ws() "optimize" ws() term:term() ws() ")" {
                Decl::Optimize(Optimize { term })
            }

        rule decl() -> Decl
            = sort_decl() / function_decl() / rewrite_decl() / optimize_decl()

        pub rule parse_term() -> Term
            = ws() t:(term_list() / term_atom()) ws() ![_] { t }

        pub rule parse_decl() -> Decl
            = ws() d:decl() ws() ![_] { d }

        pub rule parse_decls() -> Vec<Decl>
            = ws() ds:(decl() ** ws()) ws() ![_] { ds }
    }
}

pub fn parse_term(input: &str) -> Result<Term> {
    sexp_parser::parse_term(input).map_err(|e| e.to_string())
}

pub fn parse_decl(input: &str) -> Result<Decl> {
    sexp_parser::parse_decl(input).map_err(|e| e.to_string())
}

pub fn parse_decls(input: &str) -> Result<Vec<Decl>> {
    sexp_parser::parse_decls(input).map_err(|e| e.to_string())
}
