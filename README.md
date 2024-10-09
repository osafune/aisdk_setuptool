DRP-AI TVM support tool
=======================

ルネサスRZ/V2H用のDRP-AI TVMをWSL2+docker環境にインストール、実行するスクリプトです。

DRP-AI TVMのインストール
------------------------
1. RZ/V2H AI Software Development Kitをダウンロードします。  
[RZ/V2H AI SDKのダウンロード](https://www.renesas.com/ja/software-tool/rzv2h-ai-software-development-kit#downloads)

2. WindowsのWSL2を有効にして、Ubuntuとdockerをインストールします。

3. wslのUbuntuにログインしてユーザーホームディレクトリ以下に作業用フォルダを作成し、このリポジトリの `v2h-aisdk.sh` と 1.でダウンロードしたSDKアーカイブファイル(RTK0EF0180F05000SJ.zip)をコピーします。

4. `v2h-aisdk.sh`に実行パーミッションを追加して実行します。
```
$ chmod +x v2h-aisdk.sh
$ ./v2h-aisdk.sh setup
```

DRP-AI TVMコンテナの起動
------------------------
wslのUbuntuにログインして `v2h-aisdk.sh` を実行します。デフォルトではカレントフォルダ以下の `work` フォルダをコンテナ側の `/drp-ai_tvm/work` にマウントします。
```
$ ./v2h-aisdk.sh run
```
起動時にマウントするローカルフォルダを指定することができます。マウントされるフォルダ名はローカルのフォルダ名が利用されます。  
以下の例ではWindows側の `C\aisdk_work` をコンテナ側の `/drp-ai_tvm/aisdk_work` にマウントします。スペースや多バイト文字が入ったフォルダは指定できません。
```
$ ./v2h-aisdk.sh run /mnt/c/aisdk_work
```

その他
------
サンプルやチュートリアルはDRP-AI TVMのリポジトリを参照してください。  
[renesas-rz/rzv_drp-ai_tvm](https://github.com/renesas-rz/rzv_drp-ai_tvm)  

AI SDKについては下記サイトを参照してください。  
[Renesas RZ/V AI SDK](https://renesas-rz.github.io/rzv_ai_sdk/latest/)  
[RZ/V2H AI Software Development Kit](https://www.renesas.com/ja/software-tool/rzv2h-ai-software-development-kit)  
[DRP-AI Translator i8](https://www.renesas.com/ja/software-tool/drp-ai-translator-i8)  
