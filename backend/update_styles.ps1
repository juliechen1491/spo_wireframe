# PowerShell 腳本：批量更新 HTML 檔案以引用 styles.css

$files = @(
    "admin_coach_edit.html",
    "admin_school_edit.html", 
    "admin_registration_detail.html"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "處理檔案: $file"
        
        # 讀取檔案內容
        $content = Get-Content $file -Raw
        
        # 查找並替換 <style> 區塊
        # 使用正則表達式找到從 <style> 到 </style> 的所有內容
        $pattern = '(<title>[^<]*</title>)\s*<style>.*?</style>'
        $replacement = '$1' + "`r`n    <link rel=`"stylesheet`" href=`"styles.css`">"
        
        $newContent = $content -replace $pattern, $replacement, 'Singleline'
        
        # 如果內容有變化，就寫回檔案
        if ($newContent -ne $content) {
            Set-Content $file -Value $newContent
            Write-Host "已更新: $file"
        } else {
            Write-Host "無需更新: $file"
        }
    } else {
        Write-Host "檔案不存在: $file"
    }
}

Write-Host "完成所有檔案處理"