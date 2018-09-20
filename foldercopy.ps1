Param(
                [Parameter(Mandatory=$true)]
                $input_dir=$args[0],
                [Parameter(Mandatory=$true)]
                $output_dir=$args[1]
     )

Write-Output ("Start time: " + (Get-Date -f yyyyMMddhhssss))
Write-Output (" ") 

$cnt = 0

# Get invalid characters and escape them for use with RegEx
$illegal = [Regex]::Escape( -join [System.Io.Path]::GetInvalidFileNameChars())
$pattern = "[$illegal]"

$files = Get-ChildItem -Recurse -File $input_dir

if (!(Test-Path -Path $output_dir))
{
    
    New-Item -ItemType directory -Path $output_dir
    Write-Output ("Created Output Directory: " + $output_dir)
    Write-Output (" ")

}

ForEach ($file in $files) 
{

    $invalid = [regex]::Matches((Split-Path $file.FullName -Leaf), $pattern, 'IgnoreCase').Value | Sort-Object -Unique 
    $hasInvalid = $invalid -ne $null

    if ($hasInvalid)
    {

        Write-Output ("File Name " + (Split-Path $file.FullName -Leaf) + 'has invalid character(s): ' + $invalid) 
        Write-Output ("Skip Copying File.... " + $file.FullName) 
        Write-Output (" ")
    }
    else
    {
        Write-Output ("File Name " + (Split-Path $file.FullName -Leaf) + ' OK!') 
        Write-Output ("Start To Copy File.... " + $file.FullName) 
        Write-Output (" ")
    
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.fullname)
        $newfilename = $baseName + '_Copy' + $file.extension
        $filePath = Join-Path -Path $output_dir -ChildPath ($newfilename)
        $file.FullName | Copy-Item -Destination $filePath

    }

if (-not (Test-Path $filePath))
{
    
    Write-Output ("Failed To Create File.... " + $filePath) 
    Write-Output (" ") 
    
}

else {
  
    $filescopied = ($cnt++).ToString() 
    Write-Output ("Created File.... " + $filePath) 
    Write-Output ("Total Files Copied.... " + $filescopied) 
    Write-Output (" ") 

     }
   
}

Write-Output ("End time: " + (Get-Date -f yyyyMMddhhssss))
Write-Output (" ") 
