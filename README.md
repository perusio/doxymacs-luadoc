# Doxymacs support for Luadoc

## Introduction

This repository contains the implementation of
[Luadoc](http://keplerproject.github.io/luadoc/) support for
[Doxymacs](http://doxymacs.sourceforge.net/).

Luadoc is the Lua equivalent of [doxygen](http://doxygen.org) for code
documentation.

## Installation

 1. Add the path to the `doxymacs-luadoc.el` and/or `doxymacs-luadoc.elc`
    if you byte compile the file to Emacs load path. For example:
    
   ```lisp
   (let ((absolute-path (expand-file-name "/path/to/dir")))
      (unless (member (absolute-path load-path)
         (add-to-list 'load-path absolute-path)))
   ```
   where `"/path/to/dir"` is the path to the **directory**
   containing the `doxymacs-luadoc.el` and/or `doxymacs-luadoc.elc`
   file.
     
 2. Require the feature:
 
           
   ```lisp
   (require 'doxymacs-luadoc)
        
   ```
        
 3. Done.        

