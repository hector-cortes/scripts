# Overview
A simple script to generate named profiles for an AWS CLI configuration file. It uses the AWS CLI to grab the list
of accounts in your AWS Organization, and then uses it to generate a named profile for each account.

## Lessons learned
### IFS Variable
* Input Field Separator (or Internal Field Separator)
  * Default value is tab, space, and newline
  * Tells the shell how to split words

Since I wanted to add each line that was output from the _aws organizations list-accounts_ command as a unique entry to an array, I should set IFS to null (so no field splitting is performed), and then read in each line explicitly using read -r line

### Process substitution
Essentially saves the output of a command to a temporary file (which gets destroyed automatically). The name of the temporary file is then passed on to the command that's being redirected to. Whatever command that is treats it as a regular file name. 

This came in handy when trying to loop over the contents of the variable _account_info_ (which is an array, where each entry in the array consists of two strings). Process substitution let me echo the contents of _account_info_, and then use read to grab each line and save the contents to two variables called id and name.

EDIT: The output is saved to a named pipe and not an actual file. Some more info about named pipes:
  https://askubuntu.com/questions/449132/why-use-a-named-pipe-instead-of-a-file

### Heredoc
A Here document is a type of redirection that allows you to pass multiple lines of input to a command. I used it to create a 'template' of sorts. I wanted a to use a template so that I could have an easy way to insert the values received from the aws organizations list-accounts command into a text block that was formatted per the AWS config file requirements for named profiles.

### Shellcheck warnings generated throughout development
https://github.com/koalaman/shellcheck/wiki/SC2207
