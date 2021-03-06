function BowerInit{
	$currentProject = Get-Project
	$currentProjectDir 	= Split-Path($currentProject.FullName)
	
	Add-BowerDir
	Add-BowerFiles
	Show-BowerInitMessage
}

function BowerInstall{
	$currentProject 	= Get-Project
	$currentProjectDir	= Split-Path($currentProject.FullName)
	$vendorFolder 		= "$currentProjectDir\Scripts\vendor"
	$scriptsFolder		= "$currentProjectDir\Scripts"
	
	cd $scriptsFolder

	#locate the bower CMD on the packages folder under the project 
	$projectparent = [System.IO.Directory]::GetParent($currentProjectDir)
	$packagesPath = [System.IO.Path]::Combine($projectparent.FullName, "packages")
	$bowerCMDPath = [System.IO.Directory]::GetFiles($packagesPath, "bower.cmd", [System.IO.SearchOption]::AllDirectories)

	if($bowerCMDPath -ne $null){
		# Using bower.js - get it using Install-Package Bower.js
		Invoke-Expression ("$bowerCMDPath install")
		
		$vendorItem = (Get-ProjectItem "vendor" $currentProject.ProjectItems)
		if($vendorItem -ne $null){
			[System.IO.Directory]::GetDirectories($vendorFolder) `
			| %{
				Write-Host ( "Going to add bower drop to solution" + $_)
				$vendorItem.ProjectItems.AddFromDirectory($_)
			}
		}
		Write-Host "Bower Installed the required packages...."	
	}
	else{
		Write-Host "There is a problem finding the bower.cmd. Please reinstall BowerPower"
	}
}

function Show-BowerInitMessage{
	Write-Host "You should now change the Project name in the bower.json file"
}

function Get-ProjectItem($itemName, $projectItems){
	$projectItems | ForEach-Object{
		if($_.Name -eq $itemName) {return($_)}
		if($_.ProjectItems.Count -gt 0){Get-ProjectItem $itemName $_.ProjectItems}		
	}	
}

function Add-BowerDir(){
	$currentProject 	= Get-Project
	$currentProjectDir	= Split-Path($currentProject.FullName)
	$scriptsFolder 		= "$currentProjectDir\Scripts"
	$bowerTarget 		= "$scriptsFolder\vendor"
	$scriptsItem		= $null;
	
	if(Test-Path($scriptsFolder)){
		Write-Host "Scripts directory found.";
	}
	else{
		Write-Host "Script folder is: $scriptsFolder"
		New-Item $scriptsFolder -ItemType directory -Force
		$scriptsItem = $currentProject.ProjectItems.AddFromDirectory($scriptsFolder)
		Write-Host "Created the folder"
	}
	
	if(Test-Path($bowerTarget)){
		$vendor = (Get-ProjectItem "vendor" $currentProject.ProjectItems)
	
		if($vendor -eq $null){
			$scriptsItem = (Get-ProjectItem "Scripts" $currentProject.ProjectItems)
			$scriptsItem.ProjectItems.AddFromDirectory($bowerTarget)
		}
		else{
			Write-Host "Vendor folder is good"
		}
	}
	else{
		New-Item $bowerTarget -ItemType directory -Force
	}
	
	$vendor = (Get-ProjectItem "vendor" $currentProject.ProjectItems)
	if($vendor -eq $null){
		$scriptsItem.ProjectItems.AddFromDirectory($bowerTarget)
	}
}

function Add-BowerFiles(){
	$currentProject 	= Get-Project
	$currentProjectDir	= Split-Path($currentProject.FullName)
	$scriptsFolder 		= "$currentProjectDir\Scripts"
	
	Write-Host "All Scipts will be downloaded to: $scriptsFolder"
	
	$bowerrc 		= "$scriptsFolder\.bowerrc"
	$bowerjson		= "$scriptsFolder\bower.json"
	$bowerTarget	= "$scriptsFolder\vendor"

	if(Test-Path($bowerrc)){ Remove-Item $bowerrc -Force}
	if(Test-Path($bowerjson)){Remove-Item $bowerjson -Force}
	New-Item $bowerrc -type file -Force
	New-Item $bowerjson -type file -Force

	$content  = "{""directory"" : ""vendor""}"
	[System.IO.File]::WriteAllText($bowerrc, $content)

	$content = "{""name"": ""your project"", ""version"": ""1.0.0.0"", ""dependencies"": {""requirejs"": null}}"
	[System.IO.File]::WriteAllText($bowerjson, $content)

	#Add files from the script directory
	[void]$currentProject.ProjectItems.AddFromFile($bowerrc)
	[void]$currentProject.ProjectItems.AddFromFile($bowerjson)
}

Export-ModuleMember -Function * 