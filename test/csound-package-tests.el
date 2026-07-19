;;; csound-package-tests.el --- Clean package smoke tests -*- lexical-binding: t; -*-

;;; Commentary:

;; Verify that the runtime files work with only their declared dependencies.

;;; Code:

(require 'cl-lib)
(require 'ert)
(require 'subr-x)
(require 'csound-mode)

(defun csound-package-tests--render-command (input-file output-file bit)
  "Return the command built for INPUT-FILE, OUTPUT-FILE, and BIT."
  (with-temp-buffer
    (setq buffer-file-name input-file)
    (let ((csound-render-flags "")
          (csound-repl-start-server-p t)
          command)
      (cl-letf (((symbol-function 'compile)
                 (lambda (value &rest _args)
                   (setq command value))))
        (csound-render bit output-file))
      command)))

(ert-deftest csound-render-uses-final-output-extension ()
  (let ((command
         (csound-package-tests--render-command
          "/tmp/input.score.csd" "output.mix.wav" "24")))
    (should (string-match-p "-o output\\.mix\\.wav" command))
    (should (string-match-p "--format=wav" command))
    (should (string-suffix-p "-3" command))))

(ert-deftest csound-render-defaults-to-current-file-base ()
  (let ((command
         (csound-package-tests--render-command
          "/tmp/input.score.csd" "" "16")))
    (should (string-match-p "-o input\\.score\\.wav" command))
    (should (string-match-p "--format=wav" command))
    (should (string-suffix-p "-s" command))))

(provide 'csound-package-tests)

;;; csound-package-tests.el ends here
