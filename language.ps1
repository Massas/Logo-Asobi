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