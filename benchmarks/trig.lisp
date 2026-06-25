(sort Trig)

(function Num (i64) Trig)
(function Var (String) Trig)
(function Tan (Trig) Trig)
(function Cot (Trig) Trig)
(function Sin (Trig) Trig)
(function Cos (Trig) Trig)
(function Div (Trig Trig) Trig) 
(function Add (Trig Trig) Trig) 
(function Sub (Trig Trig) Trig) 
(function Mul (Trig Trig) Trig) 
(function Pow (Trig Trig) Trig) 
(function Sec (Trig) Trig)
(function Csc (Trig) Trig)

(== (Tan x) (Div (Sin x) (Cos x))) 
(== (Cot x) (Div (Cos x) (Sin x))) 
(== (Sec x) (Div (Num 1) (Cos x))) 
(== (Csc x) (Div (Num 1) (Sin x))) 

(== (Add (Pow (Sin x) (Num 2)) (Pow (Cos x) (Num 2))) (Num 1))
(== (Pow (Sin x) (Num 2)) (Sub (Num 1) (Pow (Cos x) (Num 2)))) 
(== (Pow (Cos x) (Num 2)) (Sub (Num 1) (Pow (Sin x) (Num 2)))) 
(== (Add (Num 1) (Pow (Tan x) (Num 2))) (Pow (Sec x) (Num 2))) 
(== (Add (Num 1) (Pow (Cot x) (Num 2))) (Pow (Csc x) (Num 2))) 

(== (Add a b) (Add b a))
(== (Mul a b) (Mul b a))
(== (Add (Add a b) c) (Add a (Add b c))) 
(== (Mul (Mul a b) c) (Mul a (Mul b c))) 

(== (Mul a (Add b c)) (Add (Mul a b) (Mul a c))) 
(== (Sub (Mul a b) (Mul a c)) (Mul a (Sub b c)))

(== (Add a (Num 0)) a) 
(== (Mul a (Num 1)) a) 
(== (Mul a (Num 0)) (Num 0))
(== (Add a (Mul (Num -1) a)) (Num 0))
(=> (Mul a (Div (Num 1) a)) (Num 1)) 
(== (Mul (Num -1) (Mul (Num -1) a)) a)

(== (Sub a b) (Add a (Mul (Num -1) b))) 
(== (Div a b) (Mul a (Div (Num 1) b))) 

(== (Add (Div a b) (Div c d)) (Div (Add (Mul a d) (Mul b c)) (Mul b d))) 
(== (Add (Div a b) (Div c b)) (Div (Add a c) b)) 
(== (Mul (Div a b) (Div c d)) (Div (Mul a c) (Mul b d))) 
(=> (Div (Num 1) (Div a b)) (Div b a)) 
(=> (Div b a) (Div (Num 1) (Div a b)) :guard (non-zero? b))
(=> (Div (Mul a c) (Mul b c)) (Div a b)) 
(== (Div (Add a c) c) (Add (Div a c) (Num 1)))

(== (Pow a (Num 2)) (Mul a a)) 
(== (Pow a (Num 3)) (Mul a (Pow a (Num 2)))) 
(== (Pow a (Num 4)) (Pow (Pow a (Num 2)) (Num 2))) 
(== (Pow (Mul a b) n) (Mul (Pow a n) (Pow b n))) 
(== (Pow (Div a b) n) (Div (Pow a n) (Pow b n))) 
(== (Sub (Pow a (Num 2)) (Pow b (Num 2))) (Mul (Add a b) (Sub a b))) 
(== (Add (Pow a (Num 3)) (Pow b (Num 3))) (Mul (Add a b) (Add (Sub (Pow a (Num 2)) (Mul a b)) (Pow b (Num 2))))) 
(== (Sub (Pow a (Num 3)) (Pow b (Num 3))) (Mul (Sub a b) (Add (Add (Pow a (Num 2)) (Mul a b)) (Pow b (Num 2)))))

(optimize
 (Mul (Mul (Sin (Var "t")) (Cos (Var "t")))
      (Add (Tan (Var "t")) (Cot (Var "t")))))
(optimize (Sub (Pow (Sin (Var "t")) (Num 4)) (Pow (Cos (Var "t")) (Num 4)))) 
(optimize
 (Add (Sub (Pow (Sin (Var "t")) (Num 4)) (Pow (Cos (Var "t")) (Num 4)))
      (Num 1)))
(optimize (Sub (Pow (Cos (Var "t")) (Num 4)) (Pow (Sin (Var "t")) (Num 4)))) 
(optimize
 (Mul (Mul (Sin (Var "a")) (Cos (Var "a")))
      (Sub (Tan (Var "a")) (Cot (Var "a")))))
(optimize
 (Add (Pow (Add (Cos (Var "a")) (Sin (Var "a"))) (Num 2))
      (Pow (Sub (Cos (Var "a")) (Sin (Var "a"))) (Num 2))))
(optimize
 (Add (Pow (Add (Num 1) (Tan (Var "t"))) (Num 2))
      (Pow (Sub (Num 1) (Tan (Var "t"))) (Num 2))))
(optimize
 (Add (Div (Num 1) (Add (Num 1) (Cos (Var "a"))))
      (Div (Num 1) (Sub (Num 1) (Cos (Var "a"))))))
(optimize (Div (Add (Num 1) (Cos (Var "t"))) (Sub (Num 1) (Cos (Var "t"))))) 
(optimize
 (Sub (Div (Num 1) (Sub (Num 1) (Sin (Var "a"))))
      (Div (Num 1) (Add (Num 1) (Sin (Var "a"))))))
