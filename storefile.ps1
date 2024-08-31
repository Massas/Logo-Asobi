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

function Get-Storefile{
    # Select the data store file
    $mode = Write-StorefileMode # ストアファイルのモード選択
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