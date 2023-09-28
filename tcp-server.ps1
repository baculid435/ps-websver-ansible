$url = "http://+:5003/"

$HttpListener = New-Object System.Net.HttpListener
$HttpListener.Prefixes.Add($url)
$HttpListener.Start()

Write-Output "Listening: $($url)"

While ($HttpListener.IsListening) {
    $HttpContext = $HttpListener.GetContext()
    $HttpRequest = $HttpContext.Request
    $RequestUrl = $HttpRequest.Url.OriginalString

    Write-Output "$RequestUrl"
    
    $HttpResponse = $HttpContext.Response
    $HttpResponse.Headers.Add("Content-Type", "application/json")
    $ResponseContent = '' 
    
    if ($HttpRequest.Url.LocalPath -eq '/ping') {
        $HttpResponse.StatusCode = 200
        $ResponseContent = '{"status": "ok"}'

        $username = "newUser"
        $password = "password@1234"
        
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        
        $op = Get-LocalUser | where-Object Name -eq $username | Measure-Object
        if ($op.Count -eq 0) {
            New-LocalUser -Name $username -Password $securePassword    
            
            #$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $user.UserName, $password
        
            # Launch Notepad.exe for the new user
            $processInfo = Start-Process -FilePath "notepad.exe" #-Credential $credential -PassThru
        
            Write-Output $processInfo
        }
        else {
            Write-Output "User already exists"
        }
    }
    else {
        $HttpResponse.StatusCode = 404
    }
    
    
    $ResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes($ResponseContent)
    $HttpResponse.ContentLength64 = $ResponseBuffer.Length
    $HttpResponse.OutputStream.Write($ResponseBuffer, 0, $ResponseBuffer.Length)
    $HttpResponse.Close()
}

Write-Output "Listening was stopped"


$HttpListener.Stop()