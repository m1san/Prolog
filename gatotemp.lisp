(defun begin-globals ()
  (if (not (boundp 'games)) (setq games '( )))  
  (defglobal-variable turn 0)
  (defglobal-variable playerchoises '())
  (defglobal-variable machinechoises '())
  (defglobal-variable win nil)
  (defglobal-variable selected 0)
  (defglobal-variable gamechars '(X O))
  (defglobal-variable board '(1 2 3 4 5 6 7 8 9))
  )

(begin-globals)

(defun print-table () "Print the table of tic tac toe(receives a list of 9 elements as a parameter)"
  (format t "~% ~d | ~d | ~d   ~%-----------~% ~d | ~d | ~d   ~%-----------~% ~d | ~d | ~d   ~%~%"
    (or (nth 0 board) ".") (or (nth 1 board) ".") (or (nth 2 board) ".")
    (or (nth 3 board) ".") (or (nth 4 board) ".") (or (nth 5 board) ".")
    (or (nth 6 board) ".") (or (nth 7 board) ".") (or (nth 8 board) ".")))

(defun null-list () "Set a null list, put the board in blank"
  (list nil nil nil nil nil nil nil nil nil))

(setq numbers '(("1" "uno") ("2" "dos") ("3" "tres") ("4" "cuatro") ("5" "cinco") ("6" "seis") ("7" "siete") ("8" "ocho") ("9" "nueve")) )
(setq phrases '(("suerte de principiante" "te deje ganar" "esta fue de practica") ("suerte para la proxima" "creo que no pudiste" "crei que serias mejor rival")))
(defun  check-input (c) "Check the string if there is a number"
  (dolist (x numbers) 
    (dolist (num x) 
      (if (search num c )
        ( if (and (< (+ 1 (search num c ) ) (length c) ) (isnumber(char c (+ 1 (search num c ) ) )) )
          (return-from check-input nil) (return-from check-input (first x) )
          )
        ) )
    )
  )

(defun isnumber (n)
  (dolist (x '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9") )
    (if (string-equal n x) (return-from isnumber T))
    )
  )

(defun get-user-input ()
  (progn (format t "~&¿Donde lo pongo?: ")
                       (setq currentval (parse-integer (check-input (read-line) ) :junk-allowed t)))
  )

(defun set-win ()
  (progn (format t "~&  ~S ~%" (nth (random 3) (nth turn phrases) ))
               (if (= turn 0) (push  (reverse playerchoises) games) (push  (reverse machinechoises) games)) (setq games (remove-duplicates games :test #'equal))   (makunbound 'board) 
  (setq win 1) )
  )

(defun validate-won ()
    (if (won (nth turn gamechars )) (set-win) 
    )
  )
 
(defun bot-turn ()
  ;(if win (return))
  (loop as n = (get-random)
    while (and (if (member n board) nil 1) (< (length playerchoises) 5))
    do (format t ""))
  (setf turn 1)
  (format t "~& Yo elegiré, ammm ~D.~%" currentval )
  (setf (nth  (- currentval 1)  board) (nth turn gamechars ))
  (push currentval machinechoises)
  (print-table )
  (validate-won)
  (setf turn 0)
  )

(defun update-board ()
  ;(if win (return)) 
  (setf (nth  (- currentval 1)  board) (nth turn gamechars ))
  (setf turn  0)
  (print-table )
  (validate-won)
  (if (not win) (bot-turn))
  )

(defun update-val (x)
(if (not selected)
(progn 
  (setq currentval 
    (nth 
      (- (length x) (length playerchoises))  x )
    ) 
  (if (member currentval board) (setq selected 1) (setq selected nil) )
  )
  )
)

(defun get-random ()
  (dolist (x games) (if (not (set-difference playerchoises x)) (update-val x)))
  (if selected (setq selected nil) (setq currentval (random 10)))
  (setq currentval currentval)
  )


(defun begin-loop () "begin the 5 times loop for each game"
    (let ((i 0))
      (loop (loop as n = (get-user-input)
         while (or (or (< n 0) (> n 9)) (if (member n board) nil 1) )
         do (format t "~&~D is not valid lol.~%" n )) 
      (format t "~& Bueno, si tu lo dices, llenaré ~D.~%" currentval ) (push currentval playerchoises) (update-board) (setf i (+ i 1)) 

        (if (or (= i 5) win) (return))
        )
      (list 'final)
      )
)
  
(defun begin-vars ()
  (if (not (boundp 'games)) (setq games '( )))  
  (setq turn 0)
  (setq playerchoises '())
  (setq machinechoises '())
  (setq win nil)
  (setq gamechars '(X O))
  (setq board '(1 2 3 4 5 6 7 8 9))
  )

(defun bluffing-time ()
  (progn (format t "~& Ok , quieres jugar ?  ~% primero dime con quien juego? ~%")
                       (setq name  (read-line) ) (format t "~& Veamos quien termina siendo el mejor ~S ~%" name ))
  )

(defun begin-game () "create a board with numbers for familiar usage"
  (begin-vars) (print-table ) (bluffing-time) (begin-loop) )

(defun won ( player)
  (or (and (eq (first board) player)
           (eq (second board) player)
           (eq (third board) player))
      (and (eq (fourth board) player)
           (eq (fifth board) player) 
           (eq (sixth board) player))
      (and (eq (seventh board) player) 
           (eq (eighth board) player) 
           (eq (ninth board) player))
      (and (eq (first board) player) 
           (eq (fourth board) player) 
           (eq (seventh board) player))
      (and (eq (second board) player) 
           (eq (fifth board) player) 
           (eq (eighth board) player))
      (and (eq (third board) player) 
           (eq (sixth board) player) 
           (eq (ninth board) player))
      (and (eq (first board) player) 
           (eq (fifth board) player) 
           (eq (ninth board) player))
      (and (eq (third board) player) 
           (eq (fifth board) player) 
           (eq (seventh board) player))))
