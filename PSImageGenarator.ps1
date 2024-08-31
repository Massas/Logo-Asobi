# main処理

# psファイルのインクルード
. ".\common.ps1" # 共通処理を集約したファイル
. ".\font.ps1" # フォント関連の処理を集約したファイル
. ".\image.ps1" # 画像処理の関連処理を集約したファイル
. ".\language.ps1" # 言語設定の関連処理を集約したファイル
. ".\storefile.ps1" # ストアファイルの関連処理を集約したファイル
. ".\usage_right.ps1" # 使用権についての関連処理を集約したファイル
. ".\window.ps1" # ウィンドウ表示が伴う処理を集約したファイル
. ".\window_common.ps1" # ウィンドウ表示が伴う処理に使用する共通処理を集約したファイル

# Loading an assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Language Mode
$global:languages = @('english', 'japanese')
$global:language_mode = 0 # english is default language

# log file name
Set-Variable -Name "logfilename" -Value "./logfile.log" -Option Constant
# Folders to store image files and store files to be set as labels
Set-Variable -Name "sourceImgDir" -Value $((Get-Location).Path + '\source_img\') -Option Constant
Set-Variable -Name "store_fileDir" -Value $((Get-Location).Path + '\store_file\') -Option Constant
Set-Variable -Name "backgroundImgDir" -Value $((Get-Location).Path + '\background_img\') -Option Constant

while ($true) {
  $select = Write-MainMunu # Display the main munu
  if(($select -eq 'r') -or ($select -eq 'R')){
    $r_storestr = $null

    # Get random or select store file name
    $filename_store = Get-Storefile

    Write-Host ""
    Write-Host "word mode is below."
    Write-Host "random mode : r"
    Write-Host "select mode : s"
    $mode = Read-Host "<<WORD>>"
    if(($mode -eq 'r') -or ($mode -eq 'R')){
      # Set a random string
#			Write-Host "filename: $filename_store"
      $r_storestr = Get-RandomRegisteredStr($filename_store)
    }elseif(($mode -eq 's') -or ($mode -eq 'S')) {
      # Selecting and setting a string
#			Write-Host "filename: $filename_store"
      $r_storestr = Get-SelectRegisteredStr($filename_store)
    }

    Show_Message($r_storestr)

  }elseif(($select -eq 's') -or ($select -eq 'S')){
    $mode = "register"
    Show_WinForm $mode
  }elseif(($select -eq 'b') -or ($select -eq 'B')){
    # create new background image
    New-BackgroundImg
  }elseif(($select -eq 'g') -or ($select -eq 'G')){
    # Get font list
    Get-FontList
  }elseif(($select -eq 'g') -or ($select -eq 'G')){
    # Get font list
    Get-FontList
  }elseif(($select -eq 'l') -or ($select -eq 'L')){
    # select language
    Select-Language
  }elseif(($select -ne 'q') -or ($select -ne 'Q')){
    # Windows Form shows
    Show_WinForm
  }else {
    $date = Get-Date
    Write-Host "terminate this program ($date)"
    Start-Sleep 1
    return
  }   
}