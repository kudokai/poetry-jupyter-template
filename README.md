# Poetry-Jupyter-Templete
クラウド上でPoetry-JupyterのPython環境を構築するためのテンプレート
### できること
- GCP, AWS等のインスタンス上でPoetry環境でのJupyter Notebookを実行可能
- src以下に作成したモジュールをNotebook上でimport可能

## gitのインストール

```
sudo apt update
sudo apt install git
```

## リポジトリの配置

```
cd {WORK_DIR}
git clone git@github.com:kudokai/poetry-jupyter-template.git
```

## Dockerのインストール

https://docs.docker.com/engine/install/
インストール後に下記を実行

```
sudo gpasswd -a $USER docker
sudo reboot # 再起動
```
## envファイルの作成

```
cd {WORK_DIR}/poetry-jupyter-template/scripts
./generate-docker-env.sh
```

docker/.envにファイルが作成されるため必ず内容を確認する。

## コンテナの起動
```
cd {WORK_DIR}/poetry-jupyter-template/scripts
./start-jupyter.sh
```
起動成功確認後は、適宜"poetry-jupyter-template"を適当な名前に書き換える。

8888番ポートでJupyterLabが起動する。
一般公開しないように注意。
起動して数分はライブラリのインストールのためアクセスできない。
一度起動すればVMを再起動した場合でも自動で起動するように設定されている。
