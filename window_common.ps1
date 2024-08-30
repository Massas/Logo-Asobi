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