set -eu

./stop-jupyter.sh
# yes | sudo docker builder prune
./save-jupyter.sh
./start-jupyter.sh
sudo docker container list