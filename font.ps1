function Get-FontList{
#	Write-Host "[Get-FontList] START"
    $date = Get-Date -Format yyyyMMdd
    $fontlistname = "./fontlist_" + $date + ".txt"

    $arr_font_all = [System.Drawing.FontFamily]::Families

    foreach($font in $arr_font_all){
        $font.Name | Add-Content $fontlistname -Encoding UTF8
    }
#	Write-Host "[Get-FontList] END"
}

# Return a random font name.
function Get-RandomFont{
    $exclude_file = "./excludeFont.txt"
    $excludes = Get-Content -LiteralPath $exclude_file -Encoding UTF8
#	Write-Host $excludes.Count
#	Write-Host arr_exclude: $arr_exclude count: $arr_exclude.Count
    
    $arr_font_all = [System.Drawing.FontFamily]::Families

    $arr_font = @()
    foreach($font in $arr_font_all){
        if($excludes -contains $font.Name){
            continue
        }
#		Write-Host $font.Name
        $arr_font += $font
    }
#	$arr_font = $arr_font_all | Select-Object -ExcludeProperty $arr_exclude 

#	$count_all = $arr_font_all.Count
    $count = $arr_font.Count
#	Write-Host "[Get-RandomFont]count_all: $count_all, count: $count"
#	Write-Host "arr_font: $arr_font"

    if($count -ge 2){
        $num_select = Get-Random -Maximum $count -Minimum 0
    }elseif ($count -eq 1) {
        $num_select = 0
    }else {
        Write-Host "There is no data store file!"
        return
    }

#	Write-Host "num_select: $num_select"
    $ret_font = $arr_font[$num_select]
    $ret_str = $ret_font.Name
#	Write-Host "ret_str: $ret_str"

    if($ret_font.Length -eq 0){
        Get-RandomFont
    }

    return $ret_str
}

function Get-ModifiedFontSize($label){
#	Write-Host "[Get-ModifiedFontSize] START"

  $size_arr = @(7, 8, 10.5, 12, 14, 16, 20, 24, 28, 32, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96, 100)

  for($i = $size_arr.Count; $i -gt 0; $i--){

      $modifiedsize = [System.Windows.Forms.TextRenderer]::MeasureText($label.Text, $label.Font, $label.Size)
#		Write-Host "modified size : $modifiedsize"
  
      if(($modifiedsize.Width -gt $label.Size.Width) -or ($modifiedsize.Height -gt $label.Size.Height)){
          Write-Host "over size"
          $Font = New-Object System.Drawing.Font("$font_selected", $size_arr[$i - 1])
          $label.font = $Font
      }else {
          Write-Host fontsize: $label.Font.size
          break
      }
  }
#	Write-Host "[Get-ModifiedFontSize] END"
  return $label
}