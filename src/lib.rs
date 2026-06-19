use std::fmt::Display;

mod egg;
pub mod parse;

type Name = String;

pub enum Term {
    Var(Name),
    Num(i64),
    Call(Name, Vec<Term>),
}

impl Display for Term {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Term::Var(v) => write!(f, "{}", v),
            Term::Num(n) => write!(f, "{}", n),
            Term::Call(func, args) => {
                write!(f, "({}", func)?;
                for arg in args {
                    write!(f, " {}", arg)?;
                }
                write!(f, ")")
            }
        }
    }
}

pub struct Program {
    pub sorts: Vec<Sort>,
    pub funcs: Vec<Function>,
    pub rewrites: Vec<Rewrite>,
    pub optimize: Vec<Optimize>,
}

impl Program {
    fn add_decl(&mut self, decl: Decl) -> Result<()> {
        match decl {
            Decl::Sort(s) => self.sorts.push(s),
            Decl::Function(f) => self.funcs.push(f),
            Decl::Rewrite(mut r) => {
                // unique-ify rewrite names by appending the current number of rewrites
                r.name = format!("{}.{}", r.name, self.rewrites.len());
                self.rewrites.push(r)
            }
            Decl::Optimize(o) => self.optimize.push(o),
        }
        Ok(())
    }

    fn from_decls(decls: Vec<Decl>) -> Result<Self> {
        let mut prog = Program {
            sorts: vec![],
            funcs: vec![],
            rewrites: vec![],
            optimize: vec![],
        };
        for decl in decls {
            prog.add_decl(decl)?;
        }
        Ok(prog)
    }

    fn from_str(s: &str) -> Result<Self> {
        let decls = parse::parse_decls(s)?;
        Self::from_decls(decls)
    }

    fn from_file(path: &str) -> Result<Self> {
        let src = std::fs::read_to_string(path).map_err(|e| e.to_string())?;
        Self::from_str(&src)
    }
}

pub enum Decl {
    Sort(Sort),
    Function(Function),
    Rewrite(Rewrite),
    Optimize(Optimize),
}

pub struct Sort {
    pub name: Name,
}

pub struct Function {
    pub name: Name,
    pub args: Vec<Name>,
    pub ret: Name,
}

pub struct Rewrite {
    pub name: Name,
    pub lhs: Term,
    pub rhs: Term,
}

pub struct Optimize {
    pub term: Term,
}

pub type Result<T> = std::result::Result<T, String>;

pub trait Solver: Sized {
    fn new() -> Self;
    fn declare_sort(&mut self, sort: &Sort) -> Result<()>;
    fn declare_function(&mut self, func: &Function) -> Result<()>;
    fn declare_rewrite(&mut self, rewrite: &Rewrite) -> Result<()>;
    fn optimize(&mut self, optimize: &Optimize) -> Result<Term>;
    fn run_program(prog: &Program) -> Result<Vec<Term>> {
        let mut solver = Self::new();

        for sort in &prog.sorts {
            solver.declare_sort(sort)?;
        }
        for func in &prog.funcs {
            solver.declare_function(func)?;
        }
        for rewrite in &prog.rewrites {
            solver.declare_rewrite(rewrite)?;
        }

        let mut results = Vec::new();
        for optimize in &prog.optimize {
            results.push(solver.optimize(optimize)?);
        }
        Ok(results)
    }

    fn parse_str_and_run(src: &str) -> Result<Vec<Term>> {
        let prog = Program::from_str(src)?;
        Self::run_program(&prog)
    }

    fn parse_file_and_run(path: &str) -> Result<Vec<Term>> {
        let prog = Program::from_file(path)?;
        Self::run_program(&prog)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_math() {
        let results = crate::egg::EggSolver::parse_file_and_run("benchmarks/math.lisp").unwrap();
        assert_eq!(results.len(), 1);
        for result in results {
            println!("Result: {}", result);
        }
    }
}
