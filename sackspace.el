;; sackspace.el --- a better backspace

;; Copyright (C) 2010 by Michael Markert
;; Author: 2010 Michael Markert <markert.michael@googlemail.com>
;; Created: 2010/08/01
;; Version: 0.2
;; Last modified: 2010-08-01 17:41:13 +0200
;; Keywords: delete

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;; Known Bugs:
;; See http://github.com/cofi/sackspace.el/issues

;; Homepage: http://github.com/cofi/sackspace.el
;; Git-Repository: git://github.com/cofi/sackspace.el.git

;; TODO: Add custom for
;; - hyper-sack (function to use if sack/backspace is called with prefix)

(defgroup sackspace nil
  "A better backspace."
  :tag "Sackspace"
  :link '(url-link :tag "Homepage" "http://github.com/cofi/sackspace.el")
  :prefix "sack/"
  :group 'convenience)

(defcustom sack/deletion-style 'sack/tabstop
  "Delete-Style that Sackspace should use"
  :type '(choice (const :tag "Delete until Tabstop" sack/tabstop)
                 (const :tag "Delete just one char" sack/plain)
                 (const :tag "Delete just one char (but untabify before)"
                        sack/plain-space))
  :group 'sackspace)

(defun sack/plain ()
  "Delete just one char."
  (backward-delete-char 1))

(defun sack/plain-space ()
  "Delete just one char (untabify tabs before)."
  (backward-delete-char-untabify 1))

(defun sack/tabstop ()
  "Delete preceding whitespace until tabstop.
On preceding non-whitespace delete that char and on preceding
tab, kill that tab."
  (let* ((tab-off (mod (current-column) tab-width))
         (max-back (if (= tab-off 0)
                       4
                     tab-off))
         (min-col (max 0 (- (current-column) max-back)))
         (tab? (looking-back "\t" min-col))
         (whitespace? (looking-back " " min-col)))
    (cond
     ((or tab? (not whitespace?) (bolp))
      (backward-delete-char 1))
     (t (backward-delete-char max-back)))))

(defun sack/hyper-sack ()
  "Kill all whitespace before point."
  (interactive)
  (let ((start (point)))
    (skip-chars-backward " \t\r\n")
    (if (/= (point) start)
        (delete-region (point) start)
      (backward-delete-char 1))))

(defun sack/backspace (prefix)
  "Deletes preceding character or whitespace.
With prefix use hyper-sack."
  (interactive "P")
  (if prefix
      (sack/hyper-sack)
    (funcall sack/deletion-style)))
