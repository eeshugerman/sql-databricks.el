;;; sql-databricks.el --- Databricks SQL support for sql.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Elliott Shugerman

;; Author: Elliott Shugerman <elliott.shugerman@x86-64-C02F73DXMD6R>
;; Keywords: comm, languages, processes

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'sql)

(defcustom sql-databricks-program "dbsqlcli"
  "Command to start dbsqlcli by Databricks."
  :type 'file
  :group 'SQL)

(defcustom sql-databricks-login-params '(server http-path access-token)
  "Login parameters to needed to connect to Databricks SQL."
  :type 'sql-login-params
  :group 'SQL)

(defcustom sql-databricks-options
  '()
  "List of additional options for `sql-databricks-program'."
  :type '(repeat string)
  :group 'SQL)

(defun sql-comint-databricks (product options &optional buf-name)
  "Connect to Databricks SQL in a comint buffer."
  (let ((params (append
                 (if (not (string= "" sql-server))
                     (list "--hostname" sql-server))
                 (if (not (string= "" sql-http-path))
                     (list "--http-path" sql-http-path))
                 (if (not (string= "" sql-access-token))
                     (list "--access-token" sql-access-token))
                 options)))

    (sql-comint product params buf-name)
    (process-send-string buf-name "nopager;\n")))

(sql-add-product 'databricks "Databricks"
                 :free-software nil
                 :sqli-program 'sql-databricks-program
                 :prompt-regexp (rx line-start (zero-or-more not-newline) ">")
                 :sqli-login 'sql-databricks-login-params
                 :sqli-options 'sql-databricks-options
                 :sqli-comint-func #'sql-comint-databricks)


(provide 'sql-databricks)
;;; sql-databricks.el ends here
