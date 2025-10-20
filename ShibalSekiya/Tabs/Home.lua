return function(Home)
    Window:Tab({
        Title = "Developer Info",
        Icon = "hard-drive"
    })

     
     local HttpService = game:GetService("HttpService")
     local RunService = game:GetService("RunService")

    local InviteAPI = "https://discord.com/api/v10/invites/"
    local function LookupDiscordInvite(inviteCode)
        local url = InviteAPI .. inviteCode .. "?with_counts=true"
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
    
        if success then
            local data = HttpService:JSONDecode(response)
            return {
                name = data.guild and data.guild.name or "Unknown",
                id = data.guild and data.guild.id or "Unknown",
                online = data.approximate_presence_count or 0,
                members = data.approximate_member_count or 0,
                icon = data.guild and data.guild.icon
                    and "https://cdn.discordapp.com/icons/"..data.guild.id.."/"..data.guild.icon..".png"
                    or "",
            }
        else
            warn("Gagal mendapatkan data invite.")
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
        warn("Invite tidak valid.")
    end
    
    local GitHubAPI = "https://api.github.com/users/"
    
    local function LookupGitHubUser(username)
        local url = GitHubAPI .. username
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
    
        if success then
            local data = HttpService:JSONDecode(response)
            return {
                login = data.login or username,
                name = data.name or "No Name",
                bio = data.bio or "No bio available",
                followers = data.followers or 0,
                following = data.following or 0,
                repos = data.public_repos or 0,
                avatar = data.avatar_url or "",
                html_url = data.html_url or "",
            }
        else
            warn("Gagal mendapatkan data GitHub.")
            return nil
        end
    end
    
    local githubUsername = "ohmygod-king" 
    local githubData = LookupGitHubUser(githubUsername)
    
    if githubData then
        Home:Paragraph({
            Title = string.format("[GITHUB] %s", githubData.name),
            Desc = string.format(
                "Username: %s\nRepos: %d",
                githubData.login,
                githubData.repos
            ),
            Image = githubData.avatar,
            ImageSize = 50,
            Locked = true,
        })
    else
        warn("GitHub user tidak ditemukan.")
    end
    
    if getgenv().AutoRejoinConnection then
        getgenv().AutoRejoinConnection:Disconnect()
        getgenv().AutoRejoinConnection = nil
    end
    
    getgenv().AutoRejoinConnection = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        task.wait()
        if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
            local TeleportService = game:GetService("TeleportService")
            local Player = game.Players.LocalPlayer
            task.wait(2) 
            TeleportService:Teleport(game.PlaceId, Player)
        end
    end)
end

-------------------------------------------
----- =======[ HOME TAB ]
-------------------------------------------