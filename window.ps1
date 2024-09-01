function Show_WinForm($mode) {
#	Write-Host "Show_WinForm: start"

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Show Winform"
    $form.Size = New-Object System.Drawing.Size(500,300)
    $form.StartPosition = "Manual"
    
    while ($true) {
        $str_formBackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
    #	Write-Host "[Show_WinForm]str_formBackColor: $str_formBackColor"
    $form.BackColor = $str_formBackColor

    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.FormBorderStyle = "FixedSingle"
    $form.Opacity = 1

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = "OK"
    $OKButton.Flatstyle = "Popup"

    while ($true) {
        $str_OKBackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "[Show_WinForm]str_OKBackColor: $str_OKBackColor"
    $OKButton.Backcolor = $str_OKBackColor
    
    $str_OKforeColor = Get-RandomColor
#	Write-Host "[Show_WinForm]str_OKforeColor: $str_OKforeColor"
    $OKButton.forecolor = $str_OKforeColor

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = "Cancel"
    $CancelButton.Flatstyle = "Popup"

    while ($true) {
        $str_cancelBackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
    #	Write-Host "[Show_WinForm]str_cancelBackColor: $str_cancelBackColor"
    $CancelButton.backcolor = $str_cancelBackColor

    $str_cancelForeColor = Get-RandomColor
#	Write-Host "[Show_WinForm]str_cancelForeColor: $str_cancelForeColor"
    $CancelButton.forecolor = $str_cancelForeColor

    $Font = New-Object System.Drawing.Font("Meiryo UI",11)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,30)
    $label.Size = New-Object System.Drawing.Size(400,30)
    $label.Text = "Enter the words you want to use in the image"

    while ($true) {
        $str_labelBackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "[Show_WinForm]str_labelBackColor: $str_labelBackColor"
    $label.forecolor = $str_labelBackColor

    $label.font = $Font

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,70)
    $textBox.Size = New-Object System.Drawing.Size(400,50)
    $textBox.Font = New-Object System.Drawing.Font("Meiryo UI",11)

    $form.Topmost = $True
    $form.Add_Shown({$textBox.Select()})

    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton

    $form.Controls.Add($OKButton)
    $form.Controls.Add($CancelButton)
    $form.Controls.Add($label)
    $form.Controls.Add($textBox)

    $result = $form.ShowDialog()

    if((($mode -eq "register") -or ($mode -eq "S")) -and ($result -eq "OK") -and ($textBox.Text.Length -gt 0)){
        $registerStr = $textBox.Text
        $filename_store = Get-Storefile
        $registerStr | Add-Content $filename_store -Encoding UTF8

        # Check usage rights for font's legal compliance.
        Check_UsageRights($Font)

    }elseif (($result -eq "OK") -and ($textBox.Text.Length -gt 0)){
        $registerStr = $textBox.Text
        Write-Host "$registerStr"
        Show_Message($registerStr)
    }elseif($textBox.Text.Length -gt 0){
        [System.Windows.Forms.MessageBox]::Show("Input is Anything")
    }
}

# 画像生成の為の操作を行い各種関数を呼び出し、画像の表示・保存を行う
function Show_Message($text){
#	Write-Host "Show_Message: start"
  $partition = "==========================="
  $partition | Add-Content $logfilename -Encoding UTF8

  "text: $text" | Add-Content $logfilename -Encoding UTF8

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "ShowMessage"
  # TODO:ダイアログのサイズを調整する(自動調整できれば嬉しい)
  $form.Size = New-Object System.Drawing.Size(1500,1200)
  $form.StartPosition = "Manual"

  while ($true) {
      $str_BackColor = Get-RandomColor
      if ($str_BackColor -ne "Transparent") {
          break
      }		
  }
#	Write-Host "[Show_Message]str_BackColor: $str_BackColor"
  $form.BackColor = $str_BackColor
  "backColor: $str_BackColor" | Add-Content $logfilename -Encoding UTF8
  
  $form.MaximizeBox = $false
  $form.MinimizeBox = $false
  $form.FormBorderStyle = "FixedSingle"
  $form.Opacity = 1

  $OKButton = New-Object System.Windows.Forms.Button
  $OKButton.Location = New-Object System.Drawing.Point(40,100)
  $OKButton.Size = New-Object System.Drawing.Size(75,30)
  $OKButton.Text = "OK"
  $OKButton.DialogResult = "OK"
  $OKButton.Flatstyle = "Popup"

  while ($true) {
      $str_OKBackColor = Get-RandomColor
      if ($str_BackColor -ne "Transparent") {
          break
      }		
  }
  #	Write-Host "str_OKBackColor: $str_OKBackColor"
  $OKButton.Backcolor = $str_OKBackColor

  $str_OKForeColor = Get-RandomColor
#	Write-Host "str_OKForeColor: $str_OKForeColor"
  $OKButton.forecolor = $str_OKForeColor

  $CancelButton = New-Object System.Windows.Forms.Button
  $CancelButton.Location = New-Object System.Drawing.Point(130,100)
  $CancelButton.Size = New-Object System.Drawing.Size(75,30)
  $CancelButton.Text = "Cancel"
  $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $form.CancelButton = $CancelButton
  $form.Controls.Add($CancelButton)
  
  # Font settings
  $mode = Write-FontMode

  if(($mode -eq 'r') -or ($mode -eq 'R')){
      # Set font randomly
      $font_selected = Get-RandomFont
  }elseif(($mode -eq 's') -or ($mode -eq 'S')) {
      # Select and set a font
      $font_selected = Get-SelectFont
  }
  Write-Host "[font selected]: $font_selected"

  # make font size autosize
  $Font = New-Object System.Drawing.Font("$font_selected", 84)
  # logging
  "font_selected: $font_selected" | Add-Content $logfilename -Encoding UTF8

  $label = New-Object System.Windows.Forms.Label
  $label.Location = New-Object System.Drawing.Point(10,30)
  
  # Label size setting
  $mode = Write-LabelSizeMode

  $size_selected = @()
  if(($mode -eq 'r') -or ($mode -eq 'R')){
      # Set the label size randomly.
      $size_selected = Get-RandomLabelSize
  }elseif(($mode -eq 's') -or ($mode -eq 'S')) {
      # Select and set the size of the label.
      $size_selected = Get-SelectLabelSize
  }
  $arr_size_int = $size_selected -split(",")
  $width = [int]$arr_size_int[0]
  $height = [int]$arr_size_int[1]
#	Write-Host size_selected: $size_selected Type: $size_selected.GetType() 
  Write-Host "[size selected]: $width,$height"

  $label.Size = New-Object System.Drawing.Size($width,$height)
#	$label.Size = New-Object System.Drawing.Size(800,600)
  $label.Text = $text

  # Label size setting
  $mode = Write-FontCOlorMode

  if(($mode -eq 'r') -or ($mode -eq 'R')){
      # set font color at random
      $str_labelforeColor = Get-RandomColor
  }elseif(($mode -eq 's') -or ($mode -eq 'S')) {
      # Select and set the font color.
      $str_labelforeColor = Get-SelectColor
  }else{
      # set font color at random
      $str_labelforeColor = Get-RandomColor
  }

#	Write-Host "[Show_Message]str_labelForeColor: $str_labelforeColor"
  $label.forecolor = $str_labelforeColor
  Write-Host "[Color selected]: $str_labelforeColor"
  "strColor: $str_labelforeColor" | Add-Content $logfilename -Encoding UTF8

  $label.font = $Font

  # Text placement settings
  $mode = Write-TextAlignMode
  if(($mode -eq 'r') -or ($mode -eq 'R')){
      # Randomly set the text placement.
      $label.TextAlign = Get-RandomTextAlign
  }elseif(($mode -eq 's') -or ($mode -eq 'S')) {
      # Select and set text placement.
      $textalign = Get-SelectTextAlign
      $label.TextAlign = $textalign
  }
  $TextAlign = $label.TextAlign
  Write-Host "[TextAlign selected]: $TextAlign"
  #logging
  "TextAlign: $TextAlign" | Add-Content $logfilename -Encoding UTF8

  # Image Settings
  $mode = $null
  $pattern = $null

  $mode = Write-ImageMode

  if(($mode -eq 'r') -or ($mode -eq 'R')){
    $pattern = Write-ImagePatternMode
      switch -Wildcard ($pattern) {
          "[yY]"{ 
#				Write-Host "pattern1"
              #$label.BackgroundImage = Get-RandomSourceImg
              $label.BackgroundImage = Get-RandomBackgroundImg
          }
          "[nN]"{
#				Write-Host "pattern2"
              # Set images randomly.
              $label.Image = Get-RandomSourceImg		
          }
          Default {
#				Write-Host "default1"
              $label.BackgroundImage = Get-RandomSourceImg
          }
      }
  }elseif(($mode -eq 's') -or ($mode -eq 'S')){
    $pattern = Write-ImagePatternMode
    switch -Wildcard ($pattern) {
      "[yY]"{ 
#				Write-Host "pattern3"
#				$label.BackgroundImage = Get-SelectSourceImg
        $label.BackgroundImage = Get-SelectBackgroundImg
      }
      "[nN]"{
#				Write-Host "pattern4"
        # Set select images
        $label.Image = Get-SelectSourceImg		
      }
      Default {
#				Write-Host "default2"
        $label.BackgroundImage = Get-SelectSourceImg
      }
    }
  }else {
    Write-Host "Image: nothing"
#		Write-Host "pattern5"
  }

  # label size autosize
  $mode = Write-LabelAutoSizeMode
  if(($mode -eq 'r') -or ($mode -eq 'R')){
      # Set a random true or false
      $autosizemode = Get-RandomBool
      Write-Host "autosizemode : $autosizemode"
      # logging
      "label autosize: $autosizemode" | Add-Content $logfilename -Encoding UTF8

      if($autosizemode -eq '$true'){
          $label.autosize = $true
          Write-Host "label autosize: true"
          # logging
          "label autosize: true" | Add-Content $logfilename -Encoding UTF8
      }else{
          $label.autosize = $false
          Write-Host "label autosize: false"
          # logging
          "label autosize: false" | Add-Content $logfilename -Encoding UTF8
      }
  }elseif(($mode -eq 'y') -or ($mode -eq 'Y')) {
      $label.autosize = $true
      # logging
      "label autosize: true" | Add-Content $logfilename -Encoding UTF8

  }else {
      $label.autosize = $false
      # logging
      "label autosize: false" | Add-Content $logfilename -Encoding UTF8
  }

  $mode = Write-FontAutoSizeMode
  if(($mode -eq 'r') -or ($mode -eq 'R')){

      # Set a random true or false
      $autosizemode = Get-RandomBool
      Write-Host "font autosizemode : $autosizemode"
      # logging
      "font autosize: $autosizemode" | Add-Content $logfilename -Encoding UTF8

      if($autosizemode -eq '$true'){
          # make font size autosize by MeasureText(String, Font, Size)
          $modified_label = Get-ModifiedFontSize($label)
          $label = $modified_label
      }
  }elseif(($mode -eq 'y') -or ($mode -eq 'Y')) {
      # make font size autosize by MeasureText(String, Font, Size)
      $modified_label = Get-ModifiedFontSize($label)
      $label = $modified_label
      # logging
      "font autosize: true" | Add-Content $logfilename -Encoding UTF8
  }else {
      # logging
      "font autosize: false" | Add-Content $logfilename -Encoding UTF8
      # do nothing
  }

  # Image's place settings
  $form.Topmost = $True
  $form.AcceptButton = $OKButton
  $form.CancelButton = $CancelButton

  $form.Controls.Add($OKButton)
  $form.Controls.Add($CancelButton)
  $form.Controls.Add($label)

  # 生成した画像を表示する
  $result = $form.ShowDialog()

  if($result -eq "OK"){
      # Converting a label to an image and saving it
      Convert-LabelToImage($label)
  }else {
      Write-Host "cancel"
      "cancel" | Add-Content $logfilename -Encoding UTF8
  }
}

# Select and return a font.
function Get-SelectFont{
    $arr_font = [System.Drawing.FontFamily]::Families

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(400,40)
    $label.Text = "Please select a font."
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(400,50)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    $str_ForeColor = Get-RandomColor
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Get the content to be excluded
    $exclude_file = "./excludeFont.txt"
    $excludes = Get-Content -LiteralPath $exclude_file -Encoding UTF8

    # Exclude content in exclude file
    $arr = @()
    foreach($font in $arr_font){
        if($excludes -contains $font.Name){
            continue
        }
#		Write-Host $font.Name
        $arr += $font
    }

    # Add an array item to the combo box
    ForEach ($select in $arr){
        $fontname = $select.Name
        [void] $Combo.Items.Add("$fontname")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $selectfont = $combo.Text
    }else{
        exit
    }

    Write-Host "[font selected]: $selectfont"

    return $selectfont
}

# Return a select color
function Get-SelectColor{
    $arr_color = @()

    # Obtain color name information and put it into an array.
    $arr_all = [system.drawing.color]|get-member -static -MemberType Property | Select-Object Name

    foreach($color in $arr_all){
        if($color.Name -eq "Empty"){
                continue
        }
#		Write-Host $font.Name
        $arr_color += $color.Name
    }

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Please select a color."
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr_color){
        [void] $Combo.Items.Add("$select")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $selectstr = $combo.Text
#			Write-Host "[color selected]: $selectstr"
    }else{
        exit
    }

    return $selectstr

}

# Select and return a registered string
function Get-SelectRegisteredStr($storefilename){
    $arr_str_all = Get-Content -LiteralPath $storefilename -Encoding UTF8

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Please select a string."
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr_str_all){
        [void] $Combo.Items.Add("$select")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $selectstr = $combo.Text
#		Write-Host "[Get-RandomRegisteredStr]selectstr: $selectstr"
        Write-Host "[word selected]: $selectstr"
    }else{
        exit
    }

    return $selectstr
}

