# PSImageGenerator
This is an application to generate a simple logo.

## 概要
デザインの才能や複雑な操作要らずでオンリーワンかつオリジナルのデザインを作るプログラムです。  
オンリーワンのデザインを作るための様々な機能を備えています。  
※作成できるデザインの"構図"に限りがあります。  
  イラストを描いてくれるプログラムではありません。  

デザインは、以下の要素を組み合わせることで作成します。  
・背景画像  
・ワード  
・フォント  
・ワードの配置位置  
・フォントの色(現状ランダムでの設定になっています)  

このプログラムでは、デザインのもととなる材料を自分で用意していただきます。  
背景画像、ワードやフォントは自分でバリエーションを拡充・拡張を行う仕様にしています。  
これは限られた変数の中でデザインの自由度を高めるための選択です。  

## 対応OS
Windows端末(Windows10～)での使用を想定しています。  

## プログラム構成
  background_img：背景画像を格納する  
  source_img：背景画像を生成するための材料となるを格納する  
  store_file：画像に設定するワードをテキストファイルに保存しここに格納する  
              複数のテキストファイルを格納することが可能  
  WinForm_png：作成したデザイン画像はここに保存される  
  excludeFont.txt：使用しないフォントをここに登録する  
  logfile.log：作成したデザインの情報をログとして保管する  
  PSImageGenarator.ps1：メインプログラム  
  PSImageGenarator3.bat：プログラム起動ファイル  
  sizefile.txt：デザイン画像のサイズを規定する値をここに登録する  

## 使用手順
＜１＞背景画像を作る  
１：source_imgフォルダに、背景画像として切り取りたい画像を格納する  
  ※対応可能な画像の形式：jpg、jpeg、png、gif  
２：batファイルでプログラムを起動する  
３：「<<MODE SELECT>>:」でｂを入力する  
４：材料となる画像を選択する  
  4-1：ランダムに選択したい場合：ｒを入力する  
    ※そのあとに続く入力は未実装の為、ENTERを押下するのみでOK  
  4-2：画像の切り取りモード(processing mode)を選択する  
    A）ランダムに切り取りを行う：rを入力する or 何も入力する(デフォルト)  
       ⇒ランダムに切り取る座標および幅・高さが決定される  
    B）座標を指定して切り取りを行う：sを入力する  
       ⇒B-1：選択された画像が表示される  
         B-2：画像内の座標を3点クリックすることで切り取りたい箇所を指定する  
              1回目のクリックでx座標およびy座標を設定する。  
              2回目のクリックで1回目よりも右方向にクリックすることで、切り取り幅を決定する。  
              3回目のクリックは1回目よりも下方向にクリックすることで、切り取る高さを決定する。  
  4-3：4-2で指定した値で画像が切り取られる。  
       保存したいファイル名(***.png)を入力することで画像がbackground_imgフォルダに保存される  

＜２＞デザイン画像を作る  
１：background_imgフォルダとsource_imgフォルダに背景画像を格納する  
２：デザインに反映したいワードをまとめたテキストファイルをstore_fileフォルダに格納する  
    ※1行につき1ワード  
３：batファイルでプログラムを起動する  
４：「<<MODE SELECT>>:」でrを入力する  
５：デザインの項目について設定していく  
  5-1：「<<STORE FILE>>:」でワードを保存したファイルをモード選択する  
  5-2：「<<WORD>>:」でデザインに反映したいワードをモード選択する  
  5-3：「<<FONT MODE>>:」でフォントをモード選択する  
  5-4：「<<LABEL SIZE>>:」でデザイン画像のサイズをモード選択する  
  5-5：「<<TextAlign>>:」でワードの配置をモード選択する  
  5-6：「<<IMAGE MODE>>:」でデザインに設定する画像をモード選択する  
  5-7：「<<IMAGE PATTERN>>:」で背景画像のパターンをモード選択する  
        yの場合、background_imgフォルダから画像が選択され、画像サイズ分敷き詰められる  
        nの場合、source_imgフォルダから画像が選択される  
  5-8：「<<LABEL AUTOSIZE>>:」でフォントのサイズに合わせて画像サイズを補正するか選択する  
  5-9：「<<FONT AUTOSIZE>>:」でフォントのサイズを補正するか選択する  
  5-10：以上の設定からデザインした画像が表示される  
        画像を保存したい場合は画像左上にある「OK」ボタンを押す ※保存したくない場合には「NO」ボタンを押す  
  5-11：保存したいファイル名(***.png)を入力することで画像がWinForm_pngフォルダに保存される  
