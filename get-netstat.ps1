function Get-Netstat
    {
        # Based heavily on code found at http://www.lazywinadmin.com/2014/08/powershell-parse-this-netstatexe.html
        
        #   TO DO:
        #   
        #   1.  remove ipv6 (netstat -anop TCP) and ipv6 replacement
        #   2.  change property names (LocalIP, LocalPort, ForeignIP, ForeignPort)

        $netstatData=netstat -anop TCP
        $netstatData=$netstatData[4..$($netstatData.count)]

        $formattedNetstatData=foreach ($netstatEntry in $netstatData)
        {

            # Replace IPV6 0.0.0.0 (::) with placeholder
            #$netstatEntry=$netstatEntry -replace "\[::\]", "[v6_0.0.0.0]"
            
            # Remove the whitespace at the beginning on the line
            $netstatEntry = $netstatEntry -replace '^\s+', ''
            
            # Split on whitespaces characters
            $netstatEntry = $netstatEntry -split '\s+'
            
            # Define Properties
            $netstatProperties = @{
                        Protocol = $netstatEntry[0]
                        LocalAddressIP = ($netstatEntry[1] -split ":")[0]
                        LocalAddressPort = ($netstatEntry[1] -split ":")[1]
                        ForeignAddressIP = ($netstatEntry[2] -split ":")[0]
                        ForeignAddressPort = ($netstatEntry[2] -split ":")[1]
                        State = $netstatEntry[3]
                        ProcessID = [INT]$netstatEntry[4]
                    }
            
            # Output object
            New-Object -TypeName PSObject -Property $netstatProperties
        }
    return $formattedNetstatData
    }