# Select and return the size of the label
function Get-SelectTextAlign{
    # Get the definition of an enumerated type and pack it into an array.
    $arr = [System.Drawing.ContentAlignment]|get-member -static -MemberType Property | Select-Object Name	

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Select the text placement"
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr){
        [void] $Combo.Items.Add($select.Name)
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $ret = $combo.Text
#		Write-Host [Get-SelectTextAlign]TextAlign: $ret
#		"TextAlign: $ret" | Add-Content $logfilename -Encoding UTF8
    }else{
        exit
    }

    return $ret
}

# Select and return the label size
function Get-SelectLabelSize{
    $sizefilename = "./sizefile.txt"
    $arr_size = Get-Content -LiteralPath $sizefilename -Encoding UTF8

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Select the size"
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr_size){
        [void] $Combo.Items.Add("$select")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $ret = $combo.Text
        Write-Host "[Get-SelectLabelSize]selectsize: $ret"
    }else{
        exit
    }

    return $ret
}

# Select and return an image.
function Get-SelectSourceImg{
    # Get the file name and put it into an array
    $arr = Get-ChildItem -Path ./source_img -Include @("*.jpg","*.jpeg","*.png","*.gif") -Name

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Please select an image"
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr){
        [void] $Combo.Items.Add("$select")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $ret = $combo.Text
    }else{
        exit
    }

    Write-Host "[image selected]: $ret"
    # logging
    "image selected: $ret" | Add-Content $logfilename -Encoding UTF8	

    $fullpath = $sourceImgDir + $ret
    $img = [System.Drawing.Image]::FromFile($fullpath)

    return $img
}

