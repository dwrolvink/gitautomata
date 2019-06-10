USER='dorus'

# Install Russian support tooling
# Copy i3-keyboard-layout to the .config/custom folder
cp -rf i3-keyboard-layout-master /home/${USER}/.config/custom/russian

# Copy Russian Keyboard reference to the same folder
cp RussianKeyboard.jpg /home/${USER}/.config/custom/russian

# Add keybindings to i3
echo -e '\n															' >> /home/${USER}/.i3/config
echo '# ==========================================================  ' >> /home/${USER}/.i3/config
echo '# Russian Module												' >> /home/${USER}/.i3/config
echo '# ----------------------------------------------------------  ' >> /home/${USER}/.i3/config
echo '# Allow cycling through US/RU keyboard layout					' >> /home/${USER}/.i3/config
echo 'bindsym $mod+space exec ~/.config/custom/russian/i3-keyboard-layout cycle us ru ' >> /home/${USER}/.i3/config
echo '# Show Russian keyboard layout								' >> /home/${USER}/.i3/config
echo 'bindsym $mod+r exec viewnior ~/.config/custom/russian/RussianKeyboard.jpg		' >> /home/${USER}/.i3/config
echo '# ==========================================================	' >> /home/${USER}/.i3/config

# Restart i3
sudo -u $USER i3 restart