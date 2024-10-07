DRP-AI TVM setup tool
=====================

ルネサスRZ/V2H用のDRP-AI TVMをWSL2+docker環境にインストールするスクリプトです。

使い方
------
1. RZ/V2H AI Software Development Kitをダウンロードします。  
[RZ/V2H AI SDKのダウンロード](https://www.renesas.com/ja/software-tool/rzv2h-ai-software-development-kit#downloads)

2. WindowsのWSL2を有効にして、Ubuntuとdockerをインストールします。  

3. wslのUbuntuにログインしてユーザーホームディレクトリ以下に作業用フォルダを作成し、このリポジトリの `v2h-aisdk_setup.sh` と 1.でダウンロードしたSDKアーカイブファイル(RTK0EF0180F05000SJ.zip)をコピーします。  

4. `v2h-aisdk_setup.sh`に実行パーミッションを追加して実行します。
```
$ chmod a+x v2h-aisdk_setup.sh
$ ./v2h-aisdk_setup.sh
```

5. サンプルやチュートリアルはDRP-AI TVMのリポジトリを参照してください。
[renesas-rz/rzv_drp-ai_tvm](https://github.com/renesas-rz/rzv_drp-ai_tvm)

