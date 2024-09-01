# select language
function Select-Language(){
  while ($true) {
    Write-Host ""
    Write-Host "your language is $($global:languages[$global:language_mode])"
    Write-Host ""
    Write-Host "language mode is below."
    # Select Language
    for ($language_count = 0; $language_count -lt $global:languages.Length; $language_count++) {
      Write-Host "$language_count : $($global:languages[$language_count])"
    }
    Write-Host "enter number."
    $tmp_language = Read-Host "<<LANGUAGE>>"
    if (($tmp_language.Length -ne 1) -or ($tmp_language -gt $($global:languages.Length - 1)) -or ($tmp_language -eq '')) {
      Write-Host "your input number is wrong. please retry."
      Start-Sleep 1
      continue
    }else{
      $global:language_mode = $tmp_language
      Write-Host "language modify succeeded."
      Start-Sleep 1
      break
    }
  }
}

# Display the main munu
function Write-MainMunu(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "[[MAIN MENU]]"
    Write-Host "mode is below."
    Write-Host "create background image : b"
    Write-Host "create design : r"
    Write-Host "register a word to store file : s"
    Write-Host "select language: l"
    Write-Host "get font list : g"
  
    Write-Host "quit : q"
    Write-Host "enter word and create design : other"
  
    $select = Read-Host "<<MODE SELECT>>"  
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host '[[メインメニュー]]'
    Write-Host "実行したい操作を以下から選択してください"
    Write-Host "背景の画像を作る : b"
    Write-Host "ロゴを作る : r"
    Write-Host "ワードをストアファイルに追記する : s"
    Write-Host "言語を選択する: l"
    Write-Host "フォントリストを取得する : g"
  
    Write-Host "このプログラムを終了する : q"
    Write-Host "ワードを入力してロゴを作る : それ以外のキー"
  
    $select = Read-Host "<<実行したい操作入力>>"  
  }else {
    # do nothing
  }

  return $select
}

function Write-WordMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "word mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<WORD>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "ワードの選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<ワードの選択入力>>"
  }else {
    # do nothing
  }

  return $mode
}

function Write-StorefileMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "store file mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<STORE FILE>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "ストアファイルの選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<ストアファイルの選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-FontMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "font mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<FONT MODE>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "フォントの選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<フォントの選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-LabelSizeMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "label size mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<LABEL SIZE>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "ロゴのサイズ選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<ロゴサイズの選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-FontCOlorMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "font color mode is below."
    Write-Host "random mode : r (default)"
    Write-Host "select mode : s"
    $mode = Read-Host "<<FONT COLOR>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "フォントの色選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<フォントの色の選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-TextAlignMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "TextAlign mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<TextAlign>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "ワードの配置選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<ワードの配置の選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-ImageMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "image mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<IMAGE MODE>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "背景画像の選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "選択モード : s"
    $mode = Read-Host "<<背景画像の選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-ImagePatternMode() {
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "image pattern mode is below."
    Write-Host "repeating pattern : y(default)"
    Write-Host "one image : n"
    $pattern = Read-Host "<<IMAGE PATTERN>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "画像のパターン選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "繰り返しパターン : y(デフォルト)"
    Write-Host "繰り返しなしパターン : n"
    $pattern = Read-Host "<<画像のパターンの選択入力>>"
  }else {
    # do nothing
  }
  return $pattern
}

function Write-LabelAutoSizeMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "label autosize mode is below."
    Write-Host "random : r"
    Write-Host "autoresize : y"
    Write-Host "not resize : n(default)"

    $mode = Read-Host "<<LABEL AUTOSIZE>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "ロゴの自動サイズ調整機能の選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "自動サイズ調整有効 : y"
    Write-Host "自動サイズ調整をしない : n(デフォルト)"
    $mode = Read-Host "<<ロゴの自動サイズ調整機能の選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}

function Write-FontAutoSizeMode(){
  if ($global:language_mode -eq 0){ # english
    Write-Host ""
    Write-Host "font autosize mode is below."
    Write-Host "random : r"
    Write-Host "autosize : y"
    Write-Host "not resize : n(default)"
    $mode = Read-Host "<<FONT AUTOSIZE>>"
  }elseif($global:language_mode -eq 1){ # japanese
    Write-Host ""
    Write-Host "フォントの自動サイズ調整機能の選択で選べるのは以下のモードです"
    Write-Host "ランダムモード : r"
    Write-Host "自動サイズ調整有効 : y"
    Write-Host "自動サイズ調整をしない : n(デフォルト)"
    $mode = Read-Host "<<フォントの自動サイズ調整機能の選択入力>>"
  }else {
    # do nothing
  }
  return $mode
}