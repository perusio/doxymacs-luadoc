;;; doxymacs-luadoc.el --- Support for Luadoc in doxymacs.

;; Copyright (C) 2013  António P. P. Almeida <appa@perusio.net>

;; Author: António P. P. Almeida <appa@perusio.net>
;; Keywords: languages, tools

;; Permission is hereby granted, free of charge, to any person obtaining a
;; copy of this software and associated documentation files (the "Software"),
;; to deal in the Software without restriction, including without limitation
;; the rights to use, copy, modify, merge, publish, distribute, sublicense,
;; and/or sell copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; Except as contained in this notice, the name(s) of the above copyright
;; holders shall not be used in advertising or otherwise to promote the sale,
;; use or other dealings in this Software without prior written authorization.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
;; THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;; DEALINGS IN THE SOFTWARE.

;;; Commentary: Implements the support for the Luadoc code
;;; documentation system
;;; http://keplerproject.github.io/luadoc/index.html.

;;; Code:

(defun doxymacs-luadoc ()
  "Defines the Luadoc support for doxymacs."
  ;; Activate the doxymacs minor mode.
  (unless (and (boundp 'doxymacs-mode) doxymacs-mode)
    (doxymacs-mode))
  ;; Activate font locking for Luadoc.
  (font-lock-add-keywords 'lua-mode doxymacs-doxygen-keywords)
  ;; Avoid side effects and make all doxymacs template related
  ;; variables buffer local.
  (mapcar #'(lambda (v) (make-variable-buffer-local v))
          '(doxymacs-file-comment-template
            doxymacs-blank-multiline-comment-template
            doxymacs-blank-singleline-comment-template
            doxymacs-function-comment-template
            doxymacs-member-comment-start
            doxymacs-member-comment-end
            doxymacs-group-comment-start
            doxymacs-group-comment-end
            doxymacs-parm-tempo-element))
  ;; The template for inserting a file comment.
  (setq doxymacs-file-comment-template
        '(
          "--" > n
          "-- " (doxymacs-doxygen-command-char) "file   "
          (if (buffer-file-name)
              (file-name-nondirectory (buffer-file-name))
            "") > n
            "-- " (doxymacs-doxygen-command-char) "author " (user-full-name)
            (doxymacs-user-mail-address)
            > n
            "-- " (doxymacs-doxygen-command-char) "date   " (current-time-string) > n
            "-- " > n
            "-- " (doxymacs-doxygen-command-char) "brief  " (p "Brief description of this file: ") > n
            "-- " > n
            "-- " p > n
            "--" > n))
  ;; Multiline comment template.
  (setq doxymacs-blank-multiline-comment-templave  '("--" > n "-- " p > n "--" > n))
  ;; Single line comment template.
  (setq doxymacs-blank-singleline-comment-template '("-- " > p))
  ;; Function comment template.
  (setq doxymacs-function-comment-template
        '((let ((next-func (doxymacs-find-next-func)))
            (if next-func
                (list
                 'l
                 "--- " 'p '> 'n
                 "--" '> 'n
                 (doxymacs-parm-tempo-element (cdr (assoc 'args next-func)))
                 (unless (string-match
                          (regexp-quote (cdr (assoc 'return next-func)))
                          doxymacs-void-types)
                   '(l "--" > n "-- " (doxymacs-doxygen-command-char)
                       "return " (p "Returns: ") > n))
                 "--" '>)
              (progn
                (error "Can't find next function declaration.")
                nil)))))
  ;; Function to handle the parameters when inserting a function
  ;; comment.
  (defun doxymacs-parm-tempo-element (parms)
    "Inserts the parameters on function comments."
    (if parms
        (let ((prompt (concat "Parameter " (car parms) ": ")))
          (list 'l "-- " (doxymacs-doxygen-command-char)
                "param " (car parms) " " (list 'p prompt) '> 'n
                (doxymacs-parm-tempo-element (cdr parms))))
      nil))
  ;; Member templates.
  (setq doxymacs-member-comment-start '("--< "))
  (setq doxymacs-member-comment-end '(""))
  ;; Group templates.
  (setq doxymacs-group-comment-start '("-- @{"))
  (setq doxymacs-group-comment-end '("-- @}"))
  ) ; doxymacs-luadoc

(add-hook 'lua-mode-hook 'doxymacs-luadoc)

(provide 'doxymacs-luadoc)
;;; doxymacs-luadoc.el ends here
