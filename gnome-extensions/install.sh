# install dependencies
echo "Installing dependencies curl wget jq unzip"
sudo apt install -y curl wget jq unzip
# download installer script
echo "Downloading gnome extension installer script"
rm -f ./install-gnome-extensions.sh; wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./gnome-extensions-installer.sh && chmod +x gnome-extensions-installer.sh
# install extensions listed in links.txt
echo "Installing extensions from links.txt"
./gnome-extensions-installer.sh --enable --file links.txt
#restart gnome
echo "Please restart gnome with Alt+F2 and then r command"