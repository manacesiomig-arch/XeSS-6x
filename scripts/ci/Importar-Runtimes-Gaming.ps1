param([string]$Original)
$ErrorActionPreference = 'Stop'
try {
    $dest = $PSScriptRoot
    if (!(Test-Path -LiteralPath (Join-Path $dest 'veyra_qml_ui.exe') -PathType Leaf)) {
        throw 'Execute este arquivo na pasta do NOVO programa compilado, ao lado do EXE.'
    }
    if (!$Original) { $Original = Read-Host 'Cole o caminho da pasta do Veyra OFICIAL que funciona (a que contem runtime_local)' }
    $Original = $Original.Trim().Trim('"')
    $src = (Resolve-Path -LiteralPath $Original).Path
    if ($src.TrimEnd('\') -ieq $dest.TrimEnd('\')) { throw 'Origem e destino iguais. Selecione a instalacao oficial, nao a nova.' }
    # Only the known provider directories. Never import settings, EXEs, drivers or unrelated DLLs.
    $paths = @('runtime_local/intel/experimental', 'runtime_local/amd/fidelityfx')
    $required = @('runtime_local/intel/experimental/libxess_fg.dll', 'runtime_local/intel/experimental/libxell.dll', 'runtime_local/amd/fidelityfx/amd_fidelityfx_loader_dx12.dll', 'runtime_local/amd/fidelityfx/amd_fidelityfx_framegeneration_dx12.dll')
    foreach ($f in $required) {
        if (!(Test-Path -LiteralPath (Join-Path $src $f) -PathType Leaf)) { throw "Origem nao possui $f. Selecione a pasta oficial correta." }
    }
    # The unmodified 3X/4X unlock only works with this audited XeFG provider.
    $expected = 'EC5E0C65E075570C6EDE72618BB666D0BE0C2E10B2EA9762C0FE8CB8E375AB27'
    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $src $required[0])).Hash
    if ($actual -ne $expected) { Write-Warning 'XeFG nao corresponde ao DLL auditado nesta fonte. A importacao nao garante 3X/4X; use o runtime da mesma versao oficial.' }
    foreach ($rel in $paths) {
        $target = Join-Path $dest $rel
        if (Test-Path -LiteralPath $target) { throw "Destino ja contem $rel. Use um pacote novo e vazio para nao misturar versoes." }
    }
    foreach ($rel in $paths) {
        $target = Join-Path $dest $rel
        New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $src $rel) -Destination $target -Recurse
    }
    foreach ($rel in $required) {
        $from = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $src $rel)).Hash
        $to = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $dest $rel)).Hash
        if ($from -ne $to) { throw "Falha na verificacao SHA256: $rel" }
        Write-Host "OK: $rel"
    }
    Write-Host 'Runtimes copiados e conferidos. Feche esta janela e abra veyra_qml_ui.exe.' -ForegroundColor Green
    exit 0
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host 'Nenhum arquivo da instalacao oficial foi modificado. Se a copia foi parcial, extraia novamente o pacote novo.'
    exit 1
}
