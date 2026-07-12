sudo rm /etc/apt/sources.list.d/yarn.list 
sudo apt-get update
sudo apt-get install -y qemu-system-i386
echo "set auto-load safe-path /" > ~/.gdbinit
code --install-extension mingjun97.cs153-debugging-pack
