set -eu

./stop-jupyter.sh
# yes | sudo docker builder prune
./start-jupyter.sh
sudo docker container list