(optimize
 (Add (Div (Num 1) (Sub (Num 1) (Cos (Var "a"))))
      (Div (Num 1) (Add (Num 1) (Cos (Var "a"))))))
(optimize
 (Mul (Add (Add (Num 1) (Sec (Var "a"))) (Tan (Var "a")))
      (Add (Sub (Num 1) (Csc (Var "a"))) (Cot (Var "a")))))
(optimize
 (Add (Div (Cos (Var "a")) (Add (Num 1) (Sin (Var "a"))))
      (Div (Cos (Var "a")) (Sub (Num 1) (Sin (Var "a"))))))
(optimize
 (Add (Div (Num 1) (Sub (Num 1) (Sin (Var "a"))))
      (Div (Num 1) (Add (Num 1) (Sin (Var "a"))))))
(optimize
 (Add (Div (Num 1) (Add (Sin (Var "a")) (Cos (Var "a"))))
      (Div (Num 1) (Sub (Sin (Var "a")) (Cos (Var "a"))))))
(optimize (Div (Add (Num 1) (Sin (Var "t"))) (Sub (Num 1) (Sin (Var "t"))))) 
(optimize
 (Add (Div (Cos (Var "t")) (Add (Num 1) (Sin (Var "t"))))
      (Div (Add (Num 1) (Sin (Var "t"))) (Cos (Var "t")))))
(optimize
 (Add (Div (Sin (Var "a")) (Add (Num 1) (Cos (Var "a"))))
      (Div (Add (Num 1) (Cos (Var "a"))) (Sin (Var "a")))))
(optimize
 (Mul (Mul (Add (Num 1) (Cos (Var "t"))) (Sub (Num 1) (Cos (Var "t"))))
      (Add (Num 1) (Pow (Cot (Var "t")) (Num 2)))))
(optimize
 (Mul (Mul (Add (Num 1) (Pow (Tan (Var "a")) (Num 2))) (Sin (Var "a")))
      (Cos (Var "a"))))
(optimize
 (Div (Sub (Pow (Sin (Var "b")) (Num 2)) (Pow (Sin (Var "a")) (Num 2)))
      (Mul (Pow (Sin (Var "a")) (Num 2)) (Pow (Sin (Var "b")) (Num 2)))))
(optimize (Div (Csc (Var "a")) (Add (Tan (Var "a")) (Cot (Var "a"))))) 
(optimize
 (Add (Add (Pow (Tan (Var "t")) (Num 2)) (Pow (Cot (Var "t")) (Num 2)))
      (Num 2)))
(optimize
 (Add
  (Sub (Pow (Csc (Var "t")) (Num 4))
       (Mul (Num 2) (Pow (Csc (Var "t")) (Num 2))))
  (Sub (Mul (Num 2) (Pow (Sec (Var "t")) (Num 2)))
       (Pow (Sec (Var "t")) (Num 4)))))
(optimize
 (Div (Sub (Sin (Var "a")) (Mul (Num 2) (Pow (Sin (Var "a")) (Num 3))))
      (Sub (Mul (Num 2) (Pow (Cos (Var "a")) (Num 3))) (Cos (Var "a")))))
(optimize
 (Add (Div (Cos (Var "t")) (Add (Csc (Var "t")) (Num 1)))
      (Div (Cos (Var "t")) (Sub (Csc (Var "t")) (Num 1)))))
(optimize
 (Add (Div (Cos (Var "t")) (Sub (Num 1) (Tan (Var "t"))))
      (Div (Sin (Var "t")) (Sub (Num 1) (Cot (Var "t"))))))
(optimize
 (Add (Div (Tan (Var "t")) (Add (Sec (Var "t")) (Num 1)))
      (Div (Tan (Var "t")) (Sub (Sec (Var "t")) (Num 1)))))
(optimize
 (Mul (Sub (Add (Sec (Var "t")) (Tan (Var "t"))) (Num 1))
      (Add (Sub (Sec (Var "t")) (Tan (Var "t"))) (Num 1))))
(optimize
 (Div (Add (Tan (Var "a")) (Cot (Var "b")))
      (Add (Cot (Var "a")) (Tan (Var "b")))))
(optimize
 (Div (Sub (Add (Tan (Var "a")) (Sec (Var "a"))) (Num 1))
      (Add (Sub (Tan (Var "a")) (Sec (Var "a"))) (Num 1))))
(optimize
 (Sub (Div (Add (Num 1) (Sin (Var "a"))) (Sub (Csc (Var "a")) (Cot (Var "a"))))
      (Div (Sub (Num 1) (Sin (Var "a"))) (Add (Csc (Var "a")) (Cot (Var "a"))))))
(optimize
 (Add (Div (Num 1) (Sub (Add (Cos (Var "t")) (Sin (Var "t"))) (Num 1)))
      (Div (Num 1) (Add (Add (Cos (Var "t")) (Sin (Var "t"))) (Num 1)))))
(optimize
 (Add (Div (Tan (Var "a")) (Sub (Num 1) (Cot (Var "a"))))
      (Div (Cot (Var "a")) (Sub (Num 1) (Tan (Var "a"))))))
(optimize
 (Sub (Pow (Sub (Sec (Var "x")) (Num 1)) (Num 2))
      (Pow (Sub (Tan (Var "x")) (Sin (Var "x"))) (Num 2))))
