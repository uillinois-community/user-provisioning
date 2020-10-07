#!/usr/bin/perl

use Getopt::Long;

#################### Default inputs ####################
#$role="admin";
$role="direct_member";
########################################################

GetOptions('user:s' => \$user,
           'token:s' => \$token,
           'email:s' => \$email,
           'org_name:s' => \$org_name,
           'role:s' => \$role,
           'file:s' => \$file);

die ("Must supply -user= parameter") unless $user;
die ("Must supply -token= parameter") unless $token;
	
if ($file eq ""){
	die ("Must supply -email= parameter") unless $email;
	die ("Must supply -org_name= parameter") unless $org_name;
};

if ($file){
	$filecontents = `cat $file`;
	@entries = split(/\n/,$filecontents);
	
	foreach $line (@entries){
		chomp $line;
		@input = split(/,/,$line);
		$email = @input[0];
		$org_name = @input[1];
		$role = @input[2];

	print "Sending GitHub invitation to $email for $org_name organization as a $role\n";		
	$invite = `curl -s -u \"$user:$token\" -X POST -H \"Accept: application/vnd.github.v3+json\" https://api.github.com/orgs/$org_name/invitations -d '{\"email\":\"$email\",\"role\":\"$role\"}'`;
	print "$invite";
	}
} else {
	print "Sending GitHub invitation to $email for $org_name organization as a $role\n";
	$invite = `curl -s -u \"$user:$token\" -X POST -H \"Accept: application/vnd.github.v3+json\" https://api.github.com/orgs/$org_name/invitations -d '{\"email\":\"$email\",\"role\":\"$role\"}'`;
	print "$invite";
}

# Send invitation format
# curl \
#  -u "username:personal_token" \
#  -X POST \
#  -H "Accept: application/vnd.github.v3+json" \
#  https://api.github.com/orgs/$org_name/invitations \
#  -d '{"email":$email,"role":$role}'