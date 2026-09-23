# Servidor local em PowerShell (usado quando o Node.js nao esta instalado)
$port = 3000
$root = Join-Path $PSScriptRoot 'docs'
$types = @{ '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.css'='text/css; charset=utf-8'; '.json'='application/json; charset=utf-8'; '.svg'='image/svg+xml'; '.png'='image/png'; '.ico'='image/x-icon' }
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Guia de Medicos MC rodando em http://localhost:$port  (feche esta janela para parar)"
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $p = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
  if ($p -eq '/') { $p = '/index.html' }
  $file = [IO.Path]::GetFullPath((Join-Path $root $p.TrimStart('/')))
  $res = $ctx.Response
  if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $ext = [IO.Path]::GetExtension($file)
    $res.ContentType = if ($types[$ext]) { $types[$ext] } else { 'application/octet-stream' }
    $res.Headers.Add('Cache-Control','no-cache')
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
  } else { $res.StatusCode = 404 }
  $res.Close()
}
