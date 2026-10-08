Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("C:/Users/PCv/StudioProjects/smash_up_india/assets/images/find_Games/dark.png")
$c1 = $bmp.GetPixel(10, 10)
$c2 = $bmp.GetPixel($bmp.Width / 2, $bmp.Height / 2)
$c3 = $bmp.GetPixel($bmp.Width / 2, $bmp.Height - 10)
Write-Host "Color 1: $($c1.R) $($c1.G) $($c1.B)"
Write-Host "Color 2: $($c2.R) $($c2.G) $($c2.B)"
Write-Host "Color 3: $($c3.R) $($c3.G) $($c3.B)"
