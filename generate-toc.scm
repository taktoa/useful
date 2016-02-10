;;; -*- mode: scheme; geiser-scheme-implementation: guile; coding: utf-8 -*-
;;; File: generate-toc.scm
;;
;;; License:
;; Copyright © 2015 Remy Goldschmidt <taktoa@gmail.com>
;; All rights reserved.
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.
;;
;;; Author:     Remy Goldschmidt <taktoa@gmail.com>
;;; Maintainer: Remy Goldschmidt <taktoa@gmail.com>
;;; Created:    2015-12-28
;;
;;; Homepage:   http://github.com/taktoa/useful
;;
;;; Commentary:
;; Generates a table of contents for the provided Markdown file.
;;
;;; Code:

(define-module (generate-toc)
  #:use-module (ice-9 getopt-long)
  #:use-module (ice-9 command-line)
  #:use-module (ice-9 pretty-print)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 rdelim)
;;  #:export     (main)
  )


(define* (undefined)
  "A placeholder for functions that are not yet define*d."
  (error "Undefine*d"))

(define* (identity value)
  "The identity function returns its argument."
  value)


(define* (return value)
  "Throw to key return with the given value."
  (throw 'return value))

(define-syntax-rule (catch-return body ...)
  "The value of this block is the value of the contained body, unless `return'
is invoked, in which case the resultant value is the argument of `return'."
  (catch 'return (λ [] (begin body ...)) (λ [key retval] retval)))

(define-syntax-rule (num-iterate (var initial test) body ...)
  "Bind @var{var} and repeatedly evaluate @var{body}, incrementing @var{var}
after each evaluation, until @var{test} is false."
  (do ([var initial (1+ var)]) ((not test)) body ...))

(define* pragma-header       "[generate-toc-pragma]: ")
(define* add-toc-pragma      "[generate-toc-pragma]: ADD_TOC")
(define* ignore-begin-pragma "[generate-toc-pragma]: IGNORE_BEGIN")
(define* ignore-end-pragma   "[generate-toc-pragma]: IGNORE_END")

(define* (pragma? line)
  "Efficiently determine if the given @var{line} is a pragma."
  (catch-return (let* ([num   (string-length pragma-header)]
                       [valid (λ [i] (eq? (string-ref pragma-header i)
                                          (string-ref line i)))])
                  (unless (< num (string-length line)) (return #f))
                  (num-iterate [i 0 (< i num)]
                               (unless (valid i) (return #f)))
                  (return #t))))


(define* section-heading-regexp
  (make-regexp "^([#]+) ([^[:space:]]+)$"))

(define* (match:length match #:optional n)
  "Returns the length of the submatch number @var{n} in @var{match}."
  (- (match:end   match n)
     (match:start match n)))

(define* (parse-section-heading line)
  "If the given line is a section heading, return the appropriate line struct.
Otherwise, return false."
  (catch-return
   (let ([rx-match (regexp-exec section-heading-regexp line)])
     (if (and rx-match (= (match:count rx-match) 3))
         (let ([level    (match:length    rx-match 1)]
               [contents (match:substring rx-match 2)])
           (return `(header ,level ,contents)))
         (return #f)))))

(define* (parse-line line)
  "Parse the given line into a line struct."
  (if (pragma? line)
      (cond [(equal? line ignore-begin-pragma)    'ignore-begin]
            [(equal? line ignore-end-pragma)      'ignore-end]
            [(equal? line add-toc-pragma)         'add-toc])
      (cond [(parse-section-heading line)      => identity]
            [else                                 `(text ,line)])))

(define* (read-by-lines port proc)
  "For each line read from @var{port}, execute @var{proc} on the string and add
the result to a list. When end-of-file is reached, return that list.
The strings given to @var{proc} do not contain their terminating delimiter."
  (%read-line port)
  (undefined))

(define* (process header)
  "FIXME: docstring"
  (undefined))

(define* (main)
  (let* ([argv (program-arguments)]
         [argc (length argv)])
    (unless (= argc 2) (error "Invalid number of command-line arguments."))
    (let* ([file   (list-ref argv 1)]
           [result '()])
      (with-input-from-file file
        (λ []
          (do ([line (%read-line) (%read-line)]) ([eof-object? line])
            (set! result (cons line result)))
          (pretty-print result))))))
