;;; csound-score-tests.el --- Tests for csound score helpers -*- lexical-binding: t; -*-

;;; Commentary:

;; Regression tests for score expressions sent to csound-repl.

;;; Code:

(require 'cl-lib)
(require 'ert)
(require 'csound-repl-interaction)
(require 'csound-score)

(defconst csound-score-tests--legal-statements
  '(("a" "a 0 4 2" "a 0 0 2")
    ("b" "b 4" "b 4")
    ("B" "B -2" "B -2")
    ("C" "C 0" "C 0")
    ("d" "d 1 4 0" "d 1 0 0")
    ("e" "e 10" "e 10")
    ("f" "f 1 4 8 10 1" "f 1 0 8 10 1")
    ("i" "i 1 4 1" "i 1 0 1")
    ("m" "m chorus" "m chorus")
    ("n" "n chorus" "n chorus")
    ("q" "q 1 4 0" "q 1 0 0")
    ("r" "r 2 LOOP" "r 2 LOOP")
    ("s" "s 4" "s 4")
    ("t" "t 0 120 4 90" "t 0 120 4 90")
    ("v" "v 2" "v 2")
    ("x" "x" "x")
    ("y" "y 1234" "y 1234")
    ("{" "{ 2 LOOP" "{ 2 LOOP")
    ("}" "}" "}"))
  "Representative forms of every score statement in the Csound manual.")

(ert-deftest csound-score-trim-time-handles-all-legal-statements ()
  (dolist (statement csound-score-tests--legal-statements)
    (ert-info ((format "score statement %s" (nth 0 statement)))
      (should (equal (csound-score-trim-time (nth 1 statement))
                     (concat (nth 2 statement) "\n"))))))

(ert-deftest csound-score-trim-time-accepts-joined-score-characters ()
  (should
   (equal (csound-score-trim-time
           "f1 0 4096 10 1\nf2 0 4096 10 1\ni1 0 5")
          "f1 0 4096 10 1\nf2 0 4096 10 1\ni1 0 5\n")))

(ert-deftest csound-score-trim-time-accepts-all-joined-timed-statements ()
  (should
   (equal (csound-score-trim-time
           "a0 4 2\nd1 4 0\nf1 4 8 10 1\ni1 4 1\nq1 4 0")
          "a0 0 2\nd1 0 0\nf1 0 8 10 1\ni1 0 1\nq1 0 0\n")))

(ert-deftest csound-score-trim-time-accepts-joined-named-instrument ()
  (should (equal (csound-score-trim-time "i\"lead\" 4 2")
                 "i\"lead\" 0 2\n")))

(ert-deftest csound-score-trim-time-does-not-use-f-size-as-duration ()
  (should
   (equal (csound-score-trim-time
           "i 1 4 2\nf 1 4 4096 10 1\ni 1 + 1")
          "i 1 0 2\nf 1 0 4096 10 1\ni 1 2 1\n")))

(ert-deftest csound-score-trim-time-accepts-short-joined-f-statement ()
  (should (equal (csound-score-trim-time "f0 36000")
                 "f0 0\n")))

(ert-deftest csound-score-trim-time-preserves-relative-time-behavior ()
  (should
   (equal (csound-score-trim-time
           "i 1 2 1\ni 1 + .\ni 1 . 3")
          "i 1 0 1\ni 1 1 .\ni 1 1 3\n")))

(ert-deftest csound-score-trim-time-preserves-other-score-statements ()
  (should
   (equal (csound-score-trim-time
           "t 0 120\n; keep this comment\ni1 4 1\ne")
          "t 0 120\n; keep this comment\ni1 0 1\ne\n")))

(ert-deftest csound-score-trim-time-preserves-digits-in-string-pfields ()
  (should
   (equal (csound-score-trim-time
           "i1 4 1 \"sample1.wav\"")
          "i1 0 1 \"sample1.wav\"\n")))

(ert-deftest csound-repl-accepts-joined-instrument-statement ()
  (let (sent)
    (cl-letf (((symbol-function 'process-send-string)
               (lambda (_process string)
                 (setq sent string))))
      (read-csound-repl 'i nil "i1 4 2"))
    (should (equal sent "$i1 0 2\n"))))

(provide 'csound-score-tests)

;;; csound-score-tests.el ends here
