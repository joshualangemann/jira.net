import-module .\modules\io.psm1

properties {
  $base_directory = Resolve-Path ..\jira.net
	$publish_directory = "$base_directory\publish-net40"
	$build_directory = "$base_directory\build"
	$tools_directory = "$base_directory\tools"
	$src_directory = "$base_directory\jira.net"
	$output_directory = "$base_directory\output"
	$packages_directory = "$base_directory\packages"
	$sln_file = "$base_directory\Jira.net.sln"
	$target_config = "Debug"
	$framework_version = "v4.0"
	$version = "0.0.0.0"
	$date = Get-Date
	$timestamp = "" + $date.Year + "." + $date.Month + "." + $date.Day + "." + $date.Hour + "." + $date.Minute

	$build_output_directory = "$src_directory\bin\$target_config"
  
	$nunit_path = "$tools_directory\nunit\bin\nunit-console-x86.exe"
	

	if($runPersistenceTests -eq $null) {
		$runPersistenceTests = $false
	}
}

task default -depends Build

task Build -depends Clean, Compile #, Test, Package

task UpdateVersion {
	
	$vSplit = $version.Split('.')
	
	if($vSplit.Length -ne 4)
	{
		throw "Version number is invalid. Must be in the form of 0.0.0.0"
	}

	$major = $vSplit[0]
	$minor = $vSplit[1]

	$assemblyFileVersion = $version
	$assemblyVersion = "$major.$minor.0.0"

	$versionAssemblyInfoFile = "$src_directory/proj/VersionAssemblyInfo.cs"
	"using System.Reflection;" > $versionAssemblyInfoFile
	"" >> $versionAssemblyInfoFile
	"[assembly: AssemblyVersion(""$assemblyVersion"")]" >> $versionAssemblyInfoFile
	"[assembly: AssemblyFileVersion(""$assemblyFileVersion"")]" >> $versionAssemblyInfoFile
}

task Compile -depends Clean {
	exec { msbuild /nologo /verbosity:quiet $sln_file /p:Configuration=$target_config /p:TargetFrameworkVersion=v4.0 }
}

task Test -depends Compile {
	
	exec { &$nunit_path "$base_directory/Jira.Net.Tests/bin/$target_config/PulseDoc.UnitTests.dll" /framework=4.0.30319 }
}

task Package -depends Clean, Compile {
  
}

task Deploy -depends Package {

}

task Clean {
	
	Clean-Item $publish_directory -ea SilentlyContinue
    Clean-Item $output_directory -ea SilentlyContinue
}