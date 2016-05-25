#!/usr/bin/perl -w
## Project: Project #8
## Author: Richard Shepard (rshepard@student.ncmich.edu)
## Version: 12.08.14.006
## Purpose: This program completly removes a user/users from a server, zips all files 
##          and stores them on the hard drive, removes original files and directories,
##          and finally creates a list of users removed and the location of the archived files

use 5.14.2;
use warnings;
use Time::Local;

my (@usersToBeRemoved);
my ($size);
use constant DATA_FILE_OUT => "/home/user_archive/deleted_USERS.txt";

sub main {
     confirmARGS();
     loadArgsToUsers();
     setSize();
     displayMessage();
     createWorkingDir();
     cleanseSystem();
}

main();

sub confirmARGS{
     if (!(@ARGV)) {
		die "\n\nYou must enter proper usernames as command arguments.\n\n";
	}
}

sub displayMessage {
     system("clear");
     my $temp = 0;
     print "This program removes user/users, zips their files, and removes the originals.\n";
     print "You have chosen to remove the folowing user/users:";
     for(my $i = 0; $i < $size; $i++) {
          $temp = $i + 1;
          print "\n$temp. $usersToBeRemoved[$i]";
          if ($i == $size - 1) {
               print "\n--------------------------\n";
               print "$temp users to be removed\n";
          }
     }
     print "Press enter to remove user or Q enter to QUIT: ";
     chomp ($temp = <STDIN>);
     if ($temp eq "Q") {
          die "\n\nGood Bye\n\n";
     }
}

sub loadArgsToUsers {
     my $size = @ARGV;
     for (my $i = 0; $i < $size; $i++) {
          $usersToBeRemoved[$i] = $ARGV[$i];
     }
}

sub setSize {
     $size = @usersToBeRemoved;
}

sub createWorkingDir {
     system ("mkdir /home/user_archive");
}

sub cleanseSystem {
     setLogHeader();
     for (my $i = 0; $i < $size; $i++) {
          my $user= $usersToBeRemoved[$i];
          my $archiveFile = "/home/user_archive/${user}_archive.zip";
          findAndZip($user,$archiveFile);
          addUserToLog($user,$archiveFile);
          removeUserDir($user);
          removeUser($user)
     }
}

sub findAndZip {
     my $user = $_[0];
     my $archiveFile = $_[1];
     my $findAndZipCMD = "find /home -user ${user} -exec zip ${archiveFile} {} \\;";
     print "\nFinding $user and relocating files\n";
     system ($findAndZipCMD);
}

sub setLogHeader {
     my $currentDate = localtime;
     my $OUT;
     open ($OUT, '>>', DATA_FILE_OUT);
		print ($OUT "\nUsers removed on $currentDate and location of archived file\n");
          print ($OUT "============================================================\n\n\n");
          print ($OUT " USER                    Location\n");
          print ($OUT "------                  ----------\n");
	close $OUT;
}

sub addUserToLog {
     my $OUT;
     my $user = $_[0];
     my $archiveFile = $_[1];
	open ($OUT, '>>', DATA_FILE_OUT);
		print ($OUT "$user                    $archiveFile\n");
	close $OUT;
}

sub removeUserDir {
     my $user = $_[0];
     my $userDir = "/home/$user";
     my $removeDirCMD = "rm -rf ${userDir}";
     print "\nRemoving $user dir at $userDir\n";
     system ($removeDirCMD);
}

sub removeUser {
     my $user =$_[0];
     my $removeUserCMD = "userdel -r ${user}";
     print "\nRemoving User: $user\n";
     system ($removeUserCMD);
}