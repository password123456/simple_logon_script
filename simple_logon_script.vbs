'--------------------------------------------------------------------
' simple logon script for gathering informations
' supported on : windows XP- Windows 7 (not confirmed over windows 8)
' created by password123456
'---------------------------------------------------------------------

Option Explicit

Function RunCMD(strFileName)
	Dim objShell
	Set objShell = WScript.CreateObject("WScript.Shell")
	objShell.run strFileName
	Set objShell = Nothing
End Function

Function AccountName
	Dim WshNetwork
	Set WshNetwork = CreateObject("WScript.Network")
	AccountName = WshNetwork.UserName
	Set WshNetwork = Nothing
End Function

Function ComputerName
	Dim WshNetwork
	Set WshNetwork = CreateObject("WScript.Network")
	ComputerName = WshNetwork.ComputerName
	Set WshNetwork = Nothing
End Function

Function DomainName
	Dim WshNetwork
	Set WshNetwork = CreateObject("WScript.Network")
	DomainName = WshNetwork.UserDomain
	Set WshNetwork = Nothing
End Function

Function SERVER_IP
	Dim objWMIService, colItems, objItem
	Dim strcomputer	
	
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery("Select IPAddress from 

Win32_NetworkAdapterConfiguration WHERE IPEnabled=TRUE",,48)
	
	For Each objItem In colItems
		If Not IsNull(objItem.IPAddress) Then
			SERVER_IP = objItem.IPAddress(0)
			Exit For
		End If
	Next
End Function

Function GetAdminGroupUsers 
	Dim objWMIService
	Dim Item, strObjectPath, Membername, MemberDomain
	Dim strgroup 
	Dim GrpMembers
	
	GrpMembers = Empty
	strgroup = "Administrators"
     
	Dim sN, lN, sD, lD
	Set objWMIService = GetObject("winmgmts:\\" & ComputerName & "\root\CIMV2") _
				 ExecQuery("select * from Win32_GroupUser where " & "GroupComponent = " & chr(34) & "Win32_Group.Domain='" _
					      & Computername & "',Name='" & strGroup & "'" & Chr(34) )
					      
	For Each Item In objWMIService
	strObjectPath = Item.PartComponent
	sN = inStrRev(strObjectPath, "Name=""",-1,1)
	lN = Len(strObjectPath)-(sN+6)
	sD = inStrRev(strObjectPath, "Domain=""",-1,1)
	lD = (sN-2)-(sD+8)
	Membername = mid(strObjectPath, sN+6, lN)
	MemberDomain = mid(strObjectPath, sD+8,lD)
	GrpMembers =  GrpMembers & "(" _
		& MemberDomain & "\" & Membername & ")" & chr(44)
	Next

	If Len(GrpMembers) = 0 then GrpMembers = "<none>"
	GetAdminGroupUsers = GrpMembers
	Set objWMIService = Nothing
	
End Function


'Log files

	Dim fso, Pathname, objlogfile
	pathname = "D:\YOUR_LOGS_FILE_DIRECTORY\logs\["&DateValue(Now)&"]-script_result.log"
	
	set fso = CreateObject("scripting.filesystemobject")
		if fso.fileExists(pathname) then 
		    'if exits log files, open Append mode
		    set objLogfile = fso.OpenTextFile(pathname,8,true)
		else
		    'if not exits log files, create new log files
		    set objLogfile = fso.CreateTextFile(pathname,True)
		end if

On Error Resume Next

Dim objFSO, objFile

objLogfile.writeline ("time=["& now & "],computer=["& ComputerName &"."& Domainname &"],ip=[" & SERVER_IP & "],user=[" & Domainname & "\"& AccountName &"],Administrators=[" & GetAdminGroupUsers & "]" )

objLogfile.close


