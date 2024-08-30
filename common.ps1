function Get-RandomBool{
    $arr = @('$true', '$false')
    $count = $arr.Count
    $num_select = Get-Random -Maximum $count -Minimum 0
    $selected = $arr[$num_select]

    Write-Host "Get-RandomBool : $selected"

    return $selected
}

