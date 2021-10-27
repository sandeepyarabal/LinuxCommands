labVal=$1
scriptFile=forward.sh

echo 'labVal = '$labVal

if [[ "$labVal" = "1" ]]; then

    SSH="sshpass -p 'password' ssh -o LogLevel=quiet -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "
    SCP="sshpass -p 'password' scp -o LogLevel=quiet -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "

    remoteComputer=User@ipaddress
    remoteDirectory=/home/san/install/Board

elif [[ "$labVal" = "2" ]]; then

    SSH="sshpass -p 'password' ssh -o LogLevel=quiet -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "
    SCP="sshpass -p 'password' scp -o LogLevel=quiet -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "

    remoteComputer=User@ipaddress
    remoteDirectory=/home/pat/install/Board
    scriptFile=callInstall.sh

else

    echo 'labValue specified was not valid = '$labVal
    exit -1;

fi

echo 'remoteComputer ='$remoteComputer

tarInstallFileDir=/root/install
tarFile=Install.tar
tarFile1=Install.sh

eval $SCP $tarInstallFileDir/$tarFile $remoteComputer:$remoteDirectory
eval $SCP $tarInstallFileDir/$tarFile1 $remoteComputer:$remoteDirectory

ERR=$?
if [ $ERR -eq 0 ];
then
    echo 'Successfully Copied '$tarFile
#    commands="$remoteDirectory/forward.sh;" 
    commands="$remoteDirectory/$scriptFile;" 
    echo 'Executing '$commands ' on '$remoteComputer
    commands2="$SSH $remoteComputer $commands"
    echo $commands2
    eval $SSH $remoteComputer $commands
else
    echo 'Copying '$tarFile' failed due to '$ERR
fi
