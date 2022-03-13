
# Get Image
function Get-RandomOrSelectImage{
	#	Write-Host "[Get-RandomOrSelectImage]:START"
	
		Write-Host ""
		Write-Host "image mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<IMAGE MODE>>"
	
		if(($mode -eq 'r') -or ($mode -eq 'R')){
			$image = Get-RandomSourceImg
		}elseif(($mode -eq 's') -or ($mode -eq 'S')){
			$image = Get-SelectSourceImg
		}else{
			return
		}
	#	Write-Host "[Get-RandomOrSelectImage]:END"
	
		return $image
	}
	
	function Get-RectValues($image, $rectmode, $substrahend){
	#	Write-Host "[Get-RectValues]:START"
		[Array]$arr = $image
	#	$type = $arr.GetType()
	#	Write-Host "type:$type"
		$Image = $arr[0]
		$mode = $arr[1]
		$substrahend = $arr[2]
	
	#	Write-Host "$Image, $mode"
	
		switch($mode) {
			"x"{ 
	#			Write-Host "mode1"
				$ret_xcoodinate = Get-Random -Maximum $Image.Width -Minimum 0
				Write-Host "x-coodinate: $ret_xcoodinate"
				return $ret_xcoodinate
			}
			"y"{
	#			Write-Host "mode2"
				$ret_ycoodinate = Get-Random -Maximum $Image.Height -Minimum 0
				Write-Host "y-coodinate: $ret_ycoodinate"
				return $ret_ycoodinate
			}
			"width"{
	#			Write-Host "mode3:width"
	#			Write-Host $image.Width
				$ret_width = Get-Random -Maximum (($Image.Width) - $substrahend) -Minimum 1
				Write-Host "width: $ret_width"
				return $ret_width
			}
			"height"{
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
	
	# create new background image processes's main routine
	function New-BackgroundImg{
	#	Write-Host "[New-BackgroundImg]:START"
		$image = $null
		$image = Get-RandomOrSelectImage
		if ($null -eq $image) {
			Write-Host "[New-BackgroundImg]:image is nothing"
			return
		}	
	#	Write-Host $image.GetType()
	
		Write-Host ""
		Write-Host "image processing mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<RANGE PROCESSING>>"
	
		if(($mode -eq 's') -or ($mode -eq 'S')){
			# range
	#		Write-Host "[New-BackgroundImg]:NEW START"
			# Get Rectangle's value by range with image viewer
			# 画像をビューワに表示、任意の範囲を指定することでRectangleの値を取得する
			$rectval_arr = SetRectangleWithViewer($image)
	
	#		Write-Host "rectval_arr:"$rectval_arr
			# This implimentaton is not good...
	#		Write-Host "Count:"$rectval_arr.Count
			if($rectval_arr.Count -eq 5){
				$xcoodinate = $rectval_arr[1]
				$ycoodinate = $rectval_arr[2]
				$width = $rectval_arr[3]
				$height = $rectval_arr[4]	
			}else{
				$xcoodinate = $rectval_arr[0]
				$ycoodinate = $rectval_arr[1]
				$width = $rectval_arr[2]
				$height = $rectval_arr[3]	
			}
			
		}else{
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
		$savename = Read-Host "please enter filename to save as PNG"
		$Dstimage.Save($backgroundImgDir + "$savename", [System.Drawing.Imaging.ImageFormat]::Png)		
	
	#	Write-Host "[New-BackgroundImg]:END"
		return
	}
	
	# Return a random datastore file.
	function Get-RandomStoreFile{
		# Get the file name and put it into an array
		[System.Array]$arr = Get-ChildItem -Path ./store_file -Include @("*.txt") -Name
	
		$count_arr = $arr.Count
		if($count_arr -ge 2){
			$num_select = Get-Random -Maximum $count_arr -Minimum 0
		}elseif ($count_arr -eq 1) {
			$num_select = 0
		}else {
			Write-Host "There is no data store file!"
			return
		}
		$selected = $arr[$num_select]
	
	#	$fullpath = $store_fileDir + $selected
	#	Write-Host "[store file]: $selected"
	
		return $selected
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
	
	# Return a random image.
	function Get-RandomBackgroundImg{
	#	Write-Host "[Get-RandomBackgroundImg] START"
		# Add an array item to the combo box
		$arr = Get-ChildItem -Path $backgroundImgDir -Include @("*.jpg","*.jpeg","*.png","*.gif") -Name
	
		$count_arr = $arr.Count
		if($count_arr -ge 2){
			$num_select = Get-Random -Maximum $count_arr -Minimum 0
		}elseif ($count_arr -eq 1) {
			$num_select = 0
		}else {
			Write-Host "There is no data!"
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
	
	# Return a random image.
	function Get-RandomSourceImg{
		# Add an array item to the combo box
		$arr = Get-ChildItem -Path ./source_img -Include @("*.jpg","*.jpeg","*.png","*.gif") -Name
	
		$count_arr = $arr.Count
		if($count_arr -ge 2){
			$num_select = Get-Random -Maximum $count_arr -Minimum 0
		}elseif ($count_arr -eq 1) {
			$num_select = 0
		}else {
			Write-Host "There is no data!"
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
	
	# Pass a Windows Form to convert and save it as an image file.
	function Convert-LabelToImage($form){
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
		$savename = Read-Host "please enter filename to save as PNG" 
		
		try{
			# Save the file
			$DstBmp.Save((Get-Location).Path + '\WinForm_png\' + "$savename", [System.Drawing.Imaging.ImageFormat]::Png)	
		}catch{
			Write-Host "Save failed."
			throw ArgumentNullException
		}
		"savename: $savename" | Add-Content $logfilename -Encoding UTF8
	
	#	Write-Host "Convert-LabelToImage: END"
	}
		
	# Return a random label size
	function Get-RandomLabelSize{
		$sizefilename = "./sizefile.txt"
		# Get the size definition from the file and put it into an array
		$arr_size = Get-Content -LiteralPath $sizefilename -Encoding UTF8
		$count_arr = $arr_size.Count
		if($count_arr -ge 2){
			$num_select = Get-Random -Maximum $count_arr -Minimum 0
		}elseif ($count_arr -eq 1) {
			$num_select = 0
		}else {
			Write-Host "There is no data!"
			return
		}
		$selectsize = $arr_size[$num_select]
	#	Write-Host "[Get-RandomLabelSize]selectsize: $selectsize num_all: $count_arr ,num_select: $num_select"
	
		return $selectsize
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
	
	# Return the text placement randomly
	function Get-RandomTextAlign{
	#	Write-Host "Get-RandomTextAlign: START"
	
		# Get the definition of an enumerated type and put it into an array.
		$arr = [System.Drawing.ContentAlignment]|get-member -static -MemberType Property | Select-Object Name	
		$count_arr = $arr.Count
	
		if($count_arr -ge 2){
			$num_select = Get-Random -Maximum $count_arr -Minimum 0
		}elseif ($count_arr -eq 1) {
			$num_select = 0
		}else {
			Write-Host "There is no data!"
			return
		}
	
		$selected = $arr[$num_select]
		$ret = $selected.Name
	
	#	Write-Host "[Get-RandomTextAlign]TextAlign: $ret"
	#	"TextAlign: $ret" | Add-Content $logfilename -Encoding UTF8
		return $ret
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
	
	# Return a string registered in a datastore file at random
	function Get-RandomRegisteredStr($storefilename){
		# Read the registered contents from the file and put it into an array
		$arr_file = Get-Content -LiteralPath $storefilename -Encoding UTF8
		$count_arr = $arr_file.Count
		if($count_arr -ge 2){
			$num_select = Get-Random -Maximum $count_arr -Minimum 0
		}elseif ($count_arr -eq 1) {
			$num_select = 0
		}else {
			Write-Host "There is no data!"
			return
		}
	
		$selectstr = $arr_file[$num_select]
	#	Write-Host "[Get-RandomRegisteredStr]selectstr: $selectstr num_all: $count_arr ,num_select: $num_select"
		Write-Host "[word selected]: $selectstr"
	
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
	
	# Return one color of system.drawing.color at random
	function Get-RandomColor{
	
		$arr_color = @()
	
		# Obtain color name information and put it into an array.
		$arr_all = [system.drawing.color]|get-member -static -MemberType Property | Select-Object Name
	
		foreach($color in $arr_all){
			if($color.Name -eq "Empty"){
					continue
			}
	#		Write-Host $font.Name
			$arr_color += $color
		}
		$count = $arr_color.Count
		if($count -ge 2){
			$select = Get-Random -Maximum $count -Minimum 0
		}elseif ($count -eq 1) {
			$select = 0
		}else {
			Write-Host "There is no data!"
			return
		}
		$retcolor = $arr_color[$select]
	
	#	Write-Host $retcolor.Name
		return $retcolor.Name
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
	
	function Get-RandomBool{
		$arr = @('$true', '$false')
		$count = $arr.Count
		$num_select = Get-Random -Maximum $count -Minimum 0
		$selected = $arr[$num_select]
	
		Write-Host "Get-RandomBool : $selected"
	
		return $selected
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
		Write-Host ""
		Write-Host "font mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<FONT MODE>>"
	
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
		Write-Host ""
		Write-Host "label size mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<LABEL SIZE>>"
	
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
	
		$str_labelforeColor = Get-RandomColor
	#	Write-Host "[Show_Message]str_labelForeColor: $str_labelforeColor"
		$label.forecolor = $str_labelforeColor
		"strColor: $str_labelforeColor" | Add-Content $logfilename -Encoding UTF8
	
		$label.font = $Font
	
		# Text placement settings
		Write-Host ""
		Write-Host "TextAlign mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<TextAlign>>"
	
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
	
		Write-Host ""
		Write-Host "image mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<IMAGE MODE>>"
	
		if(($mode -eq 'r') -or ($mode -eq 'R')){
	
			Write-Host ""
			Write-Host "image pattern mode is below."
			Write-Host "repeating pattern : y"
			Write-Host "one image : n(default)"
	
			$pattern = Read-Host "<<IMAGE PATTERN>>"
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
			Write-Host ""
			Write-Host "image pattern mode is below."
			Write-Host "repeating pattern : y(default)"
			Write-Host "one image : n"
	
			$pattern = Read-Host "<<IMAGE PATTERN>>"
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
		Write-Host ""
		Write-Host "label autosize mode is below."
		Write-Host "random : r"
		Write-Host "autoresize : y"
		Write-Host "not resize : n(default)"
	
		$mode = Read-Host "<<LABEL AUTOSIZE>>"
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
	
		Write-Host ""
		Write-Host "font autosize mode is below."
		Write-Host "random : r"
		Write-Host "autosize : y"
		Write-Host "not resize : n(default)"
	
		$mode = Read-Host "<<FONT AUTOSIZE>>"
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
	
	function Get-Storefile{
		# Select the data store file
		Write-Host ""
		Write-Host "store file mode is below."
		Write-Host "random mode : r"
		Write-Host "select mode : s"
		$mode = Read-Host "<<STORE FILE>>"
		if(($mode -eq 'r') -or ($mode -eq 'R')){
			# Set a random data store file
			$storefilename = Get-RandomStoreFile
			Write-Host "[store filename]: $storefilename"
		}elseif(($mode -eq 's') -or ($mode -eq 'S')) {
			# Selecting and setting a data store file
			$storefilename = Get-SelectStoreFile
			Write-Host "[store filename]: $storefilename"
		}
		$filename_store = $store_fileDir + $storefilename
	
		return $filename_store	
	}
	
	function Check_UsageRights($Font){
		# Get a comma-separated confirmation array
	
		# Get the value of the corresponding element.
	
		# If there is no corresponding font, 
		# the rights cannot be ascertained and recommend updating this information.
	}
	
	function Get-FontList{
	#	Write-Host "[Get-FontList] START"
		$date = Get-Date -Format yyyyMMdd
		$fontlistname = "./fontlist_" + $date + ".txt"
	
		$arr_font_all = [System.Drawing.FontFamily]::Families
	
	#	$arr_font_all | Select-Object Name | Add-Content $fontlistname -Encoding UTF8
		foreach($font in $arr_font_all){
			$font.Name | Add-Content $fontlistname -Encoding UTF8
		}
	#	Write-Host "[Get-FontList] END"
	}
	
	# main
	
	# Loading an assembly
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	
	# log file name
	$logfilename = "./logfile.log"
	# Folder to store image files and store files to be set as labels
	$sourceImgDir = (Get-Location).Path + '\source_img\'
	$store_fileDir = (Get-Location).Path + '\store_file\'
	$backgroundImgDir = (Get-Location).Path + '\background_img\'
	
	
	while ($true) {
		Write-Host ""
		Write-Host "[[MAIN FUNCTION]]"
		Write-Host "mode is below."
		Write-Host "create background image : g"
		Write-Host "create design : r"
		Write-Host "register a word to store file : s"
		Write-Host "get font list : g"
		Write-Host "quit : q"
		Write-Host "enter word and create design : other"
	
		$select = Read-Host "<<MODE SELECT>>"
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