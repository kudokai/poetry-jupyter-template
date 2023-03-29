# Poetry-Jupyter-Templete
クラウド上でPoetry-Jupyter(+Streamlit)のPython環境を構築するためのテンプレート

## gitのインストール

```
sudo apt update
sudo apt install git
```

## リポジトリの配置

```
cd {WORK_DIR}
git clone git@github.com:GRI-Inc/jeki-location.git
```

## Dockerのインストール

https://docs.docker.com/engine/install/debian/
インストール後に下記を実行

```
sudo gpasswd -a $USER docker
sudo reboot # 再起動
```
## envファイルの作成

```
cd {WORK_DIR}/scripts
./generate-docker-env.sh
```

docker/.envにファイルが作成されるため必ず内容を確認する。

## コンテナの起動
```
cd {WORK_DIR}/scripts
./start-jupyter.sh
```
8888番ポートでJupyterLabが起動する。
一般公開しないように注意。
起動して数分はライブラリのインストールのためアクセスできない。
一度起動すればVMを再起動した場合でも自動で起動するように設定されている。