#!/bin/bash
########################################
# disable autologin
########################################
# sed
# escape characters \'$.*/[]^
# 1. Write the regex between single quotes.
# 2. \ -> \\
# 3. ' -> '\''
# 4. Put a backslash before $.*/[]^ and only those characters.

#-    autologin-user=nvidia
#+    #autologin-user=nvidia
sed -i 's/^autologin-user=nvidia$/#autologin-user=nvidia/g' /etc/lightdm/lightdm.conf.d/50-nvidia.conf
