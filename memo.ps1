function memo {
    param([string]$Filtre)
 
    $file = if ($env:MEMO_PATH) { $env:MEMO_PATH } else { Join-Path $HOME ".memo\memo.txt" }
    $blocs = [ordered]@{}
    $courant = $null
 
    foreach ($l in Get-Content $file -Encoding UTF8) {
        if ([string]::IsNullOrWhiteSpace($l)) { continue }
        if ($l.StartsWith("# ")) {
            $courant = $l.Substring(2)
            $blocs[$courant] = @()
            continue
        }
        $blocs[$courant] += $l
    }
 
    foreach ($titre in $blocs.Keys) {
        $corps = $blocs[$titre]
        if ($Filtre -and $titre -notlike "*$Filtre*") {
            $corps = $corps | Where-Object { $_ -like "*$Filtre*" }
        }
        if (-not $corps) { continue }
 
        Write-Host "`n$($titre.ToUpper())" -ForegroundColor Cyan
        foreach ($x in $corps) {
            $p = $x -split " => ", 2
            Write-Host "  $($p[0])" -ForegroundColor Yellow
            if ($p.Count -gt 1) { Write-Host "      $($p[1])" }
        }
    }
}
