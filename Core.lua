function PDTHMenuFix:init()
end

if not PackageManager:loaded("core/packages/language_schinese") then
    PackageManager:load("core/packages/language_schinese")
end
if not PackageManager:loaded("core/packages/language_korean") then
    PackageManager:load("core/packages/language_korean")
end
if not PackageManager:loaded("core/packages/language_japanese") then
    PackageManager:load("core/packages/language_japanese")
end
if not PackageManager:loaded("core/packages/language_turkish") then
    PackageManager:load("core/packages/language_turkish")
end
if not PackageManager:loaded("core/packages/language_polish") then
    PackageManager:load("core/packages/language_polish")
end