# Select and return an image.
function Get-SelectBackgroundImg{
    # Get the file name and put it into an array
    $arr = Get-ChildItem -Path $backgroundImgDir -Include @("*.jpg","*.jpeg","*.png","*.gif") -Name

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Please select an image"
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr){
        [void] $Combo.Items.Add("$select")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $ret = $combo.Text
        Write-Host "[Get-SelectBackgroundImg]img: $ret"
    }else{
        exit
    }

    Write-Host "image selected: $ret"
    # logging
    "image selected: $ret" | Add-Content $logfilename -Encoding UTF8


    $fullpath = $backgroundImgDir + $ret
    $img = [System.Drawing.Image]::FromFile($fullpath)

    return $img
}

# Select and return a datastore file.
function Get-SelectStoreFile{
    # Get the file name and put it into an array
    $arr = Get-ChildItem -Path ./store_file -Include @("*.txt") -Name

    $Font = New-Object System.Drawing.Font("Meiryo UI",12)
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select"
    $form.Size = New-Object System.Drawing.Size(600,450)
    $form.StartPosition = "Manual"
    $form.font = $Font

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(500,40)
    $label.Text = "Select the data store file"
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(40,100)
    $OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(130,100)
    $CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $Combo = New-Object System.Windows.Forms.Combobox
    $Combo.Location = New-Object System.Drawing.Point(50,50)
    $Combo.size = New-Object System.Drawing.Size(500,60)
    $Combo.DropDownStyle = "DropDown"
    $Combo.FlatStyle = "standard"
    $Combo.font = $Font

    while ($true) {
        $str_BackColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.BackColor: $str_BackColor"
    $Combo.BackColor = $str_BackColor

    while ($true) {
        $str_ForeColor = Get-RandomColor
        if ($str_BackColor -ne "Transparent") {
            break
        }		
    }
#	Write-Host "Combo.ForeColor: $str_ForeColor"
    $Combo.ForeColor = $str_ForeColor

    # Add an array item to the combo box
    ForEach ($select in $arr){
        [void] $Combo.Items.Add("$select")
    }

    $form.Controls.Add($Combo)
    $form.Topmost = $True
    $result = $form.ShowDialog()

    if ($result -eq "OK")
    {
        $ret = $combo.Text
    }else{
        exit
    }

    Write-Host "[selected]: $ret"

    return $ret
}

function SetRectangleWithViewer($image){
    # 画像を表示する
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Click 3 times and submit 'OK'"
    # TODO:ダイアログのサイズを調整する(自動調整できれば嬉しい)
    $form.Size = New-Object System.Drawing.Size($image.width,$image.height)
    $form.Location = New-Object System.Drawing.Point(0,0)
    # 0,0 座標から始めないと座標が合わない
    $form.StartPosition = "Manual"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.FormBorderStyle = "FixedSingle"
    $form.Opacity = 1
    $label = New-Object System.Windows.Forms.Label
    # 引数から画像をセットする
    $label.Image = $image
    $label.Location = New-Object System.Drawing.Point(0,0)
    $label.Size = New-Object System.Drawing.Size($image.width,$image.height)
    $form.Topmost = $True
    $form.Controls.Add($label)

    # ユーザに画像内の座標を4点設定させる
    $button_click =
    {
        ($sender, $e) = $this, $_
        # sender（$this）: Not Use
        # e（$_）
#		Write-Host "Event Data"
#		Write-Host $e.GetType().FullName                    # 型を表示
#		Write-Host $($e | Format-List "Location" | Out-String)       # 全てのプロパティを表示
        $x = $e.Location.X
        $y = $e.Location.Y
        # 入力した座標は一時ファイルに書き出す
        "$x,$y" | Out-File -FilePath ".\tmpRectangleArr.txt" -Append -Encoding utf8
        Write-Host "$x,$y"
    }	
    $label.Add_Click($button_click)

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(0,0)
    $OKButton.Size = New-Object System.Drawing.Size(45,20)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $label.Controls.Add($OKButton)

    # 画像を表示する
    $form.ShowDialog()

    # 入力された4点を基に演算を行いx座標、y座標、幅、高さをrectangle配列にセット
    $tmparr = Get-Content ".\tmpRectangleArr.txt"
#	Write-Host "tmparr: "$tmparr

    $tmp_rectval_arr = @(0, 0, 0, 0)
    $val1st = $tmparr[0] -Split ',' # this value is base for x,y coordinate
    $val2nd = $tmparr[1] -Split ',' # x coordinate
    $val3rd = $tmparr[2] -Split ',' # y corrdinate

#	Write-Host "val1st_Type"$val1st.GetType()
#	Write-Host $val1st

    $tmp_rectval_arr[0] = $val1st[0] # x coordinate
#	Write-Host "tmp_rectval_arr[0]: "$tmp_rectval_arr
    $tmp_rectval_arr[1] = $val1st[1] # y coordinate
#	Write-Host "tmp_rectval_arr[1]: "$tmp_rectval_arr
    $width_tmp = $val2nd[0] - $val1st[0]
    $tmp_rectval_arr[2] = [Math]::Abs($width_tmp) # width
#	Write-Host "tmp_rectval_arr[2]: "$tmp_rectval_arr
    $height_tmp = $val3rd[1] - $val1st[1]
    $tmp_rectval_arr[3] = [Math]::Abs($height_tmp) # width
#	Write-Host "tmp_rectval_arr[3]: "$tmp_rectval_arr

#	Write-Host "tmp_rectval_arr: "$tmp_rectval_arr
#	Write-Host "Count: "$tmp_rectval_arr.Count

    # 座標を記録した一時ファイルを削除する
    Remove-Item ".\tmpRectangleArr.txt"

    # rectangle配列を返す
    Write-Output $tmp_rectval_arr
}
