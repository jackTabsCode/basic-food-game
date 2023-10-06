_G.__DEV__ = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local App = require(script.Parent:WaitForChild("app"))

local root = ReactRoblox.createRoot(Instance.new("Folder"))
root:render(ReactRoblox.createPortal(e(App), PlayerGui))

print("Hey")
