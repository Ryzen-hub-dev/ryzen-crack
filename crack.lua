-- Load WindUI library from GitHub
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/WindUI.lua"))()

-- Create the main window
local Window = WindUI:CreateWindow({
    Title = "Fake Executor - Script Capture",
    Size = UDim2.new(0, 400, 0, 300)
})

-- Add section for input
local Section = Window:CreateSection("Script Loader")

-- Input textbox for URL
local UrlInput = Section:CreateTextbox({
    Title = "Script URL",
    Placeholder = "Enter script URL here",
    Callback = function(text)
        -- Optional: Store URL if needed
    end
})

-- Button to load and capture script
local LoadButton = Section:CreateButton({
    Title = "Load & Capture (Fake Execute)",
    Callback = function()
        local url = UrlInput.Text
        if url == "" then
            warn("Please enter a URL")
            return
        end

        -- Capture script content using HttpGet
        local success, content = pcall(function()
            return game:HttpGet(url)
        end)

        if not success then
            warn("Failed to fetch script: " .. content)
            return
        end

        -- Extract file name from URL (last part after /)
        local fileName = url:match("([^/]+)$") or "Unknown.lua"

        -- Display file name
        FileNameLabel.Text = "Captured File: " .. fileName

        -- Display content in textbox
        ContentBox.Text = content

        -- Log or "capture" (here just display, but you can add more logic like saving to table)
        print("Captured script: " .. fileName)
    end
})

-- Label for file name
local FileNameLabel = Section:CreateLabel("Captured File: None")

-- Textbox for script content (readonly)
local ContentBox = Section:CreateTextbox({
    Title = "Script Content",
    Placeholder = "Script content will appear here",
    MultiLine = true,
    ReadOnly = true
})

-- Button to copy content
local CopyButton = Section:CreateButton({
    Title = "Copy Content",
    Callback = function()
        if ContentBox.Text ~= "" then
            setclipboard(ContentBox.Text)
            print("Content copied to clipboard!")
        else
            warn("No content to copy")
        end
    end
})

-- Notify user the GUI is ready
print("Fake Executor GUI loaded. Use it to capture scripts.")
