# Pass a Windows Form to convert and save it as an image file.
function Convert-LabelToImage($form) {
  #	Write-Host "Convert-LabelToImage: START"

  #	$formType = $form.GetType()
  #	Write-Host "formType: $formType"
  $size = $label.Size
  $height = $size.Height
  $width = $size.Width
  #	$sizeType = $size.GetType()
  #	Write-Host "size Type: $sizeType, value: $size, width: $width, height: $height"

  $DstBmp = New-Object System.Drawing.Bitmap($width, $height)
  $Rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
  # Convert a label to a Bitmap
  $form.DrawToBitmap($DstBmp, $Rect)

  Write-Host ""
  $massage_save = Set-SaveFilenameMessage
  $savename = Read-Host $massage_save

  try {
    # Save the file
    $DstBmp.Save((Get-Location).Path + '\WinForm_png\' + "$savename", [System.Drawing.Imaging.ImageFormat]::Png)	
  }
  catch {
    $save_error_message = Set-SaveErrorMessage
    Write-Host $save_error_message
    throw ArgumentNullException
  }
  "savename: $savename" | Add-Content $logfilename -Encoding UTF8

  #	Write-Host "Convert-LabelToImage: END"
}

# Return a random image.
function Get-RandomSourceImg {
  # Add an array item to the combo box
  $arr = Get-ChildItem -Path ./source_img -Include @("*.jpg", "*.jpeg", "*.png", "*.gif") -Name

  $count_arr = $arr.Count
  if ($count_arr -ge 2) {
    $num_select = Get-Random -Maximum $count_arr -Minimum 0
  }
  elseif ($count_arr -eq 1) {
    $num_select = 0
  }
  else {
    Write-ThereIsNoData
    return
  }
  $selected = $arr[$num_select]

  Write-Host "[image selected]: $selected"
  # logging
  "image selected: $selected" | Add-Content $logfilename -Encoding UTF8

  $fullpath = $sourceImgDir + $selected

  $img = [System.Drawing.Image]::FromFile($fullpath)

  return $img
}

function Get-RectValues($image, $rectmode, $substrahend) {
  #	Write-Host "[Get-RectValues]:START"
  [Array]$arr = $image
  #	$type = $arr.GetType()
  #	Write-Host "type:$type"
  $Image = $arr[0]
  $mode = $arr[1]
  $substrahend = $arr[2]

  #	Write-Host "$Image, $mode"

  switch ($mode) {
    "x" { 
      #			Write-Host "mode1"
      $ret_xcoodinate = Get-Random -Maximum $Image.Width -Minimum 0
      Write-Host "x-coodinate: $ret_xcoodinate"
      return $ret_xcoodinate
    }
    "y" {
      #			Write-Host "mode2"
      $ret_ycoodinate = Get-Random -Maximum $Image.Height -Minimum 0
      Write-Host "y-coodinate: $ret_ycoodinate"
      return $ret_ycoodinate
    }
    "width" {
      #			Write-Host "mode3:width"
      #			Write-Host $image.Width
      $ret_width = Get-Random -Maximum (($Image.Width) - $substrahend) -Minimum 1
      Write-Host "width: $ret_width"
      return $ret_width
    }
    "height" {
      #			Write-Host "mode4:height"
      #			Write-Host $image.Height
      $ret_height = Get-Random -Maximum (($Image.Height) - $substrahend) -Minimum 1
      Write-Host "height: $ret_height"
      return $ret_height
    }
    Default {
      Write-Host "default"
    }
  }

  #	Write-Host "[Get-RectValues]:END"
}

# Get Image
function Get-RandomOrSelectImage {
  #	Write-Host "[Get-RandomOrSelectImage]:START"

  $mode = Write-ImageMode

  if (($mode -eq 'r') -or ($mode -eq 'R')) {
    $image = Get-RandomSourceImg
  }
  elseif (($mode -eq 's') -or ($mode -eq 'S')) {
    $image = Get-SelectSourceImg
  }
  else {
    return
  }
  #	Write-Host "[Get-RandomOrSelectImage]:END"

  return $image
}

# create new background image processes's main routine
function New-BackgroundImg {
  #	Write-Host "[New-BackgroundImg]:START"
  $image = $null
  $image = Get-RandomOrSelectImage
  if ($null -eq $image) {
    Write-Host "[New-BackgroundImg]:image is nothing"
    return
  }	
  #	Write-Host $image.GetType()

  $mode = Write-ImageProcessingMode

  if (($mode -eq 's') -or ($mode -eq 'S')) {
    # range
    #		Write-Host "[New-BackgroundImg]:NEW START"
    # Get Rectangle's value by range with image viewer
    # 画像をビューワに表示、任意の範囲を指定することでRectangleの値を取得する
    $rectval_arr = SetRectangleWithViewer($image)

    #		Write-Host "rectval_arr:"$rectval_arr
    # This implimentaton is not good...
    #		Write-Host "Count:"$rectval_arr.Count
    if ($rectval_arr.Count -eq 5) {
      $xcoodinate = $rectval_arr[1]
      $ycoodinate = $rectval_arr[2]
      $width = $rectval_arr[3]
      $height = $rectval_arr[4]	
    }
    else {
      $xcoodinate = $rectval_arr[0]
      $ycoodinate = $rectval_arr[1]
      $width = $rectval_arr[2]
      $height = $rectval_arr[3]	
    }
        
  }
  else {
    # random
    # Get Rectangle's values
    $mode = "x"
    $xcoodinate = Get-RectValues($image, $mode, 0)
    $mode = "y"
    $ycoodinate = Get-RectValues($image, $mode, 0)
    $mode = "width"
    $width = Get-RectValues($image, $mode, $xcoodinate)
    $mode = "height"
    $height = Get-RectValues($image, $mode, $ycoodinate)
  }

  # Crop the image
  #	$Rect = New-Object System.Drawing.Rectangle(17, 89, 600, 234)
  $Rect = New-Object System.Drawing.Rectangle($xcoodinate, $ycoodinate, $width, $height)

  try {
    # PoxelFormat 2498570
    $Dstimage = $image.Clone($Rect, 2498570)
  }
  catch {
    Write-Host "[New-BackgroundImg]:recursive call"
    New-BackgroundImg
    return
  }
  Write-Host ""
  $massage_save = Set-SaveFilenameMessage
  $savename = Read-Host $massage_save
  $Dstimage.Save($backgroundImgDir + "$savename", [System.Drawing.Imaging.ImageFormat]::Png)		

  #	Write-Host "[New-BackgroundImg]:END"
  return
}

# Return a random image.
function Get-RandomBackgroundImg {
  #	Write-Host "[Get-RandomBackgroundImg] START"
  # Add an array item to the combo box
  $arr = Get-ChildItem -Path $backgroundImgDir -Include @("*.jpg", "*.jpeg", "*.png", "*.gif") -Name

  $count_arr = $arr.Count
  if ($count_arr -ge 2) {
    $num_select = Get-Random -Maximum $count_arr -Minimum 0
  }
  elseif ($count_arr -eq 1) {
    $num_select = 0
  }
  else {
    Write-ThereIsNoData
    return
  }
  $selected = $arr[$num_select]
  Write-Host "[image selected]: $selected"
  # logging
  "image selected: $selected" | Add-Content $logfilename -Encoding UTF8

  $fullpath = $backgroundImgDir + $selected

  $img = [System.Drawing.Image]::FromFile($fullpath)

  #	Write-Host "[Get-RandomBackgroundImg] END"
  return $img
}