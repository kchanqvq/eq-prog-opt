(sort Math)

(function Num (i64) Math)
(function Var (String) Math)
(function Add (Math Math) Math)
(function Mul (Math Math) Math)

;; add comm/assoc
(rewrite (Add a b)
         (Add b a))
(rewrite (Add (Add a b) c)
		 (Add a (Add b c)))

;; mul comm/assoc
(rewrite (Mul a b)
		 (Mul b a))
(rewrite (Mul (Mul a b) c)
		 (Mul a (Mul b c)))

;; distributivity
(rewrite (Mul a (Add b c))
         (Add (Mul a b) (Mul a c)))
;; factor
(rewrite (Add (Mul a b) (Mul a c))
		 (Mul a (Add b c)))

;; add cancel
(rewrite (Add (Num 0) a)
		 a)

;; mul cancel
(rewrite (Mul (Num 0) a) 
         (Num 0))
(rewrite (Mul (Num 1) a)
		 a)

(optimize (Add (Num 0) (Add (Num 0) (Var "x"))))


