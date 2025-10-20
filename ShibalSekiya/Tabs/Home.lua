return function(Home)
    -- 🧠 Tab Info
    Window:Tab({
        Title = "Developer Info",
        Icon = "hard-drive"
    })

    local HttpService = game:GetService("HttpService")

    -------------------------------------------
    -- 🔗 Discord Invite Info
    -------------------------------------------
    local function LookupDiscordInvite(inviteCode)
        local url = string.format("https://discord.com/api/v10/invites/%s?with_counts=true", inviteCode)
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if not success then
            warn("[Discord] Gagal mendapatkan data invite:", response)
            return nil
        end
    end
    
    local	inviteCode = "vf5nUduRxq"
    local inviteData = LookupDiscordInvite(inviteCode)
    
    if inviteData then
        Home:Paragraph({
            Title = string.format("[DISCORD] %s", inviteData.name),
            Desc = string.format("Members: %d\nOnline: %d", inviteData.members, inviteData.online),
            Image = inviteData.icon,
            ImageSize = 50,
            Locked = true,
        })
    else
        warn("[Discord] Invite tidak valid.")
    end

    -------------------------------------------
    -- 🧑‍💻 GitHub Info
    -------------------------------------------
    local function LookupGitHubUser(username)
        local url = "https://api.github.com/users/" .. username
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)

        if not success then
            warn("[GitHub] Gagal mendapatkan data user:", response)
            return nil
        end

        local data = HttpService:JSONDecode(response)
        return {
            login = data.login or username,
            name = data.name or "No Name",
            repos = data.public_repos or 0,
            avatar = data.avatar_url or "",
        }
    end

    local githubData = LookupGitHubUser("ohmygod-king")
    if githubData then
        Home:Paragraph({
            Title = string.format("[GITHUB] %s", githubData.name),
            Desc = string.format("Username: %s\nRepos: %d", githubData.login, githubData.repos),
            Image = githubData.avatar,
            ImageSize = 50,
            Locked = true,
        })
    else
        warn("[GitHub] User tidak ditemukan.")
    end

    -------------------------------------------
    -- 🔁 Auto Rejoin on Error Prompt
    -------------------------------------------
    local TeleportService = game:GetService("TeleportService")
    local Player = game.Players.LocalPlayer

    if getgenv().AutoRejoinConnection then
        getgenv().AutoRejoinConnection:Disconnect()
    end

    getgenv().AutoRejoinConnection = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        task.wait()
        if child.Name == "ErrorPrompt" 
            and child:FindFirstChild("MessageArea") 
            and child.MessageArea:FindFirstChild("ErrorFrame") then

            task.wait(2)
            TeleportService:Teleport(game.PlaceId, Player)
        end
    end)
end