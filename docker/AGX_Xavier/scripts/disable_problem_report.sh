#!/bin/bash
########################################
# .bashrc (login/root)
########################################
# sed
# escape characters \'$.*/[]^
# 1. Write the regex between single quotes.
# 2. \ -> \\
# 3. ' -> '\''
# 4. Put a backslash before $.*/[]^ and only those characters.

####################
# disable_problem_report
####################
#-    enabled=1
#+    enabled=0
sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

