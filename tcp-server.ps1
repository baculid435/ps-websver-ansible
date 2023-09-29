# Define the URL to listen on, including the port.
$url = "http://+:5000/"

# Create a new HttpListener object to handle incoming HTTP requests.
$HttpListener = New-Object System.Net.HttpListener
$HttpListener.Prefixes.Add($url)

# Start listening for incoming requests.
$HttpListener.Start()

Write-Output "Listening: $($url)"

# Continuously listen for incoming requests.
While ($HttpListener.IsListening) {
    # Get the HTTP context and request from the HttpListener.
    $HttpContext = $HttpListener.GetContext()
    $HttpRequest = $HttpContext.Request
    $RequestUrl = $HttpRequest.Url.OriginalString

    Write-Output "$RequestUrl"
    
    # Get the HTTP response object and set the Content-Type header to JSON.
    $HttpResponse = $HttpContext.Response
    $HttpResponse.Headers.Add("Content-Type", "application/json")
    $ResponseContent = '' 
    
    # Check if the requested URL is "/launch".
    if ($HttpRequest.Url.LocalPath -eq '/launch') {
        $HttpResponse.StatusCode = 200
        $ResponseContent = '{"status": "ok"}'

        # Define a new username and password.
        $username = "newUser"
        $password = "password@1234"

        # Convert the password to a secure string.
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        
        # Check if a user with the specified username already exists.
        $op = Get-LocalUser | where-Object Name -eq $username | Measure-Object
        if ($op.Count -eq 0) {
            # If the user doesn't exist, create a new local user with the provided username and password.
            New-LocalUser -Name $Username -Password $securePassword -AccountNeverExpires   
            
            # Create user credential 
            $credential = New-Object System.Management.Automation.PSCredential -ArgumentList @($Username, $securePassword)
        
            # Launch Notepad.exe for the new user
            $processInfo = Start-Process -PassThru -FilePath 'notepad.exe' -Credential $credential -WorkingDirectory 'C:\Windows\System32'
            Write-Output $processInfo
        }
        else {
            # If the user already exists, output a message indicating so.
            Write-Output "User already exists"
        }
    }
    else {
        $HttpResponse.StatusCode = 404
    }
    
    # Convert the response content to a byte array and set the Content-Length header.    
    $ResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes($ResponseContent)
    $HttpResponse.ContentLength64 = $ResponseBuffer.Length

    # Write the response content to the output stream and close the response.
    $HttpResponse.OutputStream.Write($ResponseBuffer, 0, $ResponseBuffer.Length)
    $HttpResponse.Close()
}

# Output a message indicating that the server has stopped listening.
Write-Output "Listening was stopped"

# Stop the HttpListener.
$HttpListener.Stop()