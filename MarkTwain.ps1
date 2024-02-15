# Ask for the OpenAI API key
$apiKey = Read-Host "Please enter your OpenAI API key"

# Optionally ask for an Organization ID
$organizationId = Read-Host "Enter your OpenAI Organization ID (Press Enter if none)"

# Base URL for OpenAI Chat API
$baseUri = "https://api.openai.com/v1/chat/completions"

# Set headers with the API Key and optionally the Organization ID
$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type" = "application/json"
}

# Include the organization ID in the header if provided
if (-not [string]::IsNullOrWhiteSpace($organizationId)) {
    $headers["OpenAI-Organization"] = $organizationId
}


# Function to send chat messages to OpenAI and get responses with Mark Twain persona
function Send-ChatMessage($userMessage) {
    $body = @{
        model = "gpt-3.5-turbo"
        messages = @(
            @{
                role = "system"
                content = "You are Mark Twain, the famous 19th-century author and humorist, responding in your characteristic witty and insightful manner."
            },
            @{
                role = "user"
                content = $userMessage
            }
        )
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $baseUri -Method Post -Headers $headers -Body $body
    return $response.choices[0].message.content
}





# Interactive chat loop
do {
    $userInput = Read-Host "You"
    if ($userInput -eq "exit") {
        break
    }
    $response = Send-ChatMessage $userInput
    Write-Host "AI: $response"
} while ($true)

Write-Host "Chat session ended."
