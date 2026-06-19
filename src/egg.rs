use ::egg::{AstSize, ENodeOrVar, Extractor, RecExpr};
use ::egg::{Id, Pattern, PatternAst, Runner};
use ::egg::{Symbol, define_language};

use crate::*;

define_language! {
    pub enum Lang {
        Num(i64),
        Call(Symbol, Vec<Id>),
    }
}

type EggRewrite = ::egg::Rewrite<Lang, ()>;

#[derive(Default)]
pub struct EggSolver {
    rules: Vec<EggRewrite>,
    runner: Runner<Lang, ()>,
}

fn term_to_pattern(term: &Term) -> Pattern<Lang> {
    let mut pat = PatternAst::default();
    term_to_pattern_rec(term, &mut pat);
    Pattern::new(pat)
}

fn term_to_pattern_rec(term: &Term, pat: &mut PatternAst<Lang>) -> Id {
    match term {
        Term::Var(v) => pat.add(ENodeOrVar::Var(format!("?{v}").parse().unwrap())),
        Term::Num(n) => pat.add(ENodeOrVar::ENode(Lang::Num(*n))),
        Term::Call(f, terms) => {
            let children: Vec<Id> = terms.iter().map(|t| term_to_pattern_rec(t, pat)).collect();
            pat.add(ENodeOrVar::ENode(Lang::Call(f.parse().unwrap(), children)))
        }
    }
}

fn recexpr_to_term(expr: &RecExpr<Lang>, id: Id) -> Term {
    match &expr[id] {
        Lang::Num(n) => Term::Num(*n),
        Lang::Call(f, children) => {
            let terms = children.iter().map(|&c| recexpr_to_term(expr, c)).collect();
            Term::Call(f.to_string(), terms)
        }
    }
}

impl Solver for EggSolver {
    fn new() -> Self {
        Default::default()
    }

    fn declare_sort(&mut self, _sort: &Sort) -> Result<()> {
        Ok(())
    }

    fn declare_function(&mut self, _func: &Function) -> Result<()> {
        Ok(())
    }

    fn declare_rewrite(&mut self, rewrite: &Rewrite) -> Result<()> {
        let lhs = term_to_pattern(&rewrite.lhs);
        let rhs = term_to_pattern(&rewrite.rhs);

        let egg_rw = EggRewrite::new(&rewrite.name, lhs, rhs).map_err(|e| e.to_string())?;
        self.rules.push(egg_rw);
        Ok(())
    }

    fn optimize(&mut self, optimize: &Optimize) -> Result<Term> {
        let pat = term_to_pattern(&optimize.term);
        let term: RecExpr<Lang> = pat
            .ast
            .iter()
            .map(|enode| match enode {
                ENodeOrVar::Var(v) => {
                    panic!("Unexpected variable: {v}");
                }
                ENodeOrVar::ENode(enode) => enode.clone(),
            })
            .collect();

        self.runner = Runner::default().with_expr(&term).run(&self.rules);
        let ext = Extractor::new(&self.runner.egraph, AstSize);
        let (_best_cost, best_expr) = ext.find_best(self.runner.roots[0]);
        let best_term = recexpr_to_term(&best_expr, best_expr.root());
        Ok(best_term)
    }